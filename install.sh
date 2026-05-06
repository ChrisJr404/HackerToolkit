#!/bin/bash
# =============================================================================
# HackerToolkit installer — penetration testing, red teaming, bug bounty
# https://github.com/ChrisJr404/HackerToolkit
# =============================================================================

# ---- Strict-ish mode ---------------------------------------------------------
# We don't enable `set -e` because each tool install is allowed to fail
# independently — the script tracks per-tool status and continues. We do
# enable -u (catches unset vars) and pipefail (catches pipe-stage failures).
set -uo pipefail

# ---- Color palette -----------------------------------------------------------
# Use tput when available; fall back to raw escapes so the script stays portable
# on minimal containers without ncurses. Disable colors when stdout isn't a TTY
# (CI, redirected log files) so the output stays grep-friendly.
if [ -t 1 ] && command -v tput >/dev/null 2>&1 && [ "$(tput colors 2>/dev/null || echo 0)" -ge 8 ]; then
    BOLD=$(tput bold);   DIM=$(tput dim)
    RED=$(tput setaf 1); GRN=$(tput setaf 2); YLL=$(tput setaf 3)
    BLU=$(tput setaf 4); MAG=$(tput setaf 5); CYN=$(tput setaf 6); WHT=$(tput setaf 7)
    NC=$(tput sgr0)
else
    BOLD=''; DIM=''; RED=''; GRN=''; YLL=''; BLU=''; MAG=''; CYN=''; WHT=''; NC=''
fi
sh='#!/bin/bash\n'

# ---- Pretty-print helpers ----------------------------------------------------
hr()      { printf '%b\n' "${DIM}$(printf '─%.0s' $(seq 1 78))${NC}"; }
hdr()     { printf '\n%b\n' "${BOLD}${CYN}❯ $1${NC}"; hr; }
ok()      { printf '%b %s\n' "${GRN}✓${NC}" "$1"; }
warn()    { printf '%b %s\n' "${YLL}!${NC}" "$1"; }
err()     { printf '%b %s\n' "${RED}✗${NC}" "$1"; }
info()    { printf '%b %s\n' "${BLU}ℹ${NC}" "$1"; }

# safe_cd <dir> — fail loudly if a category dir is missing instead of silently
# landing the next install in the wrong cwd.
safe_cd() {
    cd "$1" 2>/dev/null || { err "cd '$1' failed (cwd=$(pwd))"; exit 1; }
}

# ---- CLI arg parser ----------------------------------------------------------
# Flags:
#   -h, --help              show usage
#   -l, --list              list all tools (grouped by category) and exit
#       --only=a,b,c        install only these tools (comma-separated names)
#       --skip=a,b,c        install everything except these tools
#       --only-cat=X,Y      install only these categories (e.g. Recon-Frameworks)
#       --skip-cat=X,Y      skip these categories
ONLY=""; SKIP=""; ONLY_CAT=""; SKIP_CAT=""; LIST_MODE=0
usage() {
    cat <<USAGE
${BOLD}HackerToolkit installer${NC}

Usage: ./install.sh [OPTIONS]

  -h, --help               Show this help and exit
  -l, --list               Print every tool grouped by category, then exit
      --only=a,b,c         Install only these tools (by pck name)
      --skip=a,b,c         Skip these tools
      --only-cat=X,Y       Install only these categories
      --skip-cat=X,Y       Skip these categories

Categories follow the directory names under ./HackerToolkit/, e.g.
  Enumeration-Recon-Tools  Apex-Domain-Enumeration  Recon-Frameworks
  Subdomain-Enumeration-and-Brute-Force  Active-Directory  Linux-Privilege-Escalation
  Windows-Privilege-Escalation  Vulnerability-Scanners  C2  Phishing-Smishing-Etc
  Stealth  ... (run ${BOLD}--list${NC} to see them all)

Examples:
  ./install.sh --only=ffuf,gobuster,nuclei
  ./install.sh --skip-cat=C2,Phishing-Smishing-Etc
  ./install.sh --only-cat=Subdomain-Enumeration-and-Brute-Force
USAGE
}
while [ $# -gt 0 ]; do
    case "$1" in
        -h|--help)        usage; exit 0;;
        -l|--list)        LIST_MODE=1;;
        --only=*)         ONLY="${1#--only=}";;
        --skip=*)         SKIP="${1#--skip=}";;
        --only-cat=*)     ONLY_CAT="${1#--only-cat=}";;
        --skip-cat=*)     SKIP_CAT="${1#--skip-cat=}";;
        *)                err "unknown flag: $1"; usage; exit 2;;
    esac
    shift
done

# ---- Architecture detection --------------------------------------------------
# Used by tools that download arch-pinned binaries (mubeng, evilginx, etc.).
case "$(uname -m)" in
    x86_64|amd64)   ARCH="amd64";   ARCH_ALT="x86_64";;
    aarch64|arm64)  ARCH="arm64";   ARCH_ALT="aarch64";;
    armv7l|armv6l)  ARCH="armv7";   ARCH_ALT="arm";;
    *)              ARCH="$(uname -m)"; ARCH_ALT="$ARCH";;
esac
OS_KERNEL="$(uname -s | tr '[:upper:]' '[:lower:]')"   # linux / darwin

# ---- Dependency check --------------------------------------------------------
# Returns 0 if the binary already resolves; otherwise installs via apt and
# returns 1 so callers can branch if needed. Pass arg 2 to override the
# package name when it differs from the binary (e.g. exist 7z p7zip-full).
exist(){
    if [ -z "$(command -v "$1" 2>/dev/null)" ]; then
        warn "$1 not found — installing"
        sudo apt -y install "${2:-$1}" >/dev/null 2>&1 \
            && ok "$1 installed" \
            || err "$1 install failed"
        return 1
    fi
    return 0
}

# ---- Per-tool install helpers ------------------------------------------------
# Single-source-of-truth wrapper around the "is it installed already? install
# it. did it work?" pattern that used to be open-coded in every block. Cuts
# per-tool boilerplate from ~12 lines to ~3-4.
#
# Usage:
#   pck="ffuf"
#   if try_install "$pck"; then
#       go install github.com/ffuf/ffuf/v2@latest
#       mark_install "$pck"
#   fi
#
# `set_category <Name>` is called at the top of each section so --only-cat /
# --skip-cat filters work.
CURRENT_CATEGORY="(none)"
set_category() {
    CURRENT_CATEGORY="$1"
    if [ "$LIST_MODE" = 1 ]; then
        printf "\n${BOLD}${CYN}━━ %s ━━${NC}\n" "$1"
    else
        printf "\n${BOLD}${CYN}━━ %s ━━${NC}\n" "$1"
    fi
}

# Membership test that handles whitespace-tolerant comma lists.
_in_list() {
    local needle="$1" haystack=",$2,"
    case "$haystack" in *",$needle,"*) return 0;; esac
    return 1
}

# Returns 0 if the caller should proceed with the install body, 1 to skip.
# Skips if: --only / --skip / --only-cat / --skip-cat exclude it, --list mode,
# or the binary is already on PATH.
try_install() {
    local pck="$1"

    # Filter on category
    if [ -n "$ONLY_CAT" ] && ! _in_list "$CURRENT_CATEGORY" "$ONLY_CAT"; then return 1; fi
    if [ -n "$SKIP_CAT" ] &&   _in_list "$CURRENT_CATEGORY" "$SKIP_CAT"; then return 1; fi

    # Filter on tool name
    if [ -n "$ONLY" ] && ! _in_list "$pck" "$ONLY"; then return 1; fi
    if [ -n "$SKIP" ] &&   _in_list "$pck" "$SKIP"; then return 1; fi

    if [ "$LIST_MODE" = 1 ]; then
        printf "  • %s\n" "$pck"
        return 1
    fi

    if command -v "$pck" >/dev/null 2>&1; then
        printf "  ${BLU}↺${NC} ${BOLD}%s${NC} ${DIM}already installed — skipping${NC}\n" "$pck"
        return 1
    fi

    printf "  ${YLL}▸${NC} ${BOLD}%s${NC} ${DIM}installing…${NC}\n" "$pck"
    return 0
}

# Records based on $? (or explicit second arg) whether the install body succeeded.
# Captured to install.tmp / not-install.tmp for the final summary tally.
mark_install() {
    local pck="$1"
    local rc="${2:-$?}"
    if [ "$rc" -eq 0 ]; then
        printf "  ${GRN}✓${NC} %s ${DIM}installed${NC}\n" "$pck"
        echo "Installed $pck" >> "$mypath/install.tmp"
    else
        printf "  ${RED}✗${NC} %s ${RED}install failed${NC} ${DIM}(rc=%s)${NC}\n" "$pck" "$rc"
        echo "Not Installed $pck (rc=$rc)" >> "$mypath/not-install.tmp"
    fi
}

# Variant of try_install for tools that don't put a binary on PATH — instead
# the install creates a directory under the current category folder. Skips if
# the directory already exists.
try_install_dir() {
    local pck="$1"
    local dir="${2:-$pck}"

    if [ -n "$ONLY_CAT" ] && ! _in_list "$CURRENT_CATEGORY" "$ONLY_CAT"; then return 1; fi
    if [ -n "$SKIP_CAT" ] &&   _in_list "$CURRENT_CATEGORY" "$SKIP_CAT"; then return 1; fi
    if [ -n "$ONLY" ] && ! _in_list "$pck" "$ONLY"; then return 1; fi
    if [ -n "$SKIP" ] &&   _in_list "$pck" "$SKIP"; then return 1; fi

    if [ "$LIST_MODE" = 1 ]; then
        printf "  • %s ${DIM}(directory-tracked)${NC}\n" "$pck"
        return 1
    fi

    if [ -d "$dir" ]; then
        printf "  ${BLU}↺${NC} ${BOLD}%s${NC} ${DIM}directory exists — skipping${NC}\n" "$pck"
        return 1
    fi

    printf "  ${YLL}▸${NC} ${BOLD}%s${NC} ${DIM}cloning…${NC}\n" "$pck"
    return 0
}

