#!/bin/bash

# Comprehensive SpaCy Installation Script for Linux Distributions
# Supports: Ubuntu/Debian, Fedora, CentOS/RHEL, Arch Linux, OpenSUSE

set -e

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check for root/sudo permissions
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}Please run with sudo or as root${NC}"
    exit 1
fi

# Detect Linux distribution
detect_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        echo "$ID"
    elif command -v lsb_release &> /dev/null; then
        lsb_release -i | cut -d: -f2 | sed s/'^\t'//
    else
        echo "unknown"
    fi
}

# Install dependencies based on distribution
install_dependencies() {
    local distro=$1

    echo -e "${YELLOW}Installing system dependencies...${NC}"

    case "$distro" in
        ubuntu|debian)
            apt-get update
            apt-get install -y \
                python3-pip \
                python3-dev \
                build-essential \
                gcc \
                g++ \
                cmake \
                libpython3-dev
            ;;
        fedora)
            dnf groupinstall -y "Development Tools"
            dnf install -y \
                python3-pip \
                python3-devel \
                gcc-c++ \
                cmake
            ;;
        centos|rhel)
            yum groupinstall -y "Development Tools"
            yum install -y \
                python3-pip \
                python3-devel \
                gcc-c++ \
                cmake
            ;;
        arch)
            pacman -Syu --noconfirm
            pacman -S --noconfirm \
                python-pip \
                base-devel \
                cmake
            ;;
        opensuse*)
            zypper refresh
            zypper install -y \
                python3-pip \
                python3-devel \
                gcc-c++ \
                cmake
            ;;
        *)
            echo -e "${RED}Unsupported distribution${NC}"
            exit 1
            ;;
    esac
}

# Upgrade pip and setuptools
upgrade_pip() {
    echo -e "${YELLOW}Upgrading pip and setuptools...${NC}"
    python3 -m pip install --upgrade pip setuptools wheel
}

# Install SpaCy with language models
install_spacy() {
    echo -e "${YELLOW}Installing SpaCy and language models...${NC}"

    # Install SpaCy
    python3 -m pip install spacy

    # Download language models
    python3 -m spacy download en_core_web_sm
    python3 -m spacy download en_core_web_md
}

# Verify SpaCy installation
verify_installation() {
    echo -e "${YELLOW}Verifying SpaCy installation...${NC}"
    python3 -c "import spacy; print(f'SpaCy version: {spacy.__version__}')"
}

# Main installation process
main() {
    local distro=$(detect_distro)

    echo -e "${GREEN}Detected Linux Distribution: ${distro}${NC}"

    install_dependencies "$distro"
    upgrade_pip
    install_spacy
    verify_installation

    echo -e "${GREEN}SpaCy installation completed successfully!${NC}"
}

# Execute main function
main

exit 0