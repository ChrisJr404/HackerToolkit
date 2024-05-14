#!/bin/bash

# - Function for checking dependencies
exist(){
    e=$(whereis $1 | awk '{print $2}')
    if [ "$e" == "" ]; then
        echo "$1 is not found" 
        echo "Installing dependencies..."
        if [ -z "$2" ]; then
            sudo apt -y install $1
        else
            sudo apt -y install $2
        fi
        return 1
    else
        return 0
    fi
}
YLL='\033[1;33m'
RED='\033[0;31m'
BLU='\033[1;34m'
NC='\033[0m' # No Color
sh='#!/bin/bash\n'

# echo "$mypath---${mypath}"
# exit 0

# - Delete any previous installation
# printf "Deleting previous installation in 3 sec...\r"
# sleep 1
# printf "Deleting previous installation in 2 sec...\r"
# sleep 1
# printf "Deleting previous installation in 1 sec...\r"
# sleep 1
# echo ""

# - Delete all in HackerToolkit folder
# rm -rf HackerToolkit


# - Main folder

mkdir -p HackerToolkit
mkdir -p HackerToolkit/.bin
cd HackerToolkit
mypath=$(pwd)


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
echo "Stay in front of your keyboard, this is not a completely unattended installation..."
sleep 2 
exist git 
exist wget
exist gcc

# exist go 
# - to avoid configures alternatives versions of go
# - I will use a local version, the lastest on this path
echo "Local version of go..."
cd .bin
if [ ! -e  $mypath/.bin/go1.21.4.linux-amd64.tar.gz ]; then
    wget https://go.dev/dl/go1.21.4.linux-amd64.tar.gz
    tar -C . -xzf go1.21.4.linux-amd64.tar.gz
fi
go/bin/go version
# - Only while this script is running
alias go="$mypath/.bin/go/bin/go"
# go binaries path

regexGoPath="$HOME/go"
if [[ "$mypath/.bin/hackertoolkit_bash" =~ $regexHackPath ]];then
    echo "go PATH found!"
else
    export GOPATH=$HOME/go;
    echo "export GOPATH=\$HOME/go;" >>$mypath/.bin/hackertoolkit_bash
    export PATH=$PATH:$HOME/go/bin
    echo "export PATH=\$PATH:$HOME/go/bin" >>$mypath/.bin/hackertoolkit_bash

    go env -w CGO_ENABLED=1;
fi


cd ..


exist pip3 "python3-pip"
exist pipx
# exist seclists
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
mkdir -p "Enumeration-Recon-Tools"
cd "Enumeration-Recon-Tools"

## Ad & Analytic Trackers
mkdir -p "Ad-Analytic-Trackers"
cd "Ad-Analytic-Trackers"

echo "Installing ... "

### relations.sh
pck="relations"
echo "[+] $pck"
if [ -z  "$(which $pck)" ]; then
    wget -O $pck https://gist.github.com/hateshape/393ab7003023f3b13126a4892100c8ff
    chmod +x relations.sh
    ln -s $(realpath relations.sh) $mypath/.bin/relations
    if [ $? -eq 0 ]; then echo -e "Installed ${YLL}$pck${NC}";echo "Installed $pck">>$mypath/install.tmp; else echo "Not Installed $pck">>$mypath/not-install.tmp; fi
    echo 
else
    echo -e "${BLU}$pck${NC} already installed. Skipping..."
fi

cd ..
## Apex Domain Enumeration
mkdir -p "Apex-Domain-Enumeration"
cd "Apex-Domain-Enumeration"

### check_mdi
# https://github.com/expl0itabl3/check_mdi
pck="check_mdi"
echo "[+] $pck"
if [ -z  "$(which $pck)" ]; then
    git clone 'https://github.com/expl0itabl3/check_mdi.git' --depth 1
    cd check_mdi
    # alias check_mdi="python3 $(pwd)/check_mdi.py" 
    # echo "alias check_mdi=\"python3 $(pwd)/check_mdi.py\"" >>$mypath/.bin/hackertoolkit_bash
    echo  -e "${sh}python3 $(pwd)/check_mdi.py" > $mypath/.bin/$pck
    chmod +x $mypath/.bin/$pck
    if [ $? -eq 0 ]; then echo -e "Installed ${YLL}$pck${NC}";echo "Installed $pck">>$mypath/install.tmp; else echo "Not Installed $pck">>$mypath/not-install.tmp; fi
    echo 
    cd ..
else
    echo -e "${BLU}$pck${NC} already installed. Skipping..."
fi



### CloudRecon
# https://github.com/g0ldencybersec/CloudRecon
pck="CloudRecon"
echo "[+] $pck"
if [ -z  "$(which $pck)" ]; then
    export GOPATH=$HOME/go;
    go env -w CGO_ENABLED=1;
    go install github.com/g0ldencybersec/CloudRecon@latest;
    if [ $? -eq 0 ]; then echo -e "Installed ${YLL}$pck${NC}";echo "Installed $pck">>$mypath/install.tmp; else echo "Not Installed $pck">>$mypath/not-install.tmp; fi
    echo 
else
    echo -e "${BLU}$pck${NC} already installed. Skipping..."
fi

### FavFreak
# https://github.com/devanshbatham/FavFreak
pck="FavFreak"
echo "[+] $pck"
if [ -z  "$(which $pck)" ]; then
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
    if [ $? -eq 0 ]; then echo -e "Installed ${YLL}$pck${NC}";echo "Installed $pck">>$mypath/install.tmp; else echo "Not Installed $pck">>$mypath/not-install.tmp; fi
    echo 
    deactivate xxx
    cd ..
else
    echo -e "${BLU}$pck${NC} already installed. Skipping..."
fi




cd ..
## Archival Enumeration
mkdir -p "Archival-Enumeration"
cd "Archival-Enumeration"

### gau
# https://github.com/lc/gau
pck="gau";
echo "[+] $pck";
if [ -z  "$(which $pck)" ]; then
    git clone https://github.com/lc/gau.git --depth 1;
    cd gau/cmd/gau;
    go build;
    # sudo mv gau /usr/local/bin/
    ln -s $(pwd)/gau $mypath/.bin/gau
    cd ../..
    cp .gau.toml $HOME/
    gau --version;
    if [ $? -eq 0 ]; then echo -e "Installed ${YLL}$pck${NC}";echo "Installed $pck">>$mypath/install.tmp; else echo "Not Installed $pck">>$mypath/not-install.tmp; fi
    echo 
    cd ..
else
    echo -e "${BLU}$pck${NC} already installed. Skipping..."
fi


### waymore
# https://github.com/xnl-h4ck3r/waymore
pck="waymore"
echo "[+] $pck"
if [ -z  "$(which $pck)" ]; then
    pipx install waymore
    if [ $? -eq 0 ]; then echo -e "Installed ${YLL}$pck${NC}";echo "Installed $pck">>$mypath/install.tmp; else echo "Not Installed $pck">>$mypath/not-install.tmp; fi
    echo 
    pipx ensurepath
else
    echo -e "${BLU}$pck${NC} already installed. Skipping..."
fi

cd ..
## Change Detection
mkdir -p "Change-Detection"
cd "Change-Detection"



### changedetection.io
# https://github.com/dgtlmoon/changedetection.io
pck="changedetection.io"
echo "[+] $pck"
if [ -z  "$(which $pck)" ]; then
    pipx install changedetection.io
    # changedetection.io -d /path/to/empty/data/dir -p 5000
    if [ $? -eq 0 ]; then echo -e "Installed ${YLL}$pck${NC}";echo "Installed $pck">>$mypath/install.tmp; else echo "Not Installed $pck">>$mypath/not-install.tmp; fi
    echo 
else
    echo -e "${BLU}$pck${NC} already installed. Skipping..."
fi



cd ..
## Credential Collection Tools
mkdir -p "Credential-Collection-Tools"
cd "Credential-Collection-Tools"

### deepdarkCTI
# https://github.com/fastfire/deepdarkCTI/tree/main
pck="deepdarkCTI"
echo "[+] $pck"
if [ ! -d  "$(pwd)/deepdarkCTI" ]; then
    git clone 'https://github.com/fastfire/deepdarkCTI.git' --depth 1
    if [ $? -eq 0 ]; then echo -e "Installed ${YLL}$pck${NC}";echo "Installed $pck">>$mypath/install.tmp; else echo "Not Installed $pck">>$mypath/not-install.tmp; fi
    echo 
else
    echo -e "${BLU}$pck${NC} already installed. Skipping..."
fi


### h8mail
# https://github.com/khast3x/h8mail
pck="h8mail"
echo "[+] $pck"
if [ -z  "$(which $pck)" ]; then
    pipx install h8mail
    if [ $? -eq 0 ]; then echo -e "Installed ${YLL}$pck${NC}";echo "Installed $pck">>$mypath/install.tmp; else echo "Not Installed $pck">>$mypath/not-install.tmp; fi
    echo 