# ---- Banner ------------------------------------------------------------------
clear 2>/dev/null || true
cat <<BANNER
${BOLD}${CYN}
   ██╗  ██╗ █████╗  ██████╗██╗  ██╗███████╗██████╗
   ██║  ██║██╔══██╗██╔════╝██║ ██╔╝██╔════╝██╔══██╗
   ███████║███████║██║     █████╔╝ █████╗  ██████╔╝
   ██╔══██║██╔══██║██║     ██╔═██╗ ██╔══╝  ██╔══██╗
   ██║  ██║██║  ██║╚██████╗██║  ██╗███████╗██║  ██║
   ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝
        ${MAG}████████╗ ██████╗  ██████╗ ██╗     ██╗  ██╗██╗████████╗
        ╚══██╔══╝██╔═══██╗██╔═══██╗██║     ██║ ██╔╝██║╚══██╔══╝
           ██║   ██║   ██║██║   ██║██║     █████╔╝ ██║   ██║
           ██║   ██║   ██║██║   ██║██║     ██╔═██╗ ██║   ██║
           ██║   ╚██████╔╝╚██████╔╝███████╗██║  ██╗██║   ██║
           ╚═╝    ╚═════╝  ╚═════╝ ╚══════╝╚═╝  ╚═╝╚═╝   ╚═╝
${NC}
   ${BOLD}Comprehensive Pentest / Red Team / Bug-Bounty Suite${NC}
   ${DIM}https://github.com/ChrisJr404/HackerToolkit${NC}
BANNER
hr
if [ "$LIST_MODE" = 1 ]; then
    info "${BOLD}--list${NC} active — printing tools without installing."
elif [ -n "$ONLY" ] || [ -n "$SKIP" ] || [ -n "$ONLY_CAT" ] || [ -n "$SKIP_CAT" ]; then
    info "Filter active:  ${ONLY:+only=${BOLD}${ONLY}${NC} }${SKIP:+skip=${BOLD}${SKIP}${NC} }${ONLY_CAT:+only-cat=${BOLD}${ONLY_CAT}${NC} }${SKIP_CAT:+skip-cat=${BOLD}${SKIP_CAT}${NC}}"
else
    info "Stay at the keyboard — a few steps need sudo / interactive prompts."
fi
info "Architecture:   ${BOLD}${OS_KERNEL}/${ARCH}${NC}"
info "Per-tool log:   install.tmp (success) / not-install.tmp (failures, with rc)"
hr

# ---- Pre-flight ----------------------------------------------------------
# Catch the cheap-to-detect failure modes here so we don't blow up 40 minutes
# into a half-installed state.
[ "$LIST_MODE" = 1 ] || hdr "Pre-flight checks"
preflight_ok=1

# Linux only — most install blocks shell-out to `apt`. macOS will need ports.
if [ "$LIST_MODE" != 1 ]; then
    if [ "$OS_KERNEL" = "linux" ]; then
        ok "OS: linux"
    else
        warn "OS: ${OS_KERNEL} — apt-based blocks will fail; expect partial install."
    fi
fi

# Internet
if [ "$LIST_MODE" != 1 ]; then
    if curl -sSfI --max-time 5 https://github.com >/dev/null 2>&1 || \
       wget -q --spider --timeout=5 https://github.com 2>/dev/null; then
        ok "Internet: github.com reachable"
    else
        err "Internet: github.com not reachable — aborting."
        exit 1
    fi
fi

# sudo cached or non-interactive
if [ "$LIST_MODE" != 1 ]; then
    if sudo -n true 2>/dev/null; then
        ok "sudo: cached"
    else
        warn "sudo: will prompt for password during apt installs"
    fi
fi

# Free disk: need at least 2GB
if [ "$LIST_MODE" != 1 ]; then
    free_kb=$(df -Pk . 2>/dev/null | awk 'NR==2 {print $4+0}')
    if [ "${free_kb:-0}" -ge 2000000 ]; then
        ok "Disk: $((free_kb / 1024 / 1024))G free"
    else
        warn "Disk: only $((${free_kb:-0} / 1024 / 1024))G free — recommend ≥ 2G"
    fi
fi
[ "$LIST_MODE" = 1 ] || hr

# - Main folder
mkdir -p HackerToolkit/.bin
safe_cd HackerToolkit
mypath="$(pwd)"

# Idempotency: truncate per-tool logs at the start of each run so re-runs
# don't double-count or carry stale failures from a prior attempt.
: > "$mypath/install.tmp"
: > "$mypath/not-install.tmp"


PATH="$PATH:$(pwd)/.bin"
if [ -e "$mypath/.bin/hackertoolkit_bash" ]; then

    regexHackPath="$mypath/.bin/hackertoolkit_bash"
    if [[ "$PATH" =~ $regexHackPath ]];then
        echo "HackerToolkit executable path found!"
    else
        source $mypath/.bin/hackertoolkit_bash
    fi
else 
    echo "HackerToolkit executable path was not found!"
    echo "export PATH=\$PATH:$(pwd)/.bin" >>$(pwd)/.bin/hackertoolkit_bash
    PATH=$PATH:$(pwd)/.bin
    export PATH  
fi


# echo "john: $(which john)"
# echo "relations: $(which relations)"
# echo "karma_v2: $(which karma_v2)"
# echo "BloodHound: $(which BloodHound)"

# exit 0


# - Dependencies
# - If the executable file is found nothing happen
# In --list mode we skip both the dep installs and the Go bootstrap so the
# listing is fast and side-effect-free.
if [ "$LIST_MODE" = 1 ]; then
    info "Skipping dependency installs (--list mode)"
else
    info "Stay at the keyboard — a few steps need sudo / interactive prompts."
    sleep 2
    exist git
    exist wget
    exist gcc
fi

