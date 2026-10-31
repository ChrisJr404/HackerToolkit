# syntax=docker/dockerfile:1
# =============================================================================
# HackerToolkit — reproducible container build
# -----------------------------------------------------------------------------
# UNTESTED IN THIS ENVIRONMENT: no Docker daemon / disk was available where this
# file was authored, so it is "correct-by-inspection". Build it yourself with
# `make docker-build` (or `docker build -t hackertoolkit:latest .`) and expect
# the first build to take a while — install.sh compiles a local Go toolchain
# and ~80 OSS tools from source.
#
# Base image: kalilinux/kali-rolling.
#   Chosen because install.sh is written for a Debian/Kali-like apt environment
#   AND several blocks apt-install packages that only live in Kali's repo (e.g.
#   AutoRecon's deps: dnsrecon, nbtscan, sipvicious, whatweb, smbmap, onesixtyone).
#   debian:stable-slim is a smaller/faster fallback, but on plain Debian many of
#   those apt packages do not resolve, so you would see far more per-tool
#   failures unless you first add the Kali package repository. Use Kali unless
#   you have a specific reason not to.
# =============================================================================
FROM kalilinux/kali-rolling

# Keep every apt invocation (ours AND the ones install.sh runs via sudo)
# non-interactive so the build never blocks on a tzdata/debconf prompt.
# Intentionally persisted as ENV (not an ARG) precisely because install.sh
# shells out to apt many times after this point.
ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8

# -----------------------------------------------------------------------------
# Layer 1 — OS prerequisites (cache-friendly: nothing below the COPY lives here,
# so editing the repo does NOT bust this layer).
#
# install.sh can apt-install most of these itself via its `exist` helper, but
# pre-installing them keeps the big install layer deterministic and avoids
# repeated mid-build apt churn. build-essential covers gcc/make/libc headers,
# which the local Go toolchain (CGO_ENABLED=1) and cargo builds require.
# `sudo` is installed because install.sh calls `sudo apt/snap/make install`
# throughout; as root in the container sudo is a transparent pass-through
# (default secure_path already includes /usr/local/bin for the snap shim below).
# -----------------------------------------------------------------------------
# hadolint ignore=DL3008,DL3015
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        sudo \
        git \
        curl \
        wget \
        jq \
        unzip \
        p7zip-full \
        rsync \
        perl \
        coreutils \
        build-essential \
        pkg-config \
        libssl-dev \
        python3 \
        python3-pip \
        python3-venv \
        pipx \
        cargo \
        lolcat && \
    rm -rf /var/lib/apt/lists/*

# -----------------------------------------------------------------------------
# snap does NOT work inside Docker (no snapd/systemd). install.sh runs a few
# `snap install` calls — enum4linux + seclists (inside the AutoRecon block,
# category Port-Scanners-Active) and doctl (category Distribution, skipped by
# our default build). Rather than let `exist snap snapd` pull the unusable
# snapd package in and then watch each `snap install` error against a dead
# socket, we drop a shim on PATH. `command -v snap` then succeeds (so snapd is
# never installed) and every `snap install` becomes a clear, harmless no-op.
# install.sh does not use `set -e` and tracks tool status individually, so the
# skipped snap tools are simply recorded and the build continues.
#   -> enum4linux / seclists will be ABSENT in the image; install them another
#      way if you need them (e.g. `apt-get install -y seclists` on Kali, and
#      enum4linux via its git repo).
# -----------------------------------------------------------------------------
RUN printf '#!/bin/sh\necho "[snap-shim] snap is unavailable in containers; skipping: snap $*" >&2\nexit 0\n' \
        > /usr/local/bin/snap && \
    chmod +x /usr/local/bin/snap

# -----------------------------------------------------------------------------
# Layer 2 — the repo + the install run.
# Copy only the two files install.sh actually needs at build time (the script
# itself and its tool manifest). Docs/.git are excluded via .dockerignore and
# are not referenced during install, so this stays cache-friendly.
# -----------------------------------------------------------------------------
WORKDIR /opt/hackertoolkit
COPY install.sh tools.tsv ./

# Go toolchain + Go-installed tools + pipx + cargo all land under $HOME (/root).
# Export them so the post-install `./install.sh doctor` (and the user's shell)
# resolve every shim. install.sh also writes these into a hackertoolkit_bash
# file and sources it from ~/.bashrc, but ENV is what a non-interactive
# `docker run ... <cmd>` needs.
ENV GOPATH=/root/go
ENV PATH="/opt/hackertoolkit/HackerToolkit/.bin:/opt/hackertoolkit/HackerToolkit/.bin/go/bin:/root/go/bin:/root/.cargo/bin:/root/.local/bin:${PATH}"

# Sensible default install: everything EXCEPT the categories most likely to be
# unwanted / unusable in a shared container image (offensive C2, phishing/
# smishing, stealth, and cloud-distribution tooling). --yes accepts the
# authorized-use terms and runs non-interactively.
#
# To install EVERYTHING instead, override the skip set at build time, e.g.:
#   docker build --build-arg INSTALL_ARGS="--yes" -t hackertoolkit:all .
# Or narrow it further, e.g.:
#   docker build --build-arg INSTALL_ARGS="--yes --only-cat=Vulnerability-Scanners" .
ARG INSTALL_ARGS="--yes --skip-cat=C2,Phishing-Smishing-Etc,Stealth,Distribution"
# shellcheck disable=SC2086  # INSTALL_ARGS is intentionally word-split
RUN ./install.sh ${INSTALL_ARGS}

# -----------------------------------------------------------------------------
# Non-root user option (commented — the build itself must run as root because
# install.sh uses sudo/apt). To ship a non-root runtime image, uncomment and
# note that GOPATH/pipx/.cargo paths move to the new user's HOME, so the ENV
# PATH above (and install.sh's own paths) would need to be rebuilt as that user:
#
#   RUN useradd --create-home --shell /bin/bash toolkit && \
#       chown -R toolkit:toolkit /opt/hackertoolkit
#   USER toolkit
#   WORKDIR /home/toolkit
#   # (re-run install.sh as `toolkit` so Go/pipx/cargo land in /home/toolkit)
# -----------------------------------------------------------------------------

CMD ["/bin/bash"]