else
    echo -e "${BLU}$pck${NC} already installed. Skipping..."
fi



### hacxx-underground
# https://github.com/hacxx-underground/Files
pck="hacxx-underground"
echo "[+] $pck"
if [ ! -d  "$(pwd)/$pck" ]; then
    git clone 'https://github.com/hacxx-underground/Files.git' hacxx-underground --depth 1
    if [ $? -eq 0 ]; then echo -e "Installed ${YLL}$pck${NC}";echo "Installed $pck">>$mypath/install.tmp; else echo "Not Installed $pck">>$mypath/not-install.tmp; fi
    echo 
else
    echo -e "${BLU}$pck${NC} already installed. Skipping..."
fi
### linkedin2username
# https://github.com/initstring/linkedin2username
pck="linkedin2username";
echo "[+] $pck";
if [ -z  "$(which $pck)" ]; then
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
    if [ $? -eq 0 ]; then echo -e "Installed ${YLL}$pck${NC}";echo "Installed $pck">>$mypath/install.tmp; else echo "Not Installed $pck">>$mypath/not-install.tmp; fi
    echo 
    cd ..
else
    echo -e "${BLU}$pck${NC} already installed. Skipping..."
fi


### WeakestLink
# https://github.com/shellfarmer/WeakestLink
pck="WeakestLink"
echo "[+] $pck"
if [ -z  "$(which $pck)" ]; then
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




cd ..
## Custom Wordlists
mkdir -p "Custom-Wordlists"
cd "Custom-Wordlists"

### CeWL
# https://github.com/digininja/CeWL
pck="cewl"
echo "[+] $pck"
if [ -z  "$(which $pck)" ]; then
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
    if [ $? -eq 0 ]; then echo -e "Installed ${YLL}$pck${NC}";echo "Installed $pck">>$mypath/install.tmp; else echo "Not Installed $pck">>$mypath/not-install.tmp; fi
    echo 
    cd ..
else
    echo -e "${BLU}$pck${NC} already installed. Skipping..."
fi



### wordlistgen
# https://github.com/ameenmaali/wordlistgen
pck="wordlistgen";
echo "[+] $pck";
if [ -z  "$(which $pck)" ]; then
    # go get -u github.com/ameenmaali/wordlistgen
    git clone https://github.com/ameenmaali/wordlistgen.git;
    cd wordlistgen/
    go mod init wordlistgen/v3
    go get
    go install
    if [ $? -eq 0 ]; then echo -e "Installed ${YLL}$pck${NC}";echo "Installed $pck">>$mypath/install.tmp; else echo "Not Installed $pck">>$mypath/not-install.tmp; fi
    echo 
    cd ..
else
    echo -e "${BLU}$pck${NC} already installed. Skipping..."
fi

cd ..
## Directory Enumeration
mkdir -p "Directory-Enumeration"
cd "Directory-Enumeration"

### dirsearch
# https://github.com/maurosoria/dirsearch
pck="dirsearch"
echo "[+] $pck"
if [ -z  "$(which $pck)" ]; then
    git clone https://github.com/maurosoria/dirsearch.git --depth 1
    echo  -e "${sh}ls -al dirsearch" > $mypath/.bin/$pck
    chmod +x $mypath/.bin/$pck
    if [ $? -eq 0 ]; then echo -e "Installed ${YLL}$pck${NC}";echo "Installed $pck">>$mypath/install.tmp; else echo "Not Installed $pck">>$mypath/not-install.tmp; fi
    echo 
else
    echo -e "${BLU}$pck${NC} already installed. Skipping..."
fi

### feroxbuster
pck="feroxbuster";
# https://github.com/epi052/feroxbuster
echo "[+] $pck"
if [ -z  "$(which $pck)" ]; then
    curl -sL https://raw.githubusercontent.com/epi052/feroxbuster/main/install-nix.sh | bash
    ln -s $(pwd)/feroxbuster $mypath/.bin/feroxbuster
    if [ $? -eq 0 ]; then echo -e "Installed ${YLL}$pck${NC}";echo "Installed $pck">>$mypath/install.tmp; else echo "Not Installed $pck">>$mypath/not-install.tmp; fi
    echo 
else
    echo -e "${BLU}$pck${NC} already installed. Skipping..."
fi



### ffuf
# https://github.com/ffuf/ffuf
pck="ffuf"
echo "[+] $pck"
if [ -z  "$(which $pck)" ]; then
    go install github.com/ffuf/ffuf/v2@latest
    if [ $? -eq 0 ]; then echo -e "Installed ${YLL}$pck${NC}";echo "Installed $pck">>$mypath/install.tmp; else echo "Not Installed $mypath/$pck" >>not-install.tmp; fi
    echo 
else
    echo -e "${BLU}$pck${NC} already installed. Skipping..."
fi


### gobuster
# https://github.com/OJ/gobuster
pck="gobuster";
echo "[+] $pck"
if [ -z  "$(which $pck)" ]; then
    go install github.com/OJ/gobuster/v3@latest
    if [ $? -eq 0 ]; then echo -e "Installed ${YLL}$pck${NC}";echo "Installed $pck">>$mypath/install.tmp; else echo "Not Installed $pck">>$mypath/not-install.tmp; fi
    echo 
else
    echo -e "${BLU}$pck${NC} already installed. Skipping..."
fi


### wfuzz
pck="wfuzz";
# https://github.com/xmendez/wfuzz
echo "[+] $pck"
if [ -z  "$(which $pck)" ]; then
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
    if [ $? -eq 0 ]; then echo -e "Installed ${YLL}$pck${NC}";echo "Installed $pck">>$mypath/install.tmp; else echo "Not Installed $pck">>$mypath/not-install.tmp; fi
    echo 
    cd ..
else
    echo -e "${BLU}$pck${NC} already installed. Skipping..."
fi



cd ..
## Github Enumeration
mkdir -p "Github Enumeration"
cd "Github Enumeration"

### github-search
# https://github.com/gwen001/github-search
pck="github-search";
echo "[+] $pck"
if [ ! -d  "$(pwd)/github-search" ]; then
    git clone https://github.com/gwen001/github-search
    cd github-search
    # pip3 install -r requirements.txt
    python3 -m venv venv
    reqList=$(sed '/^#/d' requirements.txt | tr '\n' ' ')
    venv/bin/pip install $reqList
    # - this package, like john the ripper has many tools, so it's better add the run path to the system executable PATH
    export PATH="$PATH:$(realpath . )"
    echo "export PATH=\"\$PATH:$(realpath . )\"" >>$mypath/.bin/hackertoolkit_bash
    if [ $? -eq 0 ]; then echo -e "Installed ${YLL}$pck${NC}";echo "Installed $pck">>$mypath/install.tmp; else echo "Not Installed $pck">>$mypath/not-install.tmp; fi
    echo 
    cd ..
else
    echo -e "${BLU}$pck${NC} already installed. Skipping..."
fi




### gitleaks
# https://github.com/gitleaks/gitleaks
pck="gitleaks";
echo "[+] $pck"
if [ -z  "$(which $pck)" ]; then
    git clone https://github.com/gitleaks/gitleaks.git
    cd gitleaks
    make build
    # make install
    # -Installed on /usr/local/bin/gitleaks
    if [ $? -eq 0 ]; then echo -e "Installed ${YLL}$pck${NC}";echo "Installed $pck">>$mypath/install.tmp; else echo "Not Installed $pck">>$mypath/not-install.tmp; fi
    echo 
    cd ..
else
    echo -e "${BLU}$pck${NC} already installed. Skipping..."
fi


cd ..
## JavaScript
mkdir -p "JavaScript"
cd "JavaScript"

### jsluice
# https://github.com/BishopFox/jsluice
pck="jsluice";
echo "[+] $pck"
if [ -z  "$(which $pck)" ]; then
    go install github.com/BishopFox/jsluice/cmd/jsluice@latest
    if [ $? -eq 0 ]; then echo -e "Installed ${YLL}$pck${NC}";echo "Installed $pck">>$mypath/install.tmp; else echo "Not Installed $pck">>$mypath/not-install.tmp; fi
    echo 
else
    echo -e "${BLU}$pck${NC} already installed. Skipping..."
fi



### LinkFinder
# https://github.com/GerbenJavado/LinkFinder
pck="linkfinder";
echo "[+] $pck"
if [ -z  "$(which $pck)" ]; then
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
    if [ $? -eq 0 ]; then echo -e "Installed ${YLL}$pck${NC}";echo "Installed $pck">>$mypath/install.tmp; else echo "Not Installed $pck">>$mypath/not-install.tmp; fi
    echo 
    cd ..
else
    echo -e "${BLU}$pck${NC} already installed. Skipping..."
fi



cd ..
## Mobile App Enumeration
mkdir -p "Mobile-App-Enumeration"
cd "Mobile-App-Enumeration"