# - Local Go toolchain (latest stable, auto-detected, arch-aware)
# Avoids fighting with the system package manager's pinned version. We always
# fetch the latest release tag from go.dev/VERSION?m=text and install under
# .bin/go/. If the tarball is already cached we skip the download.
if [ "$LIST_MODE" != 1 ]; then
    info "Bootstrapping local Go toolchain (${OS_KERNEL}/${ARCH})…"
    safe_cd .bin
    GO_VERSION=$(curl -sS --max-time 10 https://go.dev/VERSION?m=text 2>/dev/null | head -1)
    if [ -z "${GO_VERSION:-}" ] || [[ "$GO_VERSION" != go* ]]; then
        warn "Could not auto-detect Go version — falling back to go1.24.0"
        GO_VERSION="go1.24.0"
    fi
    GO_TARBALL="${GO_VERSION}.${OS_KERNEL}-${ARCH}.tar.gz"
    if [ ! -d "$mypath/.bin/go" ]; then
        if [ ! -e "$mypath/.bin/${GO_TARBALL}" ]; then
            wget -q --show-progress "https://go.dev/dl/${GO_TARBALL}" || \
                { err "go download failed for ${GO_TARBALL}"; exit 1; }
        fi
        tar -C . -xzf "${GO_TARBALL}"
    fi
    "$mypath/.bin/go/bin/go" version
    alias go="$mypath/.bin/go/bin/go"

    if grep -qF "GOPATH=\$HOME/go" "$mypath/.bin/hackertoolkit_bash" 2>/dev/null; then
        info "Go PATH already configured."
    else
        export GOPATH="$HOME/go"
        {
            echo 'export GOPATH=$HOME/go;'
            echo 'export PATH=$PATH:$HOME/go/bin'
        } >>"$mypath/.bin/hackertoolkit_bash"
        export PATH="$PATH:$HOME/go/bin"
        "$mypath/.bin/go/bin/go" env -w CGO_ENABLED=1
    fi

    safe_cd ..

    exist pip3 "python3-pip"
    exist pipx
    exist jq
    exist lolcat
    exist unzip
    exist cargo rust-all
    exist perl
    exist make
    exist realpath coreutils
    exist 7z
    exist rsync
    exist snap snapd
fi

regexPIPXexPath="$HOME/\.local/bin"
if [[ "$PATH" =~ $regexPIPXexPath ]];then
    echo "pipx executable path found!"
else
    echo "No, pipx executable path was not found!"
    PATH="$PATH:$HOME/.local/bin"
    export PATH
    echo "export PATH=\$PATH:\$HOME/.local/bin" >>$mypath/.bin/hackertoolkit_bash
    
fi

# - Enumeration & Recon Tools
set_category "Enumeration-Recon-Tools"
mkdir -p "Enumeration-Recon-Tools"
safe_cd "Enumeration-Recon-Tools"
## Ad & Analytic Trackers
set_category "Ad-Analytic-Trackers"
mkdir -p "Ad-Analytic-Trackers"
safe_cd "Ad-Analytic-Trackers"

### relations.sh
pck="relations"
if try_install "$pck"; then
    wget -O $pck https://gist.github.com/hateshape/393ab7003023f3b13126a4892100c8ff
    chmod +x relations.sh
    ln -s $(realpath relations.sh) $mypath/.bin/relations
    mark_install "$pck"
fi
safe_cd ..
## Apex Domain Enumeration
set_category "Apex-Domain-Enumeration"
mkdir -p "Apex-Domain-Enumeration"
safe_cd "Apex-Domain-Enumeration"
### check_mdi
# https://github.com/expl0itabl3/check_mdi
pck="check_mdi"
if try_install "$pck"; then
    git clone 'https://github.com/expl0itabl3/check_mdi.git' --depth 1
    cd check_mdi
    # alias check_mdi="python3 $(pwd)/check_mdi.py" 
    # echo "alias check_mdi=\"python3 $(pwd)/check_mdi.py\"" >>$mypath/.bin/hackertoolkit_bash
    echo  -e "${sh}python3 $(pwd)/check_mdi.py" > $mypath/.bin/$pck
    chmod +x $mypath/.bin/$pck
    safe_cd ..
    mark_install "$pck"
fi
### CloudRecon
# https://github.com/g0ldencybersec/CloudRecon
pck="CloudRecon"
if try_install "$pck"; then
    export GOPATH=$HOME/go;
    go env -w CGO_ENABLED=1;
    go install github.com/g0ldencybersec/CloudRecon@latest;
    mark_install "$pck"
fi
### FavFreak
# https://github.com/devanshbatham/FavFreak
pck="FavFreak"
if try_install "$pck"; then
    git clone https://github.com/devanshbatham/FavFreak.git --depth 1
    cd FavFreak
    pipx install virtualenv
    pipx ensurepath
    eval "$(register-python-argcomplete pipx)"
    virtualenv -p python3 env
    source env/bin/activate
    python3 -m pip install mmh3
    # alias FavFreak="$(pwd)/venv/bin/python3 $(pwd)/favfreak.py" 
    # echo "alias FavFreak=\"$(pwd)/venv/bin/python3 $(pwd)/favfreak.py\"" >>$mypath/.bin/hackertoolkit_bash
    echo  -e "${sh}$(pwd)/venv/bin/python3 $(pwd)/favfreak.py" > $mypath/.bin/$pck
    chmod +x $mypath/.bin/$pck
    mark_install "$pck"
    echo 
    deactivate xxx
    safe_cd ..
else
    echo -e "${BLU}$pck${NC} already installed. Skipping..."
fi




safe_cd ..
## Archival Enumeration
set_category "Archival-Enumeration"
mkdir -p "Archival-Enumeration"
safe_cd "Archival-Enumeration"
### gau
# https://github.com/lc/gau
pck="gau";
if try_install "$pck"; then
    git clone https://github.com/lc/gau.git --depth 1;
    cd gau/cmd/gau;
    go build;
    # sudo mv gau /usr/local/bin/
    ln -s $(pwd)/gau $mypath/.bin/gau
    safe_cd ../..
    cp .gau.toml $HOME/
    gau --version;
    safe_cd ..
    mark_install "$pck"
fi
### waymore
# https://github.com/xnl-h4ck3r/waymore
pck="waymore"
if try_install "$pck"; then
    pipx install waymore
    mark_install "$pck"
    echo 
    pipx ensurepath
else
    echo -e "${BLU}$pck${NC} already installed. Skipping..."
fi

safe_cd ..
## Change Detection
set_category "Change-Detection"
mkdir -p "Change-Detection"
safe_cd "Change-Detection"
### changedetection.io
# https://github.com/dgtlmoon/changedetection.io
pck="changedetection.io"
if try_install "$pck"; then
    pipx install changedetection.io
    # changedetection.io -d /path/to/empty/data/dir -p 5000
    mark_install "$pck"
fi
safe_cd ..
## Credential Collection Tools
set_category "Credential-Collection-Tools"
mkdir -p "Credential-Collection-Tools"
safe_cd "Credential-Collection-Tools"
### deepdarkCTI
# https://github.com/fastfire/deepdarkCTI/tree/main
pck="deepdarkCTI"
if try_install_dir "$pck" "deepdarkCTI"; then
    git clone 'https://github.com/fastfire/deepdarkCTI.git' --depth 1
    mark_install "$pck"
fi
### h8mail
# https://github.com/khast3x/h8mail
pck="h8mail"
if try_install "$pck"; then
    pipx install h8mail
    mark_install "$pck"
fi
### hacxx-underground
# https://github.com/hacxx-underground/Files
pck="hacxx-underground"
if try_install_dir "$pck" "$pck"; then
    git clone 'https://github.com/hacxx-underground/Files.git' hacxx-underground --depth 1
    mark_install "$pck"
fi
### linkedin2username
# https://github.com/initstring/linkedin2username
pck="linkedin2username";
if try_install "$pck"; then
    git clone 'https://github.com/initstring/linkedin2username.git' --depth 1;
    cd linkedin2username;
    # pipx install -r ./requirements.txt;
    python3 -m venv venv;
    reqList=$(sed '/^#/d' requirements.txt | tr '\n' ' ');
    venv/bin/pip install $reqList;
    # alias linkedin2username="$(pwd)/venv/bin/python3 linkedin2username.py" ;
    # echo "alias linkedin2username=\"$(pwd)/venv/bin/python3 linkedin2username.py\"" >>$mypath/.bin/hackertoolkit_bash;
    echo  -e "${sh}$(pwd)/venv/bin/python3 $(pwd)/linkedin2username.py" > $mypath/.bin/$pck
    chmod +x $mypath/.bin/$pck
    safe_cd ..
    mark_install "$pck"
fi
### WeakestLink
# https://github.com/shellfarmer/WeakestLink
pck="WeakestLink"
if try_install "$pck"; then
    echo "Copy and paste this link in your firefox web browser to install the plugin"
    echo ""
    echo "https://addons.mozilla.org/en-US/firefox/addon/weakestlink/"
    echo ""
    echo  -e "${sh}echo plugin link: 'https://addons.mozilla.org/en-US/firefox/addon/weakestlink/'" > $mypath/.bin/$pck
    chmod +x $mypath/.bin/$pck
    echo "Run the WeakestLink command tu see again this"
    sleep 2
else
    echo -e "${BLU}$pck${NC} already installed. Skipping..."
fi




safe_cd ..
## Custom Wordlists
set_category "Custom-Wordlists"
mkdir -p "Custom-Wordlists"
safe_cd "Custom-Wordlists"
### CeWL
# https://github.com/digininja/CeWL
pck="cewl"
if try_install "$pck"; then
    exist gem ruby-rubygems
    exist gem ruby-dev
    sudo gem install   mime
    sudo gem install   mime-types
    exist exiftool libimage-exiftool-perl
    sudo gem install   mini_exiftool
    sudo gem install   nokogiri
    sudo gem install   rubyzip
    sudo gem install   spider
    git clone 'https://github.com/digininja/CeWL.git'
    cd CeWL
    chmod u+x ./cewl.rb
    ./cewl.rb -h
    # alias cewl="$(pwd)/cewl.rb" ;
    # echo "alias cewl=\"$(pwd)/cewl.rb\"" >>$mypath/.bin/hackertoolkit_bash;
    ln -s $(pwd)/cewl.rb $mypath/.bin/$pck
    safe_cd ..
    mark_install "$pck"
fi
### wordlistgen
# https://github.com/ameenmaali/wordlistgen
pck="wordlistgen";
if try_install "$pck"; then
    # go get -u github.com/ameenmaali/wordlistgen
    git clone https://github.com/ameenmaali/wordlistgen.git;
    cd wordlistgen/
    go mod init wordlistgen/v3
    go get
    go install
    safe_cd ..
    mark_install "$pck"
fi
safe_cd ..
## Directory Enumeration
set_category "Directory-Enumeration"
mkdir -p "Directory-Enumeration"
safe_cd "Directory-Enumeration"
### dirsearch
# https://github.com/maurosoria/dirsearch
pck="dirsearch"
if try_install "$pck"; then
    git clone https://github.com/maurosoria/dirsearch.git --depth 1
    echo  -e "${sh}ls -al dirsearch" > $mypath/.bin/$pck
    chmod +x $mypath/.bin/$pck
    mark_install "$pck"
fi
### feroxbuster
pck="feroxbuster";
# https://github.com/epi052/feroxbuster
if try_install "$pck"; then
    curl -sL https://raw.githubusercontent.com/epi052/feroxbuster/main/install-nix.sh | bash
    ln -s $(pwd)/feroxbuster $mypath/.bin/feroxbuster
    mark_install "$pck"
fi
### ffuf
# https://github.com/ffuf/ffuf
pck="ffuf"
if try_install "$pck"; then
    go install github.com/ffuf/ffuf/v2@latest
    mark_install "$pck"
fi
### gobuster
# https://github.com/OJ/gobuster
pck="gobuster";
if try_install "$pck"; then
    go install github.com/OJ/gobuster/v3@latest
    mark_install "$pck"
fi
### wfuzz
pck="wfuzz";
# https://github.com/xmendez/wfuzz
if try_install "$pck"; then
    # pipx install wfuzz
    git clone https://github.com/xmendez/wfuzz.git;
    cd wfuzz;
    python3 -m venv venv;
    reqList=$(sed '/^#/d' requirements.txt | tr '\n' ' ');
    venv/bin/pip install $reqList;
    venv/bin/python3 setup.py build;
    venv/bin/python3 setup.py install;
    # alias wfuzz="$(pwd)/venv/bin/wfuzz " 
    # echo "alias wfuzz=\"$(pwd)/venv/bin/wfuzz \"" >>$mypath/.bin/hackertoolkit_bash
    ln -s $(pwd)/venv/bin/wfuzz $mypath/.bin/wfuzz
    safe_cd ..
    mark_install "$pck"
fi
safe_cd ..
## Github Enumeration
set_category "Github Enumeration"
mkdir -p "Github Enumeration"
safe_cd "Github Enumeration"
### github-search
# https://github.com/gwen001/github-search
pck="github-search";
if try_install_dir "$pck" "github-search"; then
    git clone https://github.com/gwen001/github-search
    cd github-search
    # pip3 install -r requirements.txt
    python3 -m venv venv
    reqList=$(sed '/^#/d' requirements.txt | tr '\n' ' ')
    venv/bin/pip install $reqList
    # - this package, like john the ripper has many tools, so it's better add the run path to the system executable PATH
    export PATH="$PATH:$(realpath . )"
    echo "export PATH=\"\$PATH:$(realpath . )\"" >>$mypath/.bin/hackertoolkit_bash
    safe_cd ..
    mark_install "$pck"
fi
### gitleaks
# https://github.com/gitleaks/gitleaks
pck="gitleaks";
if try_install "$pck"; then
    git clone https://github.com/gitleaks/gitleaks.git
    cd gitleaks
    make build
    # make install
    # -Installed on /usr/local/bin/gitleaks
    safe_cd ..
    mark_install "$pck"
fi
safe_cd ..
## JavaScript
set_category "JavaScript"
mkdir -p "JavaScript"
safe_cd "JavaScript"
### jsluice
# https://github.com/BishopFox/jsluice
pck="jsluice";
if try_install "$pck"; then
    go install github.com/BishopFox/jsluice/cmd/jsluice@latest
    mark_install "$pck"
fi
### LinkFinder
# https://github.com/GerbenJavado/LinkFinder
pck="linkfinder";
if try_install "$pck"; then
    git clone https://github.com/GerbenJavado/LinkFinder.git --depth 1
    cd LinkFinder;
    # pip3 install -r requirements.txt
    # python3 setup.py install
    python3 -m venv venv;
    reqList=$(sed '/^#/d' requirements.txt | tr '\n' ' ');
    venv/bin/pip install $reqList;
    venv/bin/python3 setup.py build;
    venv/bin/python3 setup.py install;
    # alias linkfinder="$(pwd)/venv/bin/python3 linkfinder.py";
    # echo "alias linkfinder=\"$(pwd)/venv/bin/python3 linkfinder.py\"" >>$mypath/.bin/hackertoolkit_bash
    echo  -e "${sh}$(pwd)/venv/bin/python3 $(pwd)/linkfinder.py" > $mypath/.bin/$pck
    chmod +x $mypath/.bin/$pck
    safe_cd ..
    mark_install "$pck"
fi
safe_cd ..
## Mobile App Enumeration
set_category "Mobile-App-Enumeration"
mkdir -p "Mobile-App-Enumeration"
safe_cd "Mobile-App-Enumeration"
### apkleaks
# https://github.com/dwisiswant0/apkleaks
#  it utilizes jadx
pck="apkleaks";
if try_install "$pck"; then
    pipx install apkleaks
    mark_install "$pck"
fi
safe_cd ..
## Port-Scanners-(Active)
set_category "Port-Scanners-Active"
mkdir -p "Port-Scanners-Active"
safe_cd "Port-Scanners-Active"
### AutoRecon
# https://github.com/Tib3rius/AutoRecon
pck="autorecon";
## tnscmd10g
if try_install "$pck"; then
    sudo apt -y install curl dnsrecon nbtscan nikto nmap onesixtyone redis-tools smbclient smbmap snmp sslscan sipvicious  whatweb wkhtmltopdf libio-socket-ip-perl default-jre
    sudo snap install enum4linux
    sudo snap install seclists
    if [ -z  "$(which impacket)" ]; then
        pipx install impacket
    fi
    git clone https://gitlab.com/kalilinux/packages/oscanner.git --depth 1
    cd oscanner
    chmod +x $(pwd)/oscanner.jar
    ln -s $(pwd)/oscanner.jar $mypath/.bin/oscanner
    pipx install git+https://github.com/Tib3rius/AutoRecon.git
    safe_cd ..
    mark_install "$pck"
fi
### masscan
# https://github.com/robertdavidgraham/masscan
pck="masscan";
if try_install "$pck"; then
    sudo apt-get --assume-yes install git make gcc;
    git clone https://github.com/robertdavidgraham/masscan --depth 1;
    cd masscan;
    make;
    sudo make install;
    mark_install "$pck"
    make clean
    echo 
    safe_cd ..
else
    echo -e "${BLU}$pck${NC} already installed. Skipping..."
fi



### naabu
# https://github.com/projectdiscovery/naabu
pck="naabu";
if try_install "$pck"; then
    sudo apt install -y libpcap-dev
    go install -v github.com/projectdiscovery/naabu/v2/cmd/naabu@latest
    mark_install "$pck"
fi
### nmap
# https://github.com/nmap/nmap
# - Instaled as dependency of AutoRecon
pck="nmap";
nmap -V
mark_install "$pck"
echo 


# https://github.com/RustScan/RustScan
pck="rustscan";
if try_install "$pck"; then
    wget https://github.com/RustScan/RustScan/releases/download/2.2.2/rustscan_2.2.2_amd64.deb;
    sudo dpkg -i rustscan_2.2.2_amd64.deb;
    mark_install "$pck"
fi
safe_cd ..
## Port-Scanners-(Passive)
set_category "Port-Scanners-Passive"
mkdir -p "Port-Scanners-Passive"
safe_cd "Port-Scanners-Passive"
# https://github.com/s0md3v/Smap
pck="smap";
if try_install "$pck"; then
    wget -O smap.tar.xz https://github.com/s0md3v/Smap/releases/download/0.1.12/smap_0.1.12_linux_amd64.tar.xz
    tar -xf smap.tar.xz
    ln -s $(pwd)/smap_0.1.12_linux_amd64/smap $mypath/.bin/smap
    mark_install "$pck"
fi
safe_cd ..
## Recon Frameworks
set_category "Recon-Frameworks"
mkdir -p "Recon-Frameworks"
safe_cd "Recon-Frameworks"
# https://github.com/six2dez/reconftw
pck="reconftw";
if try_install "$pck"; then
    git clone https://github.com/six2dez/reconftw --depth 1;
    cd reconftw/;
    ./install.sh;
    # - it says that it install also (Installing Golang tools (44) on $HOME/go/bin/):
    # inscope installed (1/44)
    # hakip2host installed (2/44)
    # puredns installed (3/44)
    # interactsh-client installed (4/44)
    # nuclei installed (5/44)
    # analyticsrelationships installed (6/44)
    # crt installed (7/44)
    # nmapurls installed (8/44)
    # dnsx installed (9/44)
    # gitlab-subdomains installed (10/44)
    # dalfox installed (11/44)
    # gitdorks_go installed (12/44)
    # roboxtractor installed (13/44)
    # gau installed (14/44)
    # Gxss installed (15/44)
    # katana installed (16/44)
    # mapcidr installed (17/44)
    # brutespray installed (18/44)
    # sns installed (19/44)
    # qsreplace installed (20/44)
    # notify installed (21/44)
    # dsieve installed (22/44)
    # gotator installed (23/44) 
    # ppmap installed (24/44)
    # subfinder installed (25/44)
    # smap installed (26/44)
    # crlfuzz installed (27/44)
    # Web-Cache-Vulnerability-Scanner installed (28/44)
    # cdncheck installed (29/44)
    # httpx installed (30/44)
    # ffuf installed (31/44)
    # subjs installed (32/44)
    # github-endpoints installed (33/44)
    # unfurl installed (34/44)
    # anew installed (35/44)
    # gf installed (36/44)
    # shortscan installed (37/44)
    # tlsx installed (38/44)
    # mantra installed (39/44)
    # github-subdomains installed (40/44)
    # enumerepo installed (41/44)
    # amass installed (42/44)
    # s3scanner installed (43/44)
    # dnstake installed (44/44)

    # - Installing repositories (29) ( on $HOME/Tools/ )
    # dnsvalidator installed (1/29)
    # wafw00f installed (2/29)
    # ultimate-nmap-parser installed (3/29)
    # Corsy installed (4/29)
    # gitleaks installed (5/29)
    # CMSeeK installed (6/29)
    # Wapiti installed (7/29)
    # SwaggerSpy installed (8/29)
    # regulator installed (9/29)
    # gitdorks_go installed (10/29)
    # dorks_hunter installed (11/29)
    # JSA installed (12/29)
    # trufflehog installed (13/29)
    # pydictor installed (14/29)
    # smuggler installed (15/29)
    # ghauri installed (16/29)
    # cloud_enum installed (17/29)
    # testssl installed (18/29)
    # Web-Cache-Vulnerability-Scanner installed (19/29)
    # Oralyzer installed (20/29)
    # nomore403 installed (21/29)
    # fav-up installed (22/29)
    # massdns installed (23/29)
    # gf installed (24/29)
    # commix installed (25/29)
    # LeakSearch installed (26/29)
    # urless installed (27/29)
    # interlace installed (28/29)
    # Gf-Patterns installed (29/29)

    # ./reconftw.sh -d target.com -r
    # alias reconftw="$(pwd)/reconftw.sh" 
    #"echo "alias reconftw=\"$(pwd)/reconftw.sh\"" >>$mypath/.bin/hackertoolkit_bash
    ln -s $(pwd)/reconftw.sh $mypath/.bin/$pck
    safe_cd ..
    mark_install "$pck"
fi
### recon-ng
# https://github.com/lanmaster53/recon-ng
pck="recon-ng";
if try_install "$pck"; then
    git clone https://github.com/lanmaster53/recon-ng.git --depth 1;
    cd recon-ng; 
    python3 -m venv venv;
    reqList=$(sed '/^#/d' REQUIREMENTS | tr '\n' ' ');
    venv/bin/pip install $reqList;
    # alias recon-ng="$(pwd)/recon-ng" 
    # alias recon-cli="$(pwd)/recon-cli" 
    # alias recon-web="$(pwd)/recon-web" 
    # echo "alias recon-ng=\"$(pwd)/recon-ng\"" >>$mypath/.bin/hackertoolkit_bash
    # echo "alias recon-cli=\"$(pwd)/recon-cli\"" >>$mypath/.bin/hackertoolkit_bash
    # echo "alias recon-web=\"$(pwd)/recon-web\"" >>$mypath/.bin/hackertoolkit_bash
    ln -s $(pwd)/recon-ng $mypath/.bin/recon-ng
    ln -s $(pwd)/recon-cli $mypath/.bin/recon-cli
    ln -s $(pwd)/recon-web $mypath/.bin/recon-web
    safe_cd ..
    mark_install "$pck"
fi
### rengine 
# https://github.com/yogeshojha/rengine
# -This package install docker and others 43 packages more, I think they are the same 
# - of reconftw
pck="rengine";
if try_install_dir "$pck" "rengine"; then
    git clone https://github.com/yogeshojha/rengine --depth 1 
    cd rengine
    # - For posgresql password
    sudo apt install -y postgresql postgresql-contrib
    echo "ENTER PASSWORD FOR postgres user"
    sudo passwd postgres
    echo "---------- Search for POSTGRES_PASSWORD and set the value you put to postgres PASSWORD"
    echo "---------- PRESS ANY KEY TO CONTINUE"
    read xxx
    nano .env
    # - dotenv file
    MAX_CONCURRENCY=80
    MIN_CONCURRENCY=10
    # if the following command is not executed, it will not currently installed
    # sudo ./install.sh
    ln -s $(pwd)/install.sh $mypath/.bin/${pck}-install
    safe_cd ..
    mark_install "$pck"
fi
safe_cd ..
## Shodan Tools
set_category "Shodan-Tools"
mkdir -p "Shodan-Tools"
safe_cd "Shodan-Tools"
### karma_v2
# https://github.com/Dheerajmadhukar/karma_v2
pck="karma_v2";
if try_install "$pck"; then
    git clone https://github.com/Dheerajmadhukar/karma_v2.git --depth 1
    # python3 -m pip install shodan mmh3
    if [ -z  "$(which shodan)" ]; then
        pipx install shodan
    fi
    cd karma_v2
    chmod +x karma_v2
    ln -s $(pwd)/$pck $mypath/.bin/$pck
    safe_cd ..
    go install -v github.com/tomnomnom/httprobe@master
    if [ -z  "$(which Interlace)" ]; then
        git clone https://github.com/codingo/Interlace.git --depth 1
        cd Interlace
        # python3 setup.py install
        python3 -m venv venv
        venv/bin/python3 setup.py build
        venv/bin/python3 setup.py install
        # alias Interlace="$(pwd)/venv/bin/Interlace" 
        # echo "alias Interlace=\"$(pwd)/venv/bin/Interlace\"" >>$mypath/.bin/hackertoolkit_bash
        ln -s $(pwd)/venv/bin/Interlace $mypath/.bin/$pck
    fi
    go install -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest
    go install -v github.com/tomnomnom/anew@master
    safe_cd ..
    mark_install "$pck"
fi
### shosubgo
# https://github.com/incogbyte/shosubgo
pck="shosubgo";
if try_install "$pck"; then
    go install github.com/incogbyte/shosubgo@latest
    # verify inside your $GOPATH the folder "bin", maybe $HOME/go/bin
    mark_install "$pck"
fi
### Already installed Smap
# https://github.com/s0md3v/Smap


### wtfis
# https://github.com/pirxthepilot/wtfis
pck="wtfis";
if try_install "$pck"; then
    pipx install wtfis
    mark_install "$pck"
fi
safe_cd ..
## Screenshotting
set_category "Screenshotting"
mkdir -p "Screenshotting"
safe_cd "Screenshotting"
### aquatone
# https://github.com/michenriksen/aquatone
pck="aquatone";
if try_install "$pck"; then
    wget -O aquatone.zip https://github.com/michenriksen/aquatone/releases/download/v1.7.0/aquatone_linux_amd64_1.7.0.zip
    unzip aquatone.zip
    cd aquatone/
    ln -s $(pwd)/aquatone $mypath/.bin/aquatone
    safe_cd ..
    mark_install "$pck"
fi
### eyeballer
# https://github.com/BishopFox/eyeballer
pck="eyeballer";
if try_install "$pck"; then
    git clone https://github.com/BishopFox/eyeballer.git --depth 1
    cd eyeballer
    python3 -m venv venv
    reqList=$(sed '/^#/d' requirements.txt | tr '\n' ' ')
    venv/bin/pip install $reqList
    # alias eyeballer="$(pwd)/venv/bin/python3 $(pwd)/eyeballer.py" 
    # echo "alias eyeballer=\"$(pwd)/venv/bin/python3 $(pwd)/eyeballer.py\"" >>$mypath/.bin/hackertoolkit_bash
    echo  -e "${sh}$(pwd)/venv/bin/python3 $(pwd)/eyeballer.py" > $mypath/.bin/$pck
    chmod +x $mypath/.bin/$pck
    safe_cd ..
    mark_install "$pck"
fi
### EyeWitness
# https://github.com/RedSiege/EyeWitness
pck="EyeWitness";
if try_install_dir "$pck" "$pck"; then
    git clone https://github.com/RedSiege/EyeWitness.git --depth 1
    if [ $? -eq 0 ]; then echo "Installed $pck: Load $HOME/EyeWitness/EyeWitness.sln into Visual Studio, Go to Build at the top and then Build Solution">>$mypath/install.tmp; else echo "Not Installed $pck">>$mypath/not-install.tmp; fi
    echo
    echo "1. Navigate into the CS directory
        2. Load $HOME/EyeWitness/EyeWitness.sln into Visual Studio
        3. Go to Build at the top and then Build Solution if no modifications are wanted
    "
    sleep 2
else
    echo -e "${BLU}$pck${NC} already installed. Skipping..."
fi


    
### go-stare
# https://github.com/dwisiswant0/go-stare
pck="go-stare";
if try_install "$pck"; then
    wget -O go-stare.tar.gz https://github.com/dwisiswant0/go-stare/releases/download/v0.0.3-dev/go-stare_0.0.3-dev_linux_arm64.tar.gz
    tar -C . -xzf go-stare.tar.gz
    ln -s $(pwd)/go-stare $mypath/.bin/go-stare
    mark_install "$pck"
fi
### httpscreenshot
# https://github.com/breenmachine/httpscreenshot
pck="httpscreenshot";
if try_install "$pck"; then
    sudo apt-get install swig  libssl-dev; # python-dev 
    git clone https://github.com/breenmachine/httpscreenshot.git --depth 1
    cd httpscreenshot
    python3 -m venv venv
    reqList=$(sed '/^#/d' requirements.txt | tr '\n' ' ')
    venv/bin/pip install $reqList
    # alias httpscreenshot="$(pwd)/venv/bin/python3 $(pwd)/httpscreenshot.py" 
    # echo "alias httpscreenshot=\"$(pwd)/venv/bin/python3 $(pwd)/httpscreenshot.py\"" >>$mypath/.bin/hackertoolkit_bash
    echo  -e "${sh}$(pwd)/venv/bin/python3 $(pwd)/httpscreenshot.py" > $mypath/.bin/$pck
    chmod +x $mypath/.bin/$pck
    safe_cd ..
    mark_install "$pck"
fi
### httpx
# https://github.com/projectdiscovery/httpx
pck="httpx";
if try_install "$pck"; then
    go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
    # - Installed on $HOME/go/bin
    mark_install "$pck"
fi
safe_cd ..
## Spiders
set_category "Spiders"
mkdir -p "Spiders"
safe_cd "Spiders"
### gospider
# https://github.com/jaeles-project/gospider
pck="gospider";
if try_install "$pck"; then
    go install github.com/jaeles-project/gospider@latest
    # - Installed on $HOME/go/bin
    mark_install "$pck"
fi
### katana
# https://github.com/projectdiscovery/katana
pck="katana";
if try_install "$pck"; then
    go install github.com/projectdiscovery/katana/cmd/katana@latest
    # - Installed on $HOME/go/bin
    mark_install "$pck"
fi
### hakrawler
# https://github.com/hakluke/hakrawler
pck="hakrawler";
if try_install "$pck"; then
    go install github.com/hakluke/hakrawler@latest
    # - Installed on $HOME/go/bin
    mark_install "$pck"
fi
safe_cd ..
## Subdomain-Enumeration-and-Brute-Force
set_category "Subdomain-Enumeration-and-Brute-Force"
mkdir -p "Subdomain-Enumeration-and-Brute-Force"
safe_cd "Subdomain-Enumeration-and-Brute-Force"
### altdns
# https://github.com/infosec-au/altdns
pck="altdns";
if try_install "$pck"; then
    # pip3 install py-altdns==1.0.2
    git clone https://github.com/infosec-au/altdns.git --depth 1
    cd altdns
    python3 -m venv venv
    reqList=$(sed '/^#/d' requirements.txt | tr '\n' ' ')
    venv/bin/pip install $reqList
    venv/bin/python3 setup.py build
    venv/bin/python3 setup.py install
    # alias altdns="$(pwd)/venv/bin/altdns" 
    # echo "alias altdns=\"$(pwd)/venv/bin/altdns\"" >>$mypath/.bin/hackertoolkit_bash
    ln -s $(pwd)/venv/bin/altdns $mypath/.bin/altdns
    safe_cd ..
    mark_install "$pck"
fi
### alterx
# https://github.com/projectdiscovery/alterx
pck="alterx";
if try_install "$pck"; then
    go install github.com/projectdiscovery/alterx/cmd/alterx@latest
    mark_install "$pck"
fi
### amass
# https://github.com/owasp-amass/amass
pck="amass";
if try_install "$pck"; then
    go install -v github.com/owasp-amass/amass/v4/...@master
    mark_install "$pck"
fi
### assetfinder
# https://github.com/tomnomnom/assetfinder
pck="assetfinder";
if try_install "$pck"; then
    # go get -u github.com/tomnomnom/assetfinder
    go install -v github.com/tomnomnom/assetfinder@latest
    mark_install "$pck"
fi
### bbot
# https://github.com/blacklanternsecurity/bbot
pck="bbot";
if try_install "$pck"; then
    pipx install bbot
    mark_install "$pck"
fi
### CloudRecon
# - Already installed
# https://github.com/g0ldencybersec/CloudRecon
#pck="";
# echo "[+] $pck"
# if [ $? -eq 0 ]; then echo -e "Installed ${YLL}$pck${NC}";echo "Installed $pck">>$mypath/install.tmp; else echo "Not Installed $pck">>$mypath/not-install.tmp; fi
# echo
# cd ..

### dnsgen
# https://github.com/AlephNullSK/dnsgen
pck="dnsgen";
if try_install "$pck"; then
    git clone https://github.com/AlephNullSK/dnsgen --depth 1
    cd dnsgen/
    if [ -z  "$(which poetry)" ]; then
        pipx install poetry
    fi
    poetry install
    # alias dnsgen="poetry run $(pwd)/dnsgen" 
    # echo "alias dnsgen=\"poetry run $(pwd)/dnsgen\"" >>$mypath/.bin/hackertoolkit_bash
    echo  -e "${sh}poetry run $(pwd)/dnsgen" > $mypath/.bin/$pck
    chmod +x $mypath/.bin/$pck
    safe_cd ..
    mark_install "$pck"
fi
### 
# - Already installed
# https://github.com/devanshbatham/FavFreak
# pck="";
# echo "[+] $pck"

# if [ $? -eq 0 ]; then echo -e "Installed ${YLL}$pck${NC}";echo "Installed $pck">>$mypath/install.tmp; else echo "Not Installed $pck">>$mypath/not-install.tmp; fi
# echo

### Findomain
# https://github.com/Findomain/Findomain
pck="findomain";
if try_install "$pck"; then
    git clone https://github.com/findomain/findomain.git;
    cd findomain;
    cargo build --release;
    cp target/release/findomain $mypath/.bin ;
    safe_cd ..
    mark_install "$pck"
fi
### github-subdomains
# https://github.com/gwen001/github-subdomains
pck="github-subdomains";
if try_install "$pck"; then
    go install github.com/gwen001/github-subdomains@latest
    mark_install "$pck"
fi
### gotator
# https://github.com/Josue87/gotator
pck="gotator";
if try_install "$pck"; then
    go install github.com/Josue87/gotator@latest
    mark_install "$pck"
fi
### puredns
# https://github.com/d3mondev/puredns
pck="puredns";
if try_install "$pck"; then
    wget https://github.com/d3mondev/puredns/releases/download/v2.1.1/puredns-Linux-amd64.tgz;
    tar -C . -xzf puredns-Linux-amd64.tgz;
    ln -s $(realpath puredns) $mypath/.bin/puredns
    mark_install "$pck"
fi
### regulator
# https://github.com/cramppet/regulator
pck="regulator";
if try_install "$pck"; then
    git clone https://github.com/cramppet/regulator.git --depth 1;
    cd regulator;
    python3 -m venv venv;
    reqList=$(sed '/^#/d' requirements.txt | tr '\n' ' ');
    venv/bin/pip install $reqList;
    # alias regulator="$(pwd)/venv/bin/python3 $(pwd)/main.py" 
    # echo "alias regulator=\"$(pwd)/venv/bin/python3 $(pwd)/main.py\"" >>$mypath/.bin/hackertoolkit_bash
    echo  -e "${sh}$(pwd)/venv/bin/python3 $(pwd)/main.py" > $mypath/.bin/$pck
    chmod +x $mypath/.bin/$pck
    safe_cd ..
    mark_install "$pck"
fi
### shuffledns
# https://github.com/projectdiscovery/shuffledns
pck="shuffledns";
if try_install "$pck"; then
    go install -v github.com/projectdiscovery/shuffledns/cmd/shuffledns@latest
    mark_install "$pck"
fi
### shosubgo
# - Already installed
# https://github.com/incogbyte/shosubgo
# pck="";
# echo "[+] $pck"
# if [ $? -eq 0 ]; then echo -e "Installed ${YLL}$pck${NC}";echo "Installed $pck">>$mypath/install.tmp; else echo "Not Installed $pck">>$mypath/not-install.tmp; fi
# echo

### subfinder
# https://github.com/projectdiscovery/subfinder
pck="subfinder";
if try_install "$pck"; then
    go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
    mark_install "$pck"
fi
### Sublist3r
# https://github.com/aboul3la/Sublist3r
pck="sublist3r";
if try_install "$pck"; then
    git clone https://github.com/aboul3la/Sublist3r.git --depth 1;
    cd Sublist3r;
    python3 -m venv venv;
    reqList=$(sed '/^#/d' requirements.txt | tr '\n' ' ');
    venv/bin/pip install $reqList;
    venv/bin/python3 setup.py build;
    venv/bin/python3 setup.py install;
    # alias Sublist3r="$(pwd)/venv/bin/Sublist3r " 
    # echo "alias Sublist3r=\"$(pwd)/venv/bin/Sublist3r \"" >>$mypath/.bin/hackertoolkit_bash
    ln -s $(pwd)/venv/bin/sublist3r $mypath/.bin/sublist3r
    safe_cd ..
    mark_install "$pck"
fi
safe_cd ..
## Web-Technology-Enumeration
set_category "Web-Technology-Enumeration"
mkdir -p "Web-Technology-Enumeration"
safe_cd "Web-Technology-Enumeration"
### webanalyze
# https://github.com/rverton/webanalyze
pck="webanalyze";
if try_install "$pck"; then
    wget -O $pck.tar.gz https://github.com/rverton/webanalyze/releases/download/v0.4.1/webanalyze_Linux_x86_64.tar.gz;
    tar -C . -xzf $pck.tar.gz;
    ln -s $(realpath webanalyze) $mypath/.bin/webanalyze
    mark_install "$pck"
fi
### WhatWeb
# https://github.com/urbanadventurer/WhatWeb
pck="whatweb";
if try_install "$pck"; then
    sudo apt -y install whatweb
    mark_install "$pck"
fi
safe_cd ..
# Exploitation
set_category "Exploitation"
mkdir -p "Exploitation"
safe_cd "Exploitation"
## Active-Directory
set_category "Active-Directory"
mkdir -p "Active-Directory"
safe_cd "Active-Directory"
### BloodHound
# https://github.com/BloodHoundAD/BloodHound
pck="BloodHound";
if try_install "$pck"; then
    wget https://github.com/BloodHoundAD/BloodHound/releases/download/v4.3.1/BloodHound-linux-x64.zip;
    unzip BloodHound-linux-x64.zip;
    cd BloodHound-linux-x64
    ln -s $(realpath BloodHound ) $mypath/.bin/BloodHound 
    safe_cd ..
    mark_install "$pck"
fi
### Empire
# - This package is no longer support
# https://github.com/EmpireProject/Empire
pck="empire";
if try_install "$pck"; then
    git clone https://github.com/EmpireProject/Empire.git --depth 1;
    cd Empire;
    # sudo ./setup/install.sh;
    chmod +x setup/install.sh;
     ln -s $(realpath setup/install.sh ) $mypath/.bin/empire-install.sh 
    safe_cd ..
    mark_install "$pck"
fi
### PowerSploit
# https://github.com/PowerShellMafia/PowerSploit
pck="PowerSploit";
if try_install_dir "$pck" "$pck"; then
    source /etc/os-release;
    wget -q https://packages.microsoft.com/config/debian/$VERSION_ID/packages-microsoft-prod.deb;
    sudo dpkg -i packages-microsoft-prod.deb;
    # - Powershell is not supported on Debian 12 yet
    # sudo apt-get update;
    # sudo apt-get install -y powershell;
    wget https://github.com/PowerShell/PowerShell/releases/download/v7.4.2/powershell_7.4.2-1.deb_amd64.deb
    sudo dpkg -i powershell_7.4.2-1.deb_amd64.deb
    git clone https://github.com/PowerShellMafia/PowerSploit.git --depth 1
    mark_install "$pck"
fi
safe_cd ..
## Linux-Privilege-Escalation
set_category "Linux-Privilege-Escalation"
mkdir -p "Linux-Privilege-Escalation"
safe_cd "Linux-Privilege-Escalation"
### LinEnum
# https://github.com/rebootuser/LinEnum
pck="LinEnum";
if try_install "$pck"; then
    git clone https://github.com/rebootuser/LinEnum.git --depth 1
    cd LinEnum
    ln -s $(realpath LinEnum.sh ) $mypath/.bin/LinEnum 
    safe_cd ..
    mark_install "$pck"
fi
### linPEAS
# https://github.com/peass-ng/PEASS-ng/tree/master/linPEAS
# - This package installed the tool and inmediately run it
pck="linpeas";
if try_install "$pck"; then
    # curl -L https://github.com/peass-ng/PEASS-ng/releases/latest/download/linpeas.sh | sh
    curl https://github.com/peass-ng/PEASS-ng/releases/latest/download/linpeas.sh >linpeas.sh
    chmod +x linpeas.sh
    ln -s $(realpath linpeas.sh ) $mypath/.bin/linpeas 
    mark_install "$pck"
fi
### linuxprivcheck
# https://github.com/cervoise/linuxprivcheck
pck="linuxprivchecker3";
if try_install "$pck"; then
    if [ -z  "$(which pyinstaller)" ]; then
        pipx install pyinstaller;
    fi
    git clone https://github.com/cervoise/linuxprivcheck.git;
    cd linuxprivcheck
    # python3 -m PyInstaller --onefile linuxprivchecker3.py;
    pyinstaller --onefile linuxprivchecker3.py;
    ln -s $(realpath dist/linuxprivchecker3 ) $mypath/.bin/linuxprivchecker3
    safe_cd ..
    mark_install "$pck"
fi
### linuxprivchecker
# https://github.com/sleventyeleven/linuxprivchecker
pck="linuxprivchecker";
if try_install "$pck"; then
    pipx install linuxprivchecker
    mark_install "$pck"
fi
safe_cd ..
## Password-Spraying-Stuffing-Brute-Forcing-Cracking
set_category "Password-Spraying-Stuffing-Brute-Forcing-Cracking"
mkdir -p "Password-Spraying-Stuffing-Brute-Forcing-Cracking"
safe_cd "Password-Spraying-Stuffing-Brute-Forcing-Cracking"
### CredMaster
# https://github.com/knavesec/CredMaster
pck="CredMaster";
if try_install "$pck"; then
    git clone https://github.com/knavesec/CredMaster.git --depth 1
    cd CredMaster
    python3 -m venv venv;
    reqList=$(sed '/^#/d' requirements.txt | tr '\n' ' ');
    venv/bin/pip install $reqList;
    echo "Remember, if unsure how to create correct keys see this this: https://bond-o.medium.com/aws-pass-through-proxy-84f1f7fa4b4b"
    sleep 3
    # alias CredMaster="$(pwd)/venv/bin/python3 $(pwd)/credmaster.py " 
    # echo "alias CredMaster=\"$(pwd)/venv/bin/python3 $(pwd)/credmaster.py \"" >>$mypath/.bin/hackertoolkit_bash
    echo  -e "${sh}$(pwd)/venv/bin/python3 $(pwd)/credmaster.py" > $mypath/.bin/$pck
    chmod +x $mypath/.bin/$pck
    safe_cd ..
    mark_install "$pck"
fi
### hashcat
# https://github.com/hashcat/hashcat
pck="hashcat";
if try_install "$pck"; then
    wget -O hashcat.7z https://hashcat.net/files/hashcat-6.2.6.7z;
    7z x hashcat.7z;
    ln -s $(realpath hashcat-6.2.6/hashcat.bin ) $mypath/.bin/hashcat
    mark_install "$pck"
fi
### thc-hydra
# https://github.com/vanhauser-thc/thc-hydra
pck="hydra-wizard";
if try_install "$pck"; then
    apt-get install libssl-dev libssh-dev libidn11-dev libpcre3-dev \
                    libgtk2.0-dev libmysqlclient-dev libpq-dev libsvn-dev \
                    firebird-dev libmemcached-dev libgpg-error-dev \
                    libgcrypt11-dev libgcrypt20-dev
    wget https://github.com/vanhauser-thc/thc-hydra/archive/refs/tags/v9.5.zip
    unzip v9.5.zip;
    cd thc-hydra-9.5;
    ./configure;
    make;
    make install;
    ln -s $(realpath xhydra ) $mypath/.bin/xhydra
    ln -s $(realpath hydra-wizard.sh ) $mypath/.bin/hydra-wizard
    ln -s $(realpath pw-inspector ) $mypath/.bin/pw-inspector
    ln -s $(realpath dpl4hydra.sh ) $mypath/.bin/dpl4hydra
    mark_install "$pck"
    make clean
    echo
    safe_cd ..
else
    echo -e "${BLU}$pck${NC} already installed. Skipping..."
fi



### john the ripper jumbo
# https://github.com/openwall/john
pck="john";
if try_install "$pck"; then
    if [ ! -f  "john/run/john" ]; then
        sudo apt install nss-passwords libkrb5-dev libgmp-dev libbz2-1.0 libbz2-dev;
        git clone https://github.com/openwall/john.git --depth 1;
        cd john/src;
        ./configure && make;
        make install
        safe_cd ..
        # ln -s $(realpath run/john ) $mypath/.bin/john
        # - john has many tools, so it's better add the run path to the system executable PATH
        export PATH="$PATH:$(realpath run/ )"
        echo "export PATH=\"\$PATH:$(realpath run/ )\"" >>$mypath/.bin/hackertoolkit_bash
        source $(realpath run/john.bash_completion)
        source $(realpath run/john.bash_completion) >>$mypath/.bin/hackertoolkit_bash
        safe_cd ..
        mark_install "$pck"
fi
else
    echo -e "${BLU}$pck${NC} already installed. Skipping..."
fi

### medusa
# https://github.com/jmk-foofus/medusa
pck="medusa";
if try_install "$pck"; then
    git clone https://github.com/jmk-foofus/medusa.git --depth 1;
    cd medusa;
    ./configure --prefix=$(pwd) --exec-prefix=$(pwd) && make  && make install ;
    ln -s $(realpath bin/medusa ) $mypath/.bin/medusa
    mark_install "$pck"
    make clean
    echo
    safe_cd ..
else
    echo -e "${BLU}$pck${NC} already installed. Skipping..."
fi

### WhereToGo
# https://github.com/valeriyshevchenko90/WhereToGo
pck="WhereToGo";
if try_install_dir "$pck" "$pck"; then
    git clone https://github.com/valeriyshevchenko90/WhereToGo.git --depth 1
    mark_install "$pck"
fi
safe_cd ..
## Payload-Lists
set_category "Payload-Lists"
mkdir -p "Payload-Lists"
safe_cd "Payload-Lists"
### PayloadsAllTheThings
# https://github.com/swisskyrepo/PayloadsAllTheThings
pck="PayloadsAllTheThings";
if try_install_dir "$pck" "$pck"; then
    git clone https://github.com/swisskyrepo/PayloadsAllTheThings.git --depth 1
    mark_install "$pck"
fi
### SecLists
# - This package has been installed by AutoRecon
# https://github.com/danielmiessler/SecLists
pck="SecLists";
if try_install_dir "$pck" "SecLists"; then
    git clone --depth 1 https://github.com/danielmiessler/SecLists.git --depth 1
    mark_install "$pck"
fi
safe_cd ..
## Windows-Privilege-Escalation
set_category "Windows-Privilege-Escalation"
mkdir -p "Windows-Privilege-Escalation"
safe_cd "Windows-Privilege-Escalation"
### wesng
# https://github.com/bitsadmin/wesng
pck="wesng";
if try_install "$pck"; then
    git clone https://github.com/bitsadmin/wesng --depth 1;
    cd wesng;
    # alias wes.py="python3 $(pwd)/wes.py " ;
    # echo "alias wes.py=\"python3 $(pwd)/wes.py \"" >>$mypath/.bin/hackertoolkit_bash;
    echo  -e "${sh}python3 $(pwd)/wes.py" > $mypath/.bin/$pck
    chmod +x $mypath/.bin/$pck
    safe_cd ..
    mark_install "$pck"
fi
### winPEAS
# https://github.com/peass-ng/PEASS-ng/tree/master/winPEAS
pck="winPEAS";
if try_install_dir "$pck" "winPEAS"; then
    mkdir -p winPEAS;
    cd winPEAS;
    wget https://github.com/peass-ng/PEASS-ng/releases/download/20240421-825f642d/winPEAS.bat;
    wget https://github.com/peass-ng/PEASS-ng/releases/download/20240421-825f642d/winPEASx64.exe;
    wget https://github.com/peass-ng/PEASS-ng/releases/download/20240421-825f642d/winPEASx64_ofs.exe;
    safe_cd ..
    mark_install "$pck"
fi
safe_cd ..
## SQL-Injection
set_category "SQL-Injection"
mkdir -p "SQL-Injection"
safe_cd "SQL-Injection"
### ghauri
# https://github.com/r0oth3x49/ghauri
pck="ghauri";
if try_install "$pck"; then
    git clone https://github.com/r0oth3x49/ghauri.git --depth 1;
    cd ghauri;
    python3 -m venv venv;
    reqList=$(sed '/^#/d' requirements.txt | tr '\n' ' ');
    venv/bin/pip install $reqList;
    venv/bin/python3 setup.py build;
    venv/bin/python3 setup.py install;
    # alias ghauri="$(pwd)/venv/bin/ghauri" ;
    # echo "alias ghauri=\"$(pwd)/venv/bin/ghauri\"" >>$mypath/.bin/hackertoolkit_bash;
    ln -s $(pwd)/venv/bin/ghauri $mypath/.bin/$pck
    safe_cd ..
    mark_install "$pck"
fi
### HBSQLI
# https://github.com/SAPT01/HBSQLI
pck="hbsqli";
if try_install "$pck"; then
    git clone https://github.com/SAPT01/HBSQLI.git --depth 1;
    cd HBSQLI;
    python3 -m venv venv;
    reqList=$(sed '/^#/d' requirements.txt | tr '\n' ' ');
    venv/bin/pip install $reqList;
    # alias hbsqli="$(pwd)/venv/bin/python3 $(pwd)/hbsqli.py" ;
    # echo "alias hbsqli=\"$(pwd)/venv/bin/python3 $(pwd)/hbsqli.py\"" >>$mypath/.bin/hackertoolkit_bash;
    echo  -e "${sh}$(pwd)/venv/bin/python3 $(pwd)/hbsqli.py" > $mypath/.bin/$pck
    chmod +x $mypath/.bin/$pck
    safe_cd ..
    mark_install "$pck"
fi
### sqlmap
# https://github.com/sqlmapproject/sqlmap
pck="sqlmap";
if try_install "$pck"; then
    git clone --depth 1 https://github.com/sqlmapproject/sqlmap.git sqlmap-dev 
    cd sqlmap-dev
    # alias sqlmap="python3 $(pwd)/sqlmap.py" ;
    # echo "alias sqlmap=\"python3 $(pwd)/sqlmap.py\"" >>$mypath/.bin/hackertoolkit_bash;
    echo  -e "${sh}python3 $(pwd)/sqlmap.py" > $mypath/.bin/$pck
    chmod +x $mypath/.bin/$pck
    safe_cd ..
    mark_install "$pck"
fi
safe_cd ..
## Vulnerability-Scanners
set_category "Vulnerability-Scanners"
mkdir -p "Vulnerability-Scanners"
safe_cd "Vulnerability-Scanners"
### jaeles
# https://github.com/jaeles-project/jaeles
pck="jaeles";
if try_install "$pck"; then
    go install github.com/jaeles-project/jaeles@latest
    mark_install "$pck"
fi
### nuclei
# Already installed
# https://github.com/projectdiscovery/nuclei
# pck="";
# echo "[+] $pck"

# if [ $? -eq 0 ]; then echo -e "Installed ${YLL}$pck${NC}";echo "Installed $pck">>$mypath/install.tmp; else echo "Not Installed $pck">>$mypath/not-install.tmp; fi
# echo

### AllForOne
# https://github.com/AggressiveUser/AllForOne
pck="AllForOne";
if try_install "$pck"; then
    git clone https://github.com/AggressiveUser/AllForOne.git --depth 1;
    cd AllForOne;
    python3 -m venv venv;
    reqList=$(sed '/^#/d' requirements.txt | tr '\n' ' ');
    venv/bin/pip install $reqList;
    # alias AllForOne="$(pwd)/venv/bin/python3 $(pwd)/AllForOne.py" ;
    # echo "alias AllForOne=\"$(pwd)/venv/bin/python3 $(pwd)/AllForOne.py\"" >>$mypath/.bin/hackertoolkit_bash;
    echo  -e "${sh}$(pwd)/venv/bin/python3 $(pwd)/AllForOne.py" > $mypath/.bin/$pck
    chmod +x $mypath/.bin/$pck
    safe_cd ..
    mark_install "$pck"
fi
### cent
# https://github.com/xm1k3/cent
pck="cent";
if try_install "$pck"; then
    go install -v github.com/xm1k3/cent@latest
    mark_install "$pck"
fi
### retire.js
# https://github.com/retirejs/retire.js/
pck="retire";
if try_install "$pck"; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash;
    nvm install 16 2>/dev/null;
    npm install -g retire;
    mark_install "$pck"
fi
safe_cd ..
safe_cd ..
# Red-Teaming
set_category "Red-Teaming"
mkdir -p "Red-Teaming"
safe_cd "Red-Teaming"
## C2
set_category "C2"
mkdir -p "C2"
safe_cd "C2"
### NimPlant
# https://github.com/chvancooten/NimPlant
pck="NimPlant";
if try_install "$pck"; then
    sudo apt install mingw-w64;
    git clone https://github.com/chvancooten/NimPlant.git --depth 1;
    cd NimPlant;
    wget https://github.com/nim-lang/nimble/releases/download/latest/nimble-linux_x64.tar.gz;
    tar -C . -xzf nimble-linux_x64.tar.gz;
    cd client; 
    ../nimble install -d
    cd ../server;
    python3 -m venv venv;
    reqList=$(sed '/^#/d' requirements.txt | tr '\n' ' ');
    venv/bin/pip install $reqList;
    # alias NimPlant="$(pwd)/server/venv/bin/python3 $(pwd)/NimPlant.py" ;
    # echo "alias NimPlant=\"$(pwd)/server/venv/bin/python3 $(pwd)/NimPlant.py\"" >>$mypath/.bin/hackertoolkit_bash;
    echo  -e "${sh}$(pwd)/server/venv/bin/python3 $(pwd)/NimPlant.py" > $mypath/.bin/$pck
    chmod +x $mypath/.bin/$pck
    safe_cd ..
    safe_cd ..
    mark_install "$pck"
fi
### SharpC2
# https://github.com/rasta-mouse/SharpC2
pck="SharpC2";
if try_install_dir "$pck" "SharpC2"; then
    git clone https://github.com/rasta-mouse/SharpC2.git --depth 1
    mark_install "$pck"
fi
safe_cd ..
## Distribution
set_category "Distribution"
mkdir -p "Distribution"
safe_cd "Distribution"
### axiom
# - This package will install a lot of things
# - and it needs user or token or password from
# - (aws, azure, do, ibm, linode)
# https://github.com/pry0cc/axiom
pck="axiom";
if try_install "$pck"; then
    sudo apt install packer fzf;
    sudo snap install doctl;
    # bash <(curl -s https://raw.githubusercontent.com/pry0cc/axiom/master/interact/axiom-configure);
    wget -O axiom-install.sh https://raw.githubusercontent.com/pry0cc/axiom/master/interact/axiom-configure;
    chmod +x axiom-install.sh
    ln -s $(pwd)/axiom-install.sh $mypath/.bin/axiom-install.sh
    mark_install "$pck"
fi
### fleex
# https://github.com/FleexSecurity/fleex
pck="fleex";
if try_install "$pck"; then
    go install -v github.com/FleexSecurity/fleex@latest
    mark_install "$pck"
fi
### ShadowClone
# https://github.com/fyoorer/ShadowClone
# -It needs Docker
pck="ShadowClone";
if try_install "$pck"; then
    git clone https://github.com/fyoorer/ShadowClone.git --depth 1;
    cd ShadowClone;
    python3 -m venv venv;
    reqList=$(sed '/^#/d' requirements.txt | tr '\n' ' ');
    venv/bin/pip install $reqList;
    # alias ShadowClone="$(pwd)/venv/bin/python3 $(pwd)/ShadowClone.py" ;
    # echo "alias ShadowClone=\"$(pwd)/venv/bin/python3 $(pwd)/ShadowClone.py\"" >>$mypath/.bin/hackertoolkit_bash;
    echo  -e "${sh}$(pwd)/venv/bin/python3 $(pwd)/ShadowClone.py" > $mypath/.bin/$pck
    chmod +x $mypath/.bin/$pck
    safe_cd ..
    mark_install "$pck"
fi
safe_cd ..
## Phishing-Smishing-Etc
set_category "Phishing-Smishing-Etc"
mkdir -p "Phishing-Smishing-Etc"
safe_cd "Phishing-Smishing-Etc"
### evilginx2
# https://github.com/kgretzky/evilginx2
pck="evilginx";
if try_install "$pck"; then
    wget https://github.com/kgretzky/evilginx2/releases/download/v3.3.0/evilginx-v3.3.0-linux-64bit.zip;
    unzip evilginx-v3.3.0-linux-64bit.zip;
    chmod +x evilginx
    ln -s $(realpath evilginx ) $mypath/.bin/evilginx
    mark_install "$pck"
fi
### gophish
# https://github.com/gophish/gophish
pck="gophish";
if try_install "$pck"; then
    wget https://github.com/gophish/gophish/releases/download/v0.12.1/gophish-v0.12.1-linux-64bit.zip;
    unzip gophish-v0.12.1-linux-64bit;
    chmod +x gophish;
    ln -s $(realpath gophish ) $mypath/.bin/gophish
    mark_install "$pck"
fi
safe_cd ..
## Stealth
set_category "Stealth"
mkdir -p "Stealth"
safe_cd "Stealth"
### evilgophish
# https://github.com/fin3ss3g0d/evilgophish
pck="evilgophish";
if try_install "$pck"; then
    git clone https://github.com/fin3ss3g0d/evilgophish.git --depth 1;
    cd evilgophish/
    chmod +x setup.sh;
    ln -s $(realpath setup.sh ) $mypath/.bin/evilgophish
    safe_cd ..
    mark_install "$pck"
fi
### fireprox
# https://github.com/ustayready/fireprox
pck="fire";
if try_install "$pck"; then
    git clone https://github.com/ustayready/fireprox --depth 1
    cd fireprox
    python3 -m venv venv;
    reqList=$(sed '/^#/d' requirements.txt | tr '\n' ' ');
    venv/bin/pip install $reqList;
    # alias fire="$(pwd)/venv/bin/python3 $(pwd)/fire.py" ;
    # echo "alias fire=\"$(pwd)/venv/bin/python3 $(pwd)/fire.py\"" >>$mypath/.bin/hackertoolkit_bash;
    echo  -e "${sh}$(pwd)/venv/bin/python3 $(pwd)/fire.py" > $mypath/.bin/$pck
    chmod +x $mypath/.bin/$pck
    safe_cd ..
    mark_install "$pck"
fi
### mubeng
# https://github.com/kitabisa/mubeng
pck="mubeng";
if try_install "$pck"; then
    wget -O mubeng https://github.com/kitabisa/mubeng/releases/download/v0.14.2/mubeng_0.14.2_linux_amd64
    chmod +x mubeng
    ln -s $(realpath mubeng ) $mypath/.bin/mubeng
    mark_install "$pck"
fi
### proxycannon-ng
# https://github.com/proxycannon/proxycannon-ng
# - This package modify the behavior of networking of this machine
# - using iptables, ip rules and  sysctl commands, so if you have
# network issues you have to restart your machine
pck="proxycannon-ng";
if try_install_dir "$pck" "proxycannon-ng"; then
    sudo apt install openvpn easy-rsa iptables
    git clone https://github.com/proxycannon/proxycannon-ng.git --depth 1;
    cd proxycannon-ng/setup
    # sudo bash install.sh
    safe_cd ..
    mark_install "$pck"
fi
# =============================================================================
# Wire HackerToolkit into the user's shell so all .bin/* shims resolve next time
# =============================================================================
source "$mypath/.bin/hackertoolkit_bash"
if ! grep -qF "source $mypath/.bin/hackertoolkit_bash" "$HOME/.bashrc" 2>/dev/null; then
    printf '\n# HackerToolkit\nsource %s/.bin/hackertoolkit_bash\n' "$mypath" >>"$HOME/.bashrc"
fi


# =============================================================================
# Completion summary
# =============================================================================
cd "$mypath" 2>/dev/null

# Tally what actually landed (one-line each in install.tmp / not-install.tmp)
INSTALLED_COUNT=0
FAILED_COUNT=0
# grep -c returns rc=1 on zero matches but still prints "0"; the previous
# `|| echo 0` chain produced a multi-line "0\n0" string that broke the
# `[ ... -gt 0 ]` integer test below.
if [ -f install.tmp ]; then
    INSTALLED_COUNT=$(grep -c '^Installed ' install.tmp 2>/dev/null || true)
    INSTALLED_COUNT=${INSTALLED_COUNT:-0}
fi
if [ -f not-install.tmp ]; then
    FAILED_COUNT=$(grep -c '^Not Installed ' not-install.tmp 2>/dev/null || true)
    FAILED_COUNT=${FAILED_COUNT:-0}
fi

echo
hr
printf '%b\n' "${BOLD}${GRN}                 ✓  HackerToolkit setup complete  ✓${NC}"
hr
printf "   ${BOLD}Installed:${NC}  ${GRN}%s${NC} tools\n" "$INSTALLED_COUNT"
if [ "$FAILED_COUNT" -gt 0 ]; then
    printf "   ${BOLD}Failed:   ${NC}  ${RED}%s${NC} tools  ${DIM}see %s/not-install.tmp${NC}\n" "$FAILED_COUNT" "$mypath"
else
    printf "   ${BOLD}Failed:   ${NC}  ${GRN}0${NC} tools\n"
fi
printf "   ${BOLD}Location: ${NC}  %s\n" "$mypath"
printf "   ${BOLD}Bin path: ${NC}  %s/.bin  ${DIM}(added to PATH via ~/.bashrc)${NC}\n" "$mypath"
hr

# -----------------------------------------------------------------------------
# What this script does NOT install — these need a human in the loop because
# they're either (a) Burp Suite extensions that load through Burp's BApp Store,
# or (b) browser extensions that have to be added via the browser's UI.
# -----------------------------------------------------------------------------
hdr "Manual steps required"

printf '\n%b\n' "${BOLD}${YLL}▸ Burp Suite extensions${NC} ${DIM}(open Burp → Extensions → BApp Store, search by name)${NC}"
cat <<'BURP'
   • Active Scan++                  • Autorize                    • Param Miner
   • Additional Scanner Checks      • Burp Bounty Scan Check Bldr • Reflected Parameters
   • Agartha (LFI/RCE/SQLi/Auth)    • Collaborator Everywhere     • Retire.js
   • AutoRepeater                   • Content Type Convertor      • Scavenger
   • Burp VPS Proxy                 • CORS Additional Checks      • Software Vulnerability Scanner
   • Error Message Checks           • Flow                        • SQLiPy SQLmap Integration
   • Freddy Deserialization Finder  • GAP                         • Turbo Intruder
   • GatherContacts                 • HackTools                   • HTTP Request Smuggler
   • InQL — GraphQL Scanner         • IPRotate                    • J2EEScan
   • Java Deserialization Scanner   • JS Miner                    • JSON Web Tokens
BURP

printf '\n%b\n' "${BOLD}${YLL}▸ Browser extensions${NC} ${DIM}(install from your browser's add-on store)${NC}"
cat <<'BROWSER'
   • BuiltWith                      • Cookie-Editor               • Firefox Multi-Account Containers
   • FoxyProxy                      • HackTools                   • Open Multiple URLs
   • PwnFox                         • Trufflehog (browser ext)    • Wappalyzer
   • WhatRuns
BROWSER

printf '\n%b\n' "${BOLD}${YLL}▸ Need API keys / accounts${NC}"
cat <<'KEYS'
   • Shodan          → set SHODAN_API_KEY (used by karma_v2, shosubgo, wtfis)
   • GitHub          → personal access token for github-search, GitLeaks, etc.
   • SecurityTrails  → wtfis
   • VirusTotal      → wtfis
   • Censys          → karma_v2
KEYS

# -----------------------------------------------------------------------------
hdr "Next steps"
printf "   1. ${BOLD}Reload your shell${NC} so the .bin/ aliases resolve:\n"
printf "        ${CYN}source ~/.bashrc${NC}\n"
printf "   2. ${BOLD}Verify a tool resolves:${NC}\n"
printf "        ${CYN}which ffuf gobuster nuclei evilginx${NC}\n"
printf "   3. ${BOLD}Read the full tool catalog:${NC}\n"
printf "        ${CYN}less %s/README.md${NC}\n" "$(dirname "$mypath")"
if [ "$FAILED_COUNT" -gt 0 ]; then
    printf "   4. ${BOLD}Review failed installs:${NC}\n"
    printf "        ${CYN}cat %s/not-install.tmp${NC}\n" "$mypath"
fi

hr
printf "${BOLD}${MAG}     Happy hacking — stay legal, stay curious. ⚡${NC}\n\n"
# END