### apkleaks
# https://github.com/dwisiswant0/apkleaks
#  it utilizes jadx
pck="apkleaks";
echo "[+] $pck"
if [ -z  "$(which $pck)" ]; then
    pipx install apkleaks
    if [ $? -eq 0 ]; then echo -e "Installed ${YLL}$pck${NC}";echo "Installed $pck">>$mypath/install.tmp; else echo "Not Installed $pck">>$mypath/not-install.tmp; fi
    echo 
else
    echo -e "${BLU}$pck${NC} already installed. Skipping..."
fi



cd ..
## Port-Scanners-(Active)
mkdir -p "Port-Scanners-Active"
cd "Port-Scanners-Active"

### AutoRecon
# https://github.com/Tib3rius/AutoRecon
pck="autorecon";
echo "[+] $pck"
## tnscmd10g
if [ -z  "$(which $pck)" ]; then
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
    if [ $? -eq 0 ]; then echo -e "Installed ${YLL}$pck${NC}";echo "Installed $pck">>$mypath/install.tmp; else echo "Not Installed $pck">>$mypath/not-install.tmp; fi
    echo 
    cd ..
else
    echo -e "${BLU}$pck${NC} already installed. Skipping..."
fi




### masscan
# https://github.com/robertdavidgraham/masscan
pck="masscan";
echo "[+] $pck";
if [ -z  "$(which $pck)" ]; then
    sudo apt-get --assume-yes install git make gcc;
    git clone https://github.com/robertdavidgraham/masscan --depth 1;
    cd masscan;
    make;
    sudo make install;
    if [ $? -eq 0 ]; then echo -e "Installed ${YLL}$pck${NC}";echo "Installed $pck">>$mypath/install.tmp; else echo "Not Installed $pck">>$mypath/not-install.tmp; fi
    make clean
    echo 
    cd ..
else
    echo -e "${BLU}$pck${NC} already installed. Skipping..."
fi



### naabu
# https://github.com/projectdiscovery/naabu
pck="naabu";
echo "[+] $pck"
if [ -z  "$(which $pck)" ]; then
    sudo apt install -y libpcap-dev
    go install -v github.com/projectdiscovery/naabu/v2/cmd/naabu@latest
    if [ $? -eq 0 ]; then echo -e "Installed ${YLL}$pck${NC}";echo "Installed $pck">>$mypath/install.tmp; else echo "Not Installed $pck">>$mypath/not-install.tmp; fi
    echo 
else
    echo -e "${BLU}$pck${NC} already installed. Skipping..."
fi
### nmap
# https://github.com/nmap/nmap
# - Instaled as dependency of AutoRecon
pck="nmap";
echo "[+] $pck"
nmap -V
if [ $? -eq 0 ]; then echo -e "Installed ${YLL}$pck${NC}";echo "Installed $pck">>$mypath/install.tmp; else echo "Not Installed $pck">>$mypath/not-install.tmp; fi
echo 


# https://github.com/RustScan/RustScan
pck="rustscan";
echo "[+] $pck";
if [ -z  "$(which $pck)" ]; then
    wget https://github.com/RustScan/RustScan/releases/download/2.2.2/rustscan_2.2.2_amd64.deb;
    sudo dpkg -i rustscan_2.2.2_amd64.deb;
    if [ $? -eq 0 ]; then echo -e "Installed ${YLL}$pck${NC}";echo "Installed $pck">>$mypath/install.tmp; else echo "Not Installed $pck">>$mypath/not-install.tmp; fi
    echo 
else
    echo -e "${BLU}$pck${NC} already installed. Skipping..."
fi

cd ..
## Port-Scanners-(Passive)
mkdir -p "Port-Scanners-Passive"
cd "Port-Scanners-Passive"


# https://github.com/s0md3v/Smap
pck="smap";
echo "[+] $pck"
if [ -z  "$(which $pck)" ]; then
    wget -O smap.tar.xz https://github.com/s0md3v/Smap/releases/download/0.1.12/smap_0.1.12_linux_amd64.tar.xz
    tar -xf smap.tar.xz
    ln -s $(pwd)/smap_0.1.12_linux_amd64/smap $mypath/.bin/smap
    if [ $? -eq 0 ]; then echo -e "Installed ${YLL}$pck${NC}";echo "Installed $pck">>$mypath/install.tmp; else echo "Not Installed $pck">>$mypath/not-install.tmp; fi
    echo
else
    echo -e "${BLU}$pck${NC} already installed. Skipping..."
fi



cd ..
## Recon Frameworks
mkdir -p "Recon-Frameworks"
cd "Recon-Frameworks"


# https://github.com/six2dez/reconftw
pck="reconftw";
echo "[+] $pck"
if [ -z  "$(which $pck)" ]; then
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
    if [ $? -eq 0 ]; then echo -e "Installed ${YLL}$pck${NC}";echo "Installed $pck">>$mypath/install.tmp; else echo "Not Installed $pck">>$mypath/not-install.tmp; fi
    echo
    cd ..
else
    echo -e "${BLU}$pck${NC} already installed. Skipping..."
fi



### recon-ng
# https://github.com/lanmaster53/recon-ng
pck="recon-ng";
echo "[+] $pck";
if [ -z  "$(which $pck)" ]; then
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
    if [ $? -eq 0 ]; then echo -e "Installed ${YLL}$pck${NC}";echo "Installed $pck">>$mypath/install.tmp; else echo "Not Installed $pck">>$mypath/not-install.tmp; fi
    echo
    cd ..
else
    echo -e "${BLU}$pck${NC} already installed. Skipping..."
fi



### rengine 
# https://github.com/yogeshojha/rengine
# -This package install docker and others 43 packages more, I think they are the same 
# - of reconftw
pck="rengine";
echo "[+] $pck"
if [ -z  "$(which ${pck}-install)" ]; then
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
    if [ $? -eq 0 ]; then echo -e "Installed ${YLL}$pck${NC}";echo "Installed $pck">>$mypath/install.tmp; else echo "Not Installed $pck">>$mypath/not-install.tmp; fi
    echo
    cd ..
else
    echo -e "${BLU}$pck${NC} already installed. Skipping..."
fi



cd ..
## Shodan Tools
mkdir -p "Shodan-Tools"
cd "Shodan-Tools"

### karma_v2
# https://github.com/Dheerajmadhukar/karma_v2
pck="karma_v2";
echo "[+] $pck"
if [ -z  "$(which $pck)" ]; then
    git clone https://github.com/Dheerajmadhukar/karma_v2.git --depth 1
    # python3 -m pip install shodan mmh3
    if [ -z  "$(which shodan)" ]; then
        pipx install shodan
    fi
    cd karma_v2
    chmod +x karma_v2
    ln -s $(pwd)/$pck $mypath/.bin/$pck
    cd ..
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
    if [ $? -eq 0 ]; then echo -e "Installed ${YLL}$pck${NC}";echo "Installed $pck">>$mypath/install.tmp; else echo "Not Installed $pck">>$mypath/not-install.tmp; fi
    echo
    cd ..
else
    echo -e "${BLU}$pck${NC} already installed. Skipping..."
fi


### shosubgo
# https://github.com/incogbyte/shosubgo
pck="shosubgo";
echo "[+] $pck"
if [ -z  "$(which $pck)" ]; then
    go install github.com/incogbyte/shosubgo@latest
    # verify inside your $GOPATH the folder "bin", maybe $HOME/go/bin
    if [ $? -eq 0 ]; then echo -e "Installed ${YLL}$pck${NC}";echo "Installed $pck">>$mypath/install.tmp; else echo "Not Installed $pck">>$mypath/not-install.tmp; fi
    echo
else
    echo -e "${BLU}$pck${NC} already installed. Skipping..."
fi

### Already installed Smap
# https://github.com/s0md3v/Smap


### wtfis
# https://github.com/pirxthepilot/wtfis
pck="wtfis";
echo "[+] $pck"
if [ -z  "$(which $pck)" ]; then
    pipx install wtfis
    if [ $? -eq 0 ]; then echo -e "Installed ${YLL}$pck${NC}";echo "Installed $pck">>$mypath/install.tmp; else echo "Not Installed $pck">>$mypath/not-install.tmp; fi
    echo
else
    echo -e "${BLU}$pck${NC} already installed. Skipping..."
fi




cd ..
## Screenshotting
mkdir -p "Screenshotting"
cd "Screenshotting"

### aquatone
# https://github.com/michenriksen/aquatone
pck="aquatone";
echo "[+] $pck"
if [ -z  "$(which $pck)" ]; then
    wget -O aquatone.zip https://github.com/michenriksen/aquatone/releases/download/v1.7.0/aquatone_linux_amd64_1.7.0.zip
    unzip aquatone.zip
    cd aquatone/
    ln -s $(pwd)/aquatone $mypath/.bin/aquatone
    if [ $? -eq 0 ]; then echo -e "Installed ${YLL}$pck${NC}";echo "Installed $pck">>$mypath/install.tmp; else echo "Not Installed $pck">>$mypath/not-install.tmp; fi
    echo
    cd ..
else
    echo -e "${BLU}$pck${NC} already installed. Skipping..."
fi



### eyeballer
# https://github.com/BishopFox/eyeballer
pck="eyeballer";
echo "[+] $pck"
if [ -z  "$(which $pck)" ]; then
    git clone https://github.com/BishopFox/eyeballer.git --depth 1
    cd eyeballer
    python3 -m venv venv
    reqList=$(sed '/^#/d' requirements.txt | tr '\n' ' ')
    venv/bin/pip install $reqList
    # alias eyeballer="$(pwd)/venv/bin/python3 $(pwd)/eyeballer.py" 
    # echo "alias eyeballer=\"$(pwd)/venv/bin/python3 $(pwd)/eyeballer.py\"" >>$mypath/.bin/hackertoolkit_bash
    echo  -e "${sh}$(pwd)/venv/bin/python3 $(pwd)/eyeballer.py" > $mypath/.bin/$pck
    chmod +x $mypath/.bin/$pck
    if [ $? -eq 0 ]; then echo -e "Installed ${YLL}$pck${NC}";echo "Installed $pck">>$mypath/install.tmp; else echo "Not Installed $pck">>$mypath/not-install.tmp; fi
    echo
    cd ..
else
    echo -e "${BLU}$pck${NC} already installed. Skipping..."
fi



### EyeWitness
# https://github.com/RedSiege/EyeWitness
pck="EyeWitness";
echo "[+] $pck"
if [ ! -d  "$(pwd)/$pck" ]; then
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
echo "[+] $pck"
if [ -z  "$(which $pck)" ]; then
    wget -O go-stare.tar.gz https://github.com/dwisiswant0/go-stare/releases/download/v0.0.3-dev/go-stare_0.0.3-dev_linux_arm64.tar.gz
    tar -C . -xzf go-stare.tar.gz
    ln -s $(pwd)/go-stare $mypath/.bin/go-stare
    if [ $? -eq 0 ]; then echo -e "Installed ${YLL}$pck${NC}";echo "Installed $pck">>$mypath/install.tmp; else echo "Not Installed $pck">>$mypath/not-install.tmp; fi
    echo
else
    echo -e "${BLU}$pck${NC} already installed. Skipping..."
fi


### httpscreenshot
# https://github.com/breenmachine/httpscreenshot
pck="httpscreenshot";
echo "[+] $pck"
if [ -z  "$(which $pck)" ]; then
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
    if [ $? -eq 0 ]; then echo -e "Installed ${YLL}$pck${NC}";echo "Installed $pck">>$mypath/install.tmp; else echo "Not Installed $pck">>$mypath/not-install.tmp; fi
    echo
    cd ..
else
    echo -e "${BLU}$pck${NC} already installed. Skipping..."
fi



### httpx
# https://github.com/projectdiscovery/httpx
pck="httpx";
echo "[+] $pck"
if [ -z  "$(which $pck)" ]; then
    go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
    # - Installed on $HOME/go/bin
    if [ $? -eq 0 ]; then echo -e "Installed ${YLL}$pck${NC}";echo "Installed $pck">>$mypath/install.tmp; else echo "Not Installed $pck">>$mypath/not-install.tmp; fi
    echo
else
    echo -e "${BLU}$pck${NC} already installed. Skipping..."
fi



cd ..
## Spiders
mkdir -p "Spiders"
cd "Spiders"

### gospider
# https://github.com/jaeles-project/gospider
pck="gospider";
echo "[+] $pck"
if [ -z  "$(which $pck)" ]; then
    go install github.com/jaeles-project/gospider@latest
    # - Installed on $HOME/go/bin
    if [ $? -eq 0 ]; then echo -e "Installed ${YLL}$pck${NC}";echo "Installed $pck">>$mypath/install.tmp; else echo "Not Installed $pck">>$mypath/not-install.tmp; fi
    echo
else
    echo -e "${BLU}$pck${NC} already installed. Skipping..."
fi


### katana
# https://github.com/projectdiscovery/katana
pck="katana";
echo "[+] $pck"
if [ -z  "$(which $pck)" ]; then
    go install github.com/projectdiscovery/katana/cmd/katana@latest
    # - Installed on $HOME/go/bin
    if [ $? -eq 0 ]; then echo -e "Installed ${YLL}$pck${NC}";echo "Installed $pck">>$mypath/install.tmp; else echo "Not Installed $pck">>$mypath/not-install.tmp; fi
    echo
else
    echo -e "${BLU}$pck${NC} already installed. Skipping..."
fi


### hakrawler
# https://github.com/hakluke/hakrawler
pck="hakrawler";
echo "[+] $pck"
if [ -z  "$(which $pck)" ]; then
    go install github.com/hakluke/hakrawler@latest
    # - Installed on $HOME/go/bin
    if [ $? -eq 0 ]; then echo -e "Installed ${YLL}$pck${NC}";echo "Installed $pck">>$mypath/install.tmp; else echo "Not Installed $pck">>$mypath/not-install.tmp; fi
    echo
else
    echo -e "${BLU}$pck${NC} already installed. Skipping..."
fi



cd ..
## Subdomain-Enumeration-and-Brute-Force
mkdir -p "Subdomain-Enumeration-and-Brute-Force"
cd "Subdomain-Enumeration-and-Brute-Force"


### altdns
# https://github.com/infosec-au/altdns
pck="altdns";
echo "[+] $pck"
if [ -z  "$(which $pck)" ]; then
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
    if [ $? -eq 0 ]; then echo -e "Installed ${YLL}$pck${NC}";echo "Installed $pck">>$mypath/install.tmp; else echo "Not Installed $pck">>$mypath/not-install.tmp; fi
    echo
    cd ..
else
    echo -e "${BLU}$pck${NC} already installed. Skipping..."
fi

### alterx
# https://github.com/projectdiscovery/alterx
pck="alterx";
echo "[+] $pck"
if [ -z  "$(which $pck)" ]; then
    go install github.com/projectdiscovery/alterx/cmd/alterx@latest
    if [ $? -eq 0 ]; then echo -e "Installed ${YLL}$pck${NC}";echo "Installed $pck">>$mypath/install.tmp; else echo "Not Installed $pck">>$mypath/not-install.tmp; fi
    echo
else
    echo -e "${BLU}$pck${NC} already installed. Skipping..."
fi


### amass
# https://github.com/owasp-amass/amass
pck="amass";
echo "[+] $pck"
if [ -z  "$(which $pck)" ]; then
    go install -v github.com/owasp-amass/amass/v4/...@master
    if [ $? -eq 0 ]; then echo -e "Installed ${YLL}$pck${NC}";echo "Installed $pck">>$mypath/install.tmp; else echo "Not Installed $pck">>$mypath/not-install.tmp; fi
    echo
else
    echo -e "${BLU}$pck${NC} already installed. Skipping..."
fi


### assetfinder
# https://github.com/tomnomnom/assetfinder
pck="assetfinder";
echo "[+] $pck"
if [ -z  "$(which $pck)" ]; then
    # go get -u github.com/tomnomnom/assetfinder
    go install -v github.com/tomnomnom/assetfinder@latest
    if [ $? -eq 0 ]; then echo -e "Installed ${YLL}$pck${NC}";echo "Installed $pck">>$mypath/install.tmp; else echo "Not Installed $pck">>$mypath/not-install.tmp; fi
    echo
else
    echo -e "${BLU}$pck${NC} already installed. Skipping..."
fi


### bbot
# https://github.com/blacklanternsecurity/bbot
pck="bbot";
echo "[+] $pck"
if [ -z  "$(which $pck)" ]; then
    pipx install bbot
    if [ $? -eq 0 ]; then echo -e "Installed ${YLL}$pck${NC}";echo "Installed $pck">>$mypath/install.tmp; else echo "Not Installed $pck">>$mypath/not-install.tmp; fi
    echo
else
    echo -e "${BLU}$pck${NC} already installed. Skipping..."
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
echo "[+] $pck"
if [ -z  "$(which $pck)" ]; then
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
    if [ $? -eq 0 ]; then echo -e "Installed ${YLL}$pck${NC}";echo "Installed $pck">>$mypath/install.tmp; else echo "Not Installed $pck">>$mypath/not-install.tmp; fi
    echo
    cd ..
else
    echo -e "${BLU}$pck${NC} already installed. Skipping..."
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
echo "[+] $pck";
if [ -z  "$(which $pck)" ]; then
    git clone https://github.com/findomain/findomain.git;
    cd findomain;
    cargo build --release;
    cp target/release/findomain $mypath/.bin ;
    if [ $? -eq 0 ]; then echo -e "Installed ${YLL}$pck${NC}";echo "Installed $pck">>$mypath/install.tmp; else echo "Not Installed $pck">>$mypath/not-install.tmp; fi
    echo
    cd ..
else
    echo -e "${BLU}$pck${NC} already installed. Skipping..."
fi


### github-subdomains
# https://github.com/gwen001/github-subdomains
pck="github-subdomains";
echo "[+] $pck"
if [ -z  "$(which $pck)" ]; then
    go install github.com/gwen001/github-subdomains@latest
    if [ $? -eq 0 ]; then echo -e "Installed ${YLL}$pck${NC}";echo "Installed $pck">>$mypath/install.tmp; else echo "Not Installed $pck">>$mypath/not-install.tmp; fi
    echo
else
    echo -e "${BLU}$pck${NC} already installed. Skipping..."
fi

### gotator
# https://github.com/Josue87/gotator
pck="gotator";
echo "[+] $pck"
if [ -z  "$(which $pck)" ]; then
    go install github.com/Josue87/gotator@latest
    if [ $? -eq 0 ]; then echo -e "Installed ${YLL}$pck${NC}";echo "Installed $pck">>$mypath/install.tmp; else echo "Not Installed $pck">>$mypath/not-install.tmp; fi
    echo
else
    echo -e "${BLU}$pck${NC} already installed. Skipping..."
fi


### puredns
# https://github.com/d3mondev/puredns
pck="puredns";
echo "[+] $pck"
if [ -z  "$(which $pck)" ]; then
    wget https://github.com/d3mondev/puredns/releases/download/v2.1.1/puredns-Linux-amd64.tgz;
    tar -C . -xzf puredns-Linux-amd64.tgz;
    ln -s $(realpath puredns) $mypath/.bin/puredns
    if [ $? -eq 0 ]; then echo -e "Installed ${YLL}$pck${NC}";echo "Installed $pck">>$mypath/install.tmp; else echo "Not Installed $pck">>$mypath/not-install.tmp; fi
    echo
else
    echo -e "${BLU}$pck${NC} already installed. Skipping..."
fi


### regulator
# https://github.com/cramppet/regulator
pck="regulator";
echo "[+] $pck"
if [ -z  "$(which $pck)" ]; then
    git clone https://github.com/cramppet/regulator.git --depth 1;
    cd regulator;
    python3 -m venv venv;
    reqList=$(sed '/^#/d' requirements.txt | tr '\n' ' ');
    venv/bin/pip install $reqList;
    # alias regulator="$(pwd)/venv/bin/python3 $(pwd)/main.py" 
    # echo "alias regulator=\"$(pwd)/venv/bin/python3 $(pwd)/main.py\"" >>$mypath/.bin/hackertoolkit_bash
    echo  -e "${sh}$(pwd)/venv/bin/python3 $(pwd)/main.py" > $mypath/.bin/$pck
    chmod +x $mypath/.bin/$pck
    if [ $? -eq 0 ]; then echo -e "Installed ${YLL}$pck${NC}";echo "Installed $pck">>$mypath/install.tmp; else echo "Not Installed $pck">>$mypath/not-install.tmp; fi
    echo
    cd ..
else
    echo -e "${BLU}$pck${NC} already installed. Skipping..."
fi


### shuffledns
# https://github.com/projectdiscovery/shuffledns
pck="shuffledns";
echo "[+] $pck"
if [ -z  "$(which $pck)" ]; then
    go install -v github.com/projectdiscovery/shuffledns/cmd/shuffledns@latest
    if [ $? -eq 0 ]; then echo -e "Installed ${YLL}$pck${NC}";echo "Installed $pck">>$mypath/install.tmp; else echo "Not Installed $pck">>$mypath/not-install.tmp; fi
    echo
else
    echo -e "${BLU}$pck${NC} already installed. Skipping..."
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
echo "[+] $pck"
if [ -z  "$(which $pck)" ]; then
    go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
    if [ $? -eq 0 ]; then echo -e "Installed ${YLL}$pck${NC}";echo "Installed $pck">>$mypath/install.tmp; else echo "Not Installed $pck">>$mypath/not-install.tmp; fi
    echo
else
    echo -e "${BLU}$pck${NC} already installed. Skipping..."
fi


### Sublist3r
# https://github.com/aboul3la/Sublist3r
pck="sublist3r";
echo "[+] $pck"
if [ -z  "$(which $pck)" ]; then
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
    if [ $? -eq 0 ]; then echo -e "Installed ${YLL}$pck${NC}";echo "Installed $pck">>$mypath/install.tmp; else echo "Not Installed $pck">>$mypath/not-install.tmp; fi
    echo
    cd ..
else
    echo -e "${BLU}$pck${NC} already installed. Skipping..."
fi

cd ..
## Web-Technology-Enumeration
mkdir -p "Web-Technology-Enumeration"
cd "Web-Technology-Enumeration"

### webanalyze
# https://github.com/rverton/webanalyze
pck="webanalyze";
echo "[+] $pck" ;
if [ -z  "$(which $pck)" ]; then
    wget -O $pck.tar.gz https://github.com/rverton/webanalyze/releases/download/v0.4.1/webanalyze_Linux_x86_64.tar.gz;
    tar -C . -xzf $pck.tar.gz;
    ln -s $(realpath webanalyze) $mypath/.bin/webanalyze
    if [ $? -eq 0 ]; then echo -e "Installed ${YLL}$pck${NC}";echo "Installed $pck">>$mypath/install.tmp; else echo "Not Installed $pck">>$mypath/not-install.tmp; fi
    echo
else
    echo -e "${BLU}$pck${NC} already installed. Skipping..."
fi



### WhatWeb
# https://github.com/urbanadventurer/WhatWeb
pck="whatweb";
echo "[+] $pck"
if [ -z  "$(which $pck)" ]; then
    sudo apt -y install whatweb
    if [ $? -eq 0 ]; then echo -e "Installed ${YLL}$pck${NC}";echo "Installed $pck">>$mypath/install.tmp; else echo "Not Installed $pck">>$mypath/not-install.tmp; fi
    echo
else
    echo -e "${BLU}$pck${NC} already installed. Skipping..."
fi


cd ..
# Exploitation
mkdir -p "Exploitation"
cd "Exploitation"


## Active-Directory
mkdir -p "Active-Directory"
cd "Active-Directory"




### BloodHound
# https://github.com/BloodHoundAD/BloodHound
pck="BloodHound";
echo "[+] $pck"
if [ -z  "$(which $pck)" ]; then
    wget https://github.com/BloodHoundAD/BloodHound/releases/download/v4.3.1/BloodHound-linux-x64.zip;
    unzip BloodHound-linux-x64.zip;
    cd BloodHound-linux-x64
    ln -s $(realpath BloodHound ) $mypath/.bin/BloodHound 
    if [ $? -eq 0 ]; then echo -e "Installed ${YLL}$pck${NC}";echo "Installed $pck">>$mypath/install.tmp; else echo "Not Installed $pck">>$mypath/not-install.tmp; fi
    echo
    cd ..
else
    echo -e "${BLU}$pck${NC} already installed. Skipping..."
fi



### Empire
# - This package is no longer support
# https://github.com/EmpireProject/Empire
pck="empire";
echo "[+] $pck";
if [ -z  "$(which ${pck}-install.sh)" ]; then
    git clone https://github.com/EmpireProject/Empire.git --depth 1;
    cd Empire;
    # sudo ./setup/install.sh;
    chmod +x setup/install.sh;
     ln -s $(realpath setup/install.sh ) $mypath/.bin/empire-install.sh 
    if [ $? -eq 0 ]; then echo -e "Installed ${YLL}$pck${NC}";echo "Installed $pck">>$mypath/install.tmp; else echo "Not Installed $pck">>$mypath/not-install.tmp; fi
    echo
    cd ..
else
    echo -e "${BLU}$pck${NC} already installed. Skipping..."
fi

### PowerSploit
# https://github.com/PowerShellMafia/PowerSploit
pck="PowerSploit";
echo "[+] $pck"
if [ ! -d  "$(pwd)/$pck" ]; then
    source /etc/os-release;
    wget -q https://packages.microsoft.com/config/debian/$VERSION_ID/packages-microsoft-prod.deb;
    sudo dpkg -i packages-microsoft-prod.deb;
    # - Powershell is not supported on Debian 12 yet
    # sudo apt-get update;
    # sudo apt-get install -y powershell;
    wget https://github.com/PowerShell/PowerShell/releases/download/v7.4.2/powershell_7.4.2-1.deb_amd64.deb
    sudo dpkg -i powershell_7.4.2-1.deb_amd64.deb
    git clone https://github.com/PowerShellMafia/PowerSploit.git --depth 1
    if [ $? -eq 0 ]; then echo -e "Installed ${YLL}$pck${NC}";echo "Installed $pck">>$mypath/install.tmp; else echo "Not Installed $pck">>$mypath/not-install.tmp; fi
    echo
else
    echo -e "${BLU}$pck${NC} already installed. Skipping..."
fi


cd ..
## Linux-Privilege-Escalation
mkdir -p "Linux-Privilege-Escalation"
cd "Linux-Privilege-Escalation"


### LinEnum
# https://github.com/rebootuser/LinEnum
pck="LinEnum";
echo "[+] $pck"
if [ -z  "$(which $pck)" ]; then
    git clone https://github.com/rebootuser/LinEnum.git --depth 1
    cd LinEnum
    ln -s $(realpath LinEnum.sh ) $mypath/.bin/LinEnum 
    if [ $? -eq 0 ]; then echo -e "Installed ${YLL}$pck${NC}";echo "Installed $pck">>$mypath/install.tmp; else echo "Not Installed $pck">>$mypath/not-install.tmp; fi
    echo
    cd ..
else
    echo -e "${BLU}$pck${NC} already installed. Skipping..."
fi


### linPEAS
# https://github.com/peass-ng/PEASS-ng/tree/master/linPEAS
# - This package installed the tool and inmediately run it
pck="linpeas";
echo "[+] $pck"
if [ -z  "$(which $pck)" ]; then
    # curl -L https://github.com/peass-ng/PEASS-ng/releases/latest/download/linpeas.sh | sh
    curl https://github.com/peass-ng/PEASS-ng/releases/latest/download/linpeas.sh >linpeas.sh
    chmod +x linpeas.sh
    ln -s $(realpath linpeas.sh ) $mypath/.bin/linpeas 
    if [ $? -eq 0 ]; then echo -e "Installed ${YLL}$pck${NC}";echo "Installed $pck">>$mypath/install.tmp; else echo "Not Installed $pck">>$mypath/not-install.tmp; fi
    echo
else
    echo -e "${BLU}$pck${NC} already installed. Skipping..."
fi



### linuxprivcheck
# https://github.com/cervoise/linuxprivcheck
pck="linuxprivchecker3";
echo "[+] $pck"
if [ -z  "$(which $pck)" ]; then
    if [ -z  "$(which pyinstaller)" ]; then
        pipx install pyinstaller;
    fi
    git clone https://github.com/cervoise/linuxprivcheck.git;
    cd linuxprivcheck
    # python3 -m PyInstaller --onefile linuxprivchecker3.py;
    pyinstaller --onefile linuxprivchecker3.py;
    ln -s $(realpath dist/linuxprivchecker3 ) $mypath/.bin/linuxprivchecker3
    if [ $? -eq 0 ]; then echo -e "Installed ${YLL}$pck${NC}";echo "Installed $pck">>$mypath/install.tmp; else echo "Not Installed $pck">>$mypath/not-install.tmp; fi
    echo
    cd ..
else
    echo -e "${BLU}$pck${NC} already installed. Skipping..."
fi

### linuxprivchecker
# https://github.com/sleventyeleven/linuxprivchecker
pck="linuxprivchecker";
echo "[+] $pck"
if [ -z  "$(which $pck)" ]; then
    pipx install linuxprivchecker
    if [ $? -eq 0 ]; then echo -e "Installed ${YLL}$pck${NC}";echo "Installed $pck">>$mypath/install.tmp; else echo "Not Installed $pck">>$mypath/not-install.tmp; fi
    echo
else
    echo -e "${BLU}$pck${NC} already installed. Skipping..."
fi


cd ..
## Password-Spraying-Stuffing-Brute-Forcing-Cracking
mkdir -p "Password-Spraying-Stuffing-Brute-Forcing-Cracking"
cd "Password-Spraying-Stuffing-Brute-Forcing-Cracking"



### CredMaster
# https://github.com/knavesec/CredMaster
pck="CredMaster";
echo "[+] $pck"
if [ -z  "$(which $pck)" ]; then
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
    if [ $? -eq 0 ]; then echo -e "Installed ${YLL}$pck${NC}";echo "Installed $pck">>$mypath/install.tmp; else echo "Not Installed $pck">>$mypath/not-install.tmp; fi
    echo
    cd ..
else
    echo -e "${BLU}$pck${NC} already installed. Skipping..."
fi
### hashcat
# https://github.com/hashcat/hashcat
pck="hashcat";
echo "[+] $pck";
if [ -z  "$(which $pck)" ]; then
    wget -O hashcat.7z https://hashcat.net/files/hashcat-6.2.6.7z;
    7z x hashcat.7z;
    ln -s $(realpath hashcat-6.2.6/hashcat.bin ) $mypath/.bin/hashcat
    if [ $? -eq 0 ]; then echo -e "Installed ${YLL}$pck${NC}";echo "Installed $pck">>$mypath/install.tmp; else echo "Not Installed $pck">>$mypath/not-install.tmp; fi
    echo
else
    echo -e "${BLU}$pck${NC} already installed. Skipping..."
fi


### thc-hydra
# https://github.com/vanhauser-thc/thc-hydra
pck="hydra-wizard";
echo "[+] $pck"
if [ -z  "$(which $pck)" ]; then
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
    if [ $? -eq 0 ]; then echo -e "Installed ${YLL}$pck${NC}";echo "Installed $pck">>$mypath/install.tmp; else echo "Not Installed $pck">>$mypath/not-install.tmp; fi
    make clean
    echo
    cd ..
else
    echo -e "${BLU}$pck${NC} already installed. Skipping..."
fi



### john the ripper jumbo
# https://github.com/openwall/john
pck="john";
echo "[+] $pck the ripper jumbo";
if [ -z  "$(which $pck)" ];then
    if [ ! -f  "john/run/john" ]; then
        sudo apt install nss-passwords libkrb5-dev libgmp-dev libbz2-1.0 libbz2-dev;
        git clone https://github.com/openwall/john.git --depth 1;
        cd john/src;
        ./configure && make;
        make install
        cd ..
        # ln -s $(realpath run/john ) $mypath/.bin/john
        # - john has many tools, so it's better add the run path to the system executable PATH
        export PATH="$PATH:$(realpath run/ )"
        echo "export PATH=\"\$PATH:$(realpath run/ )\"" >>$mypath/.bin/hackertoolkit_bash
        source $(realpath run/john.bash_completion)
        source $(realpath run/john.bash_completion) >>$mypath/.bin/hackertoolkit_bash
        if [ $? -eq 0 ]; then echo -e "Installed ${YLL}$pck${NC}";echo "Installed $pck">>$mypath/install.tmp; else echo "Not Installed $pck">>$mypath/not-install.tmp; fi
        echo
        cd ..
    else
        echo -e "${BLU}$pck${NC} already installed. Skipping..."
    fi
else
    echo -e "${BLU}$pck${NC} already installed. Skipping..."
fi

### medusa
# https://github.com/jmk-foofus/medusa
pck="medusa";
echo "[+] $pck"
if [ -z  "$(which $pck)" ]; then
    git clone https://github.com/jmk-foofus/medusa.git --depth 1;
    cd medusa;
    ./configure --prefix=$(pwd) --exec-prefix=$(pwd) && make  && make install ;
    ln -s $(realpath bin/medusa ) $mypath/.bin/medusa
    if [ $? -eq 0 ]; then echo -e "Installed ${YLL}$pck${NC}";echo "Installed $pck">>$mypath/install.tmp; else echo "Not Installed $pck">>$mypath/not-install.tmp; fi
    make clean
    echo
    cd ..
else
    echo -e "${BLU}$pck${NC} already installed. Skipping..."
fi

### WhereToGo
# https://github.com/valeriyshevchenko90/WhereToGo
pck="WhereToGo";
echo "[+] $pck"
if [ ! -d  "$(pwd)/$pck" ]; then
    git clone https://github.com/valeriyshevchenko90/WhereToGo.git --depth 1
    if [ $? -eq 0 ]; then echo -e "Installed ${YLL}$pck${NC}";echo "Installed $pck">>$mypath/install.tmp; else echo "Not Installed $pck">>$mypath/not-install.tmp; fi
    echo
else
    echo -e "${BLU}$pck${NC} already installed. Skipping..."
fi


cd ..
## Payload-Lists
mkdir -p "Payload-Lists"
cd "Payload-Lists"


### PayloadsAllTheThings
# https://github.com/swisskyrepo/PayloadsAllTheThings
pck="PayloadsAllTheThings";
echo "[+] $pck"
if [ ! -d  "$(pwd)/$pck" ]; then
    git clone https://github.com/swisskyrepo/PayloadsAllTheThings.git --depth 1
    if [ $? -eq 0 ]; then echo -e "Installed ${YLL}$pck${NC}";echo "Installed $pck">>$mypath/install.tmp; else echo "Not Installed $pck">>$mypath/not-install.tmp; fi
    echo
else
    echo -e "${BLU}$pck${NC} already installed. Skipping..."
fi


### SecLists
# - This package has been installed by AutoRecon
# https://github.com/danielmiessler/SecLists
pck="SecLists";
echo "[+] $pck"
if [ ! -d  "$(pwd)/SecLists" ]; then
    git clone --depth 1 https://github.com/danielmiessler/SecLists.git --depth 1
    if [ $? -eq 0 ]; then echo -e "Installed ${YLL}$pck${NC}";echo "Installed $pck">>$mypath/install.tmp; else echo "Not Installed $pck">>$mypath/not-install.tmp; fi
    echo
else
    echo -e "${BLU}$pck${NC} already installed. Skipping..."
fi

cd ..
## Windows-Privilege-Escalation
mkdir -p "Windows-Privilege-Escalation"
cd "Windows-Privilege-Escalation"

### wesng
# https://github.com/bitsadmin/wesng
pck="wesng";
echo "[+] $pck"
if [ -z  "$(which $pck)" ]; then
    git clone https://github.com/bitsadmin/wesng --depth 1;
    cd wesng;
    # alias wes.py="python3 $(pwd)/wes.py " ;
    # echo "alias wes.py=\"python3 $(pwd)/wes.py \"" >>$mypath/.bin/hackertoolkit_bash;
    echo  -e "${sh}python3 $(pwd)/wes.py" > $mypath/.bin/$pck
    chmod +x $mypath/.bin/$pck
    if [ $? -eq 0 ]; then echo -e "Installed ${YLL}$pck${NC}";echo "Installed $pck">>$mypath/install.tmp; else echo "Not Installed $pck">>$mypath/not-install.tmp; fi
    echo
    cd ..
else
    echo -e "${BLU}$pck${NC} already installed. Skipping..."
fi


### winPEAS
# https://github.com/peass-ng/PEASS-ng/tree/master/winPEAS
pck="winPEAS";
echo "[+] $pck";
if [ ! -d  "$(pwd)/winPEAS" ]; then
    mkdir -p winPEAS;
    cd winPEAS;
    wget https://github.com/peass-ng/PEASS-ng/releases/download/20240421-825f642d/winPEAS.bat;
    wget https://github.com/peass-ng/PEASS-ng/releases/download/20240421-825f642d/winPEASx64.exe;
    wget https://github.com/peass-ng/PEASS-ng/releases/download/20240421-825f642d/winPEASx64_ofs.exe;
    if [ $? -eq 0 ]; then echo -e "Installed ${YLL}$pck${NC}";echo "Installed $pck">>$mypath/install.tmp; else echo "Not Installed $pck">>$mypath/not-install.tmp; fi
    echo
    cd ..
else
    echo -e "${BLU}$pck${NC} already installed. Skipping..."
fi



cd ..
## SQL-Injection
mkdir -p "SQL-Injection"
cd "SQL-Injection"


### ghauri
# https://github.com/r0oth3x49/ghauri
pck="ghauri";
echo "[+] $pck"
if [ -z  "$(which $pck)" ]; then
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
    if [ $? -eq 0 ]; then echo -e "Installed ${YLL}$pck${NC}";echo "Installed $pck">>$mypath/install.tmp; else echo "Not Installed $pck">>$mypath/not-install.tmp; fi
    echo
    cd ..
else
    echo -e "${BLU}$pck${NC} already installed. Skipping..."
fi


### HBSQLI
# https://github.com/SAPT01/HBSQLI
pck="hbsqli";
echo "[+] $pck";
if [ -z  "$(which $pck)" ]; then
    git clone https://github.com/SAPT01/HBSQLI.git --depth 1;
    cd HBSQLI;
    python3 -m venv venv;
    reqList=$(sed '/^#/d' requirements.txt | tr '\n' ' ');
    venv/bin/pip install $reqList;
    # alias hbsqli="$(pwd)/venv/bin/python3 $(pwd)/hbsqli.py" ;
    # echo "alias hbsqli=\"$(pwd)/venv/bin/python3 $(pwd)/hbsqli.py\"" >>$mypath/.bin/hackertoolkit_bash;
    echo  -e "${sh}$(pwd)/venv/bin/python3 $(pwd)/hbsqli.py" > $mypath/.bin/$pck
    chmod +x $mypath/.bin/$pck
    if [ $? -eq 0 ]; then echo -e "Installed ${YLL}$pck${NC}";echo "Installed $pck">>$mypath/install.tmp; else echo "Not Installed $pck">>$mypath/not-install.tmp; fi
    echo
    cd ..
else
    echo -e "${BLU}$pck${NC} already installed. Skipping..."
fi

### sqlmap
# https://github.com/sqlmapproject/sqlmap
pck="sqlmap";
echo "[+] $pck"
if [ -z  "$(which $pck)" ]; then
    git clone --depth 1 https://github.com/sqlmapproject/sqlmap.git sqlmap-dev 
    cd sqlmap-dev
    # alias sqlmap="python3 $(pwd)/sqlmap.py" ;
    # echo "alias sqlmap=\"python3 $(pwd)/sqlmap.py\"" >>$mypath/.bin/hackertoolkit_bash;
    echo  -e "${sh}python3 $(pwd)/sqlmap.py" > $mypath/.bin/$pck
    chmod +x $mypath/.bin/$pck
    if [ $? -eq 0 ]; then echo -e "Installed ${YLL}$pck${NC}";echo "Installed $pck">>$mypath/install.tmp; else echo "Not Installed $pck">>$mypath/not-install.tmp; fi
    echo
    cd ..
else
    echo -e "${BLU}$pck${NC} already installed. Skipping..."
fi



cd ..
## Vulnerability-Scanners
mkdir -p "Vulnerability-Scanners"
cd "Vulnerability-Scanners"


### jaeles
# https://github.com/jaeles-project/jaeles
pck="jaeles";
echo "[+] $pck"
if [ -z  "$(which $pck)" ]; then
    go install github.com/jaeles-project/jaeles@latest
    if [ $? -eq 0 ]; then echo -e "Installed ${YLL}$pck${NC}";echo "Installed $pck">>$mypath/install.tmp; else echo "Not Installed $pck">>$mypath/not-install.tmp; fi
    echo
else
    echo -e "${BLU}$pck${NC} already installed. Skipping..."
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
echo "[+] $pck";
if [ -z  "$(which $pck)" ]; then
    git clone https://github.com/AggressiveUser/AllForOne.git --depth 1;
    cd AllForOne;
    python3 -m venv venv;
    reqList=$(sed '/^#/d' requirements.txt | tr '\n' ' ');
    venv/bin/pip install $reqList;
    # alias AllForOne="$(pwd)/venv/bin/python3 $(pwd)/AllForOne.py" ;
    # echo "alias AllForOne=\"$(pwd)/venv/bin/python3 $(pwd)/AllForOne.py\"" >>$mypath/.bin/hackertoolkit_bash;
    echo  -e "${sh}$(pwd)/venv/bin/python3 $(pwd)/AllForOne.py" > $mypath/.bin/$pck
    chmod +x $mypath/.bin/$pck
    if [ $? -eq 0 ]; then echo -e "Installed ${YLL}$pck${NC}";echo "Installed $pck">>$mypath/install.tmp; else echo "Not Installed $pck">>$mypath/not-install.tmp; fi
    echo
    cd ..
else
    echo -e "${BLU}$pck${NC} already installed. Skipping..."
fi



### cent
# https://github.com/xm1k3/cent
pck="cent";
echo "[+] $pck"
if [ -z  "$(which $pck)" ]; then
    go install -v github.com/xm1k3/cent@latest
    if [ $? -eq 0 ]; then echo -e "Installed ${YLL}$pck${NC}";echo "Installed $pck">>$mypath/install.tmp; else echo "Not Installed $pck">>$mypath/not-install.tmp; fi
    echo
else
    echo -e "${BLU}$pck${NC} already installed. Skipping..."
fi


### retire.js
# https://github.com/retirejs/retire.js/
pck="retire";
echo "[+] ${pck}.js"
if [ -z  "$(which $pck)" ]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash;
    nvm install 16 2>/dev/null;
    npm install -g retire;
    if [ $? -eq 0 ]; then echo -e "Installed ${YLL}$pck${NC}";echo "Installed $pck">>$mypath/install.tmp; else echo "Not Installed $pck">>$mypath/not-install.tmp; fi
    echo
else
    echo -e "${BLU}$pck${NC} already installed. Skipping..."
fi


cd ..
cd ..
# Red-Teaming
mkdir -p "Red-Teaming"
cd "Red-Teaming"

## C2
mkdir -p "C2"
cd "C2"


### NimPlant
# https://github.com/chvancooten/NimPlant
pck="NimPlant";
echo "[+] $pck"
if [ -z  "$(which $pck)" ]; then
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
    if [ $? -eq 0 ]; then echo -e "Installed ${YLL}$pck${NC}";echo "Installed $pck">>$mypath/install.tmp; else echo "Not Installed $pck">>$mypath/not-install.tmp; fi
    echo
    cd ..
    cd ..
else
    echo -e "${BLU}$pck${NC} already installed. Skipping..."
fi

### SharpC2
# https://github.com/rasta-mouse/SharpC2
pck="SharpC2";
echo "[+] $pck"
if [ ! -d  "$(pwd)/SharpC2" ]; then
    git clone https://github.com/rasta-mouse/SharpC2.git --depth 1
    if [ $? -eq 0 ]; then echo -e "Installed ${YLL}$pck${NC}";echo "Installed $pck">>$mypath/install.tmp; else echo "Not Installed $pck">>$mypath/not-install.tmp; fi
    echo
else
    echo -e "${BLU}$pck${NC} already installed. Skipping..."
fi

cd ..
## Distribution
mkdir -p "Distribution"
cd "Distribution"


### axiom
# - This package will install a lot of things
# - and it needs user or token or password from
# - (aws, azure, do, ibm, linode)
# https://github.com/pry0cc/axiom
pck="axiom";
echo "[+] $pck"
if [ -z  "$(which ${pck}-install.sh)" ]; then
    sudo apt install packer fzf;
    sudo snap install doctl;
    # bash <(curl -s https://raw.githubusercontent.com/pry0cc/axiom/master/interact/axiom-configure);
    wget -O axiom-install.sh https://raw.githubusercontent.com/pry0cc/axiom/master/interact/axiom-configure;
    chmod +x axiom-install.sh
    ln -s $(pwd)/axiom-install.sh $mypath/.bin/axiom-install.sh
    if [ $? -eq 0 ]; then echo -e "Installed ${YLL}$pck${NC}";echo "Installed $pck">>$mypath/install.tmp; else echo "Not Installed $pck">>$mypath/not-install.tmp; fi
    echo
else
    echo -e "${BLU}$pck${NC} already installed. Skipping..."
fi


### fleex
# https://github.com/FleexSecurity/fleex
pck="fleex";
echo "[+] $pck"
if [ -z  "$(which $pck)" ]; then
    go install -v github.com/FleexSecurity/fleex@latest
    if [ $? -eq 0 ]; then echo -e "Installed ${YLL}$pck${NC}";echo "Installed $pck">>$mypath/install.tmp; else echo "Not Installed $pck">>$mypath/not-install.tmp; fi
    echo
else
    echo -e "${BLU}$pck${NC} already installed. Skipping..."
fi


### ShadowClone
# https://github.com/fyoorer/ShadowClone
# -It needs Docker
pck="ShadowClone";
echo "[+] $pck";
if [ -z  "$(which $pck)" ]; then
    git clone https://github.com/fyoorer/ShadowClone.git --depth 1;
    cd ShadowClone;
    python3 -m venv venv;
    reqList=$(sed '/^#/d' requirements.txt | tr '\n' ' ');
    venv/bin/pip install $reqList;
    # alias ShadowClone="$(pwd)/venv/bin/python3 $(pwd)/ShadowClone.py" ;
    # echo "alias ShadowClone=\"$(pwd)/venv/bin/python3 $(pwd)/ShadowClone.py\"" >>$mypath/.bin/hackertoolkit_bash;
    echo  -e "${sh}$(pwd)/venv/bin/python3 $(pwd)/ShadowClone.py" > $mypath/.bin/$pck
    chmod +x $mypath/.bin/$pck
    if [ $? -eq 0 ]; then echo -e "Installed ${YLL}$pck${NC}";echo "Installed $pck">>$mypath/install.tmp; else echo "Not Installed $pck">>$mypath/not-install.tmp; fi
    echo
    cd ..
else
    echo -e "${BLU}$pck${NC} already installed. Skipping..."
fi


cd ..
## Phishing-Smishing-Etc
mkdir -p "Phishing-Smishing-Etc"
cd "Phishing-Smishing-Etc"



### evilginx2
# https://github.com/kgretzky/evilginx2
pck="evilginx";
echo "[+] $pck";
if [ -z  "$(which $pck)" ]; then
    wget https://github.com/kgretzky/evilginx2/releases/download/v3.3.0/evilginx-v3.3.0-linux-64bit.zip;
    unzip evilginx-v3.3.0-linux-64bit.zip;
    chmod +x evilginx
    ln -s $(realpath evilginx ) $mypath/.bin/evilginx
    if [ $? -eq 0 ]; then echo -e "Installed ${YLL}$pck${NC}";echo "Installed $pck">>$mypath/install.tmp; else echo "Not Installed $pck">>$mypath/not-install.tmp; fi
    echo
else
    echo -e "${BLU}$pck${NC} already installed. Skipping..."
fi

### gophish
# https://github.com/gophish/gophish
pck="gophish";
echo "[+] $pck";
if [ -z  "$(which $pck)" ]; then
    wget https://github.com/gophish/gophish/releases/download/v0.12.1/gophish-v0.12.1-linux-64bit.zip;
    unzip gophish-v0.12.1-linux-64bit;
    chmod +x gophish;
    ln -s $(realpath gophish ) $mypath/.bin/gophish
    if [ $? -eq 0 ]; then echo -e "Installed ${YLL}$pck${NC}";echo "Installed $pck">>$mypath/install.tmp; else echo "Not Installed $pck">>$mypath/not-install.tmp; fi
    echo
else
    echo -e "${BLU}$pck${NC} already installed. Skipping..."
fi



cd ..
## Stealth
mkdir -p "Stealth"
cd "Stealth"

### evilgophish
# https://github.com/fin3ss3g0d/evilgophish
pck="evilgophish";
echo "[+] $pck"
if [ -z  "$(which $pck)" ]; then
    git clone https://github.com/fin3ss3g0d/evilgophish.git --depth 1;
    cd evilgophish/
    chmod +x setup.sh;
    ln -s $(realpath setup.sh ) $mypath/.bin/evilgophish
    if [ $? -eq 0 ]; then echo -e "Installed ${YLL}$pck${NC}";echo "Installed $pck">>$mypath/install.tmp; else echo "Not Installed $pck">>$mypath/not-install.tmp; fi
    echo
    cd ..
else
    echo -e "${BLU}$pck${NC} already installed. Skipping..."
fi

### fireprox
# https://github.com/ustayready/fireprox
pck="fire";
echo "[+] ${pck}prox"
if [ -z  "$(which $pck)" ]; then
    git clone https://github.com/ustayready/fireprox --depth 1
    cd fireprox
    python3 -m venv venv;
    reqList=$(sed '/^#/d' requirements.txt | tr '\n' ' ');
    venv/bin/pip install $reqList;
    # alias fire="$(pwd)/venv/bin/python3 $(pwd)/fire.py" ;
    # echo "alias fire=\"$(pwd)/venv/bin/python3 $(pwd)/fire.py\"" >>$mypath/.bin/hackertoolkit_bash;
    echo  -e "${sh}$(pwd)/venv/bin/python3 $(pwd)/fire.py" > $mypath/.bin/$pck
    chmod +x $mypath/.bin/$pck
    if [ $? -eq 0 ]; then echo -e "Installed ${YLL}$pck${NC}";echo "Installed $pck">>$mypath/install.tmp; else echo "Not Installed $pck">>$mypath/not-install.tmp; fi
    echo
    cd ..
else
    echo -e "${BLU}$pck${NC} already installed. Skipping..."
fi


### mubeng
# https://github.com/kitabisa/mubeng
pck="mubeng";
echo "[+] $pck"
if [ -z  "$(which $pck)" ]; then
    wget -O mubeng https://github.com/kitabisa/mubeng/releases/download/v0.14.2/mubeng_0.14.2_linux_amd64
    chmod +x mubeng
    ln -s $(realpath smubeng ) $mypath/.bin/mubeng
    if [ $? -eq 0 ]; then echo -e "Installed ${YLL}$pck${NC}";echo "Installed $pck">>$mypath/install.tmp; else echo "Not Installed $pck">>$mypath/not-install.tmp; fi
    echo
else
    echo -e "${BLU}$pck${NC} already installed. Skipping..."
fi


### proxycannon-ng
# https://github.com/proxycannon/proxycannon-ng
# - This package modify the behavior of networking of this machine
# - using iptables, ip rules and  sysctl commands, so if you have
# network issues you have to restart your machine
pck="proxycannon-ng";
echo "[+] $pck"
if [ ! -d  "$(pwd)/proxycannon-ng" ]; then
    sudo apt install openvpn easy-rsa iptables
    git clone https://github.com/proxycannon/proxycannon-ng.git --depth 1;
    cd proxycannon-ng/setup
    # sudo bash install.sh
    if [ $? -eq 0 ]; then echo -e "Installed ${YLL}$pck${NC}";echo "Installed $pck">>$mypath/install.tmp; else echo "Not Installed $pck">>$mypath/not-install.tmp; fi
    echo
    cd ..
else
    echo -e "${BLU}$pck${NC} already installed. Skipping..."
fi

source $mypath/.bin/hackertoolkit_bash
echo "source $mypath/.bin/hackertoolkit_bash" >>$HOME/.bashrc

echo -e "${YLL}Done.${NC}"
# END
