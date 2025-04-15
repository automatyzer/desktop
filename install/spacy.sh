#!/bin/bash

# Comprehensive SpaCy Installation Script for Linux Distributions
# Supports: Ubuntu/Debian, Fedora, CentOS/RHEL, Arch Linux, OpenSUSE
# Updated to handle Python version compatibility and build errors

# Exit on any error
set -e

# Logging
INSTALL_LOG="/tmp/spacy_install_$(date +%Y%m%d_%H%M%S).log"

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default spaCy version - empty means latest
SPACY_VERSION=""

# Default language models to install
MODELS=("en_core_web_sm")

# Error handling function
handle_error() {
    echo -e "${RED}Error occurred during installation. Check log at $INSTALL_LOG for details.${NC}"
    exit 1
}

# Trap any errors and call error handling function
trap handle_error ERR

# Print usage information
usage() {
    echo -e "${BLUE}Usage: $0 [options]${NC}"
    echo -e "Options:"
    echo -e "  -h, --help              Show this help message"
    echo -e "  -v, --version VERSION   Install specific spaCy version (e.g., 3.6.1)"
    echo -e "  -m, --models \"MODEL1 MODEL2...\"  Space-separated list of models to install (default: en_core_web_sm)"
    echo -e "  -p, --python PATH       Path to Python executable (default: auto-detect)"
    echo -e "  --force-cython          Force Cython pre-installation (for older distros)"
    echo -e "  --no-verify             Skip verification step"
    exit 0
}

# Parse command line arguments
parse_args() {
    PYTHON_CMD="python3"
    FORCE_CYTHON=0
    SKIP_VERIFY=0

    while [[ $# -gt 0 ]]; do
        case "$1" in
            -h|--help)
                usage
                ;;
            -v|--version)
                SPACY_VERSION="$2"
                shift 2
                ;;
            -m|--models)
                # Convert space-separated string to array
                IFS=' ' read -r -a MODELS <<< "$2"
                shift 2
                ;;
            -p|--python)
                PYTHON_CMD="$2"
                shift 2
                ;;
            --force-cython)
                FORCE_CYTHON=1
                shift
                ;;
            --no-verify)
                SKIP_VERIFY=1
                shift
                ;;
            *)
                echo -e "${RED}Unknown option: $1${NC}"
                usage
                ;;
        esac
    done
}

# Check if running as root/sudo
check_permissions() {
    if [ "$EUID" -ne 0 ]; then
        echo -e "${YELLOW}Warning: Running without sudo or root permissions.${NC}"
        echo -e "${YELLOW}This may work for user-local installation but might fail for system dependencies.${NC}"
        read -p "Continue anyway? (y/n) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo -e "${RED}Installation cancelled.${NC}"
            exit 1
        fi
    fi
}

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

# Check Python version compatibility
check_python_version() {
    echo -e "${YELLOW}Checking Python version...${NC}"

    # Get Python version
    local python_version=$($PYTHON_CMD -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')")
    local python_full_version=$($PYTHON_CMD -c "import sys; print(sys.version.split()[0])")

    echo -e "Detected Python version: ${BLUE}$python_full_version${NC}"

    # Convert version to integers for comparison
    local major_version=$(echo $python_version | cut -d. -f1)
    local minor_version=$(echo $python_version | cut -d. -f2)

    # spaCy version compatibility check
    local install_message=""

    if [[ $major_version -eq 3 && $minor_version -ge 13 ]]; then
        echo -e "${YELLOW}Python 3.13+ detected. spaCy may have compatibility issues.${NC}"
        if [[ -z "$SPACY_VERSION" ]]; then
            echo -e "${YELLOW}For Python 3.13+, recommending latest version with --no-binary option.${NC}"
            SPACY_INSTALL_CMD="$PYTHON_CMD -m pip install --no-binary spacy spacy"
        else
            SPACY_INSTALL_CMD="$PYTHON_CMD -m pip install --no-binary spacy spacy==$SPACY_VERSION"
        fi
    elif [[ $major_version -eq 3 && $minor_version -ge 7 && $minor_version -le 12 ]]; then
        echo -e "${GREEN}Python version is compatible with modern spaCy.${NC}"
        if [[ -z "$SPACY_VERSION" ]]; then
            SPACY_INSTALL_CMD="$PYTHON_CMD -m pip install spacy"
        else
            SPACY_INSTALL_CMD="$PYTHON_CMD -m pip install spacy==$SPACY_VERSION"
        fi
    elif [[ $major_version -eq 3 && $minor_version -lt 7 ]]; then
        echo -e "${YELLOW}Python 3.6 or lower detected. Using spaCy 3.0.x series.${NC}"
        if [[ -z "$SPACY_VERSION" ]]; then
            SPACY_INSTALL_CMD="$PYTHON_CMD -m pip install 'spacy<3.1.0'"
        else
            SPACY_INSTALL_CMD="$PYTHON_CMD -m pip install spacy==$SPACY_VERSION"
        fi
    else
        echo -e "${RED}Unsupported Python version. spaCy requires Python 3.6+${NC}"
        exit 1
    fi

    echo -e "Will use install command: ${BLUE}$SPACY_INSTALL_CMD${NC}"

    # Return the installation command
    echo "$SPACY_INSTALL_CMD"
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
                libpython3-dev \
                pkg-config
            ;;
        fedora)
            dnf install -y @development-tools || dnf5 install -y @development-tools
            dnf install -y \
                python3-pip \
                python3-devel \
                gcc-c++ \
                cmake \
                python3-numpy \
                python3-setuptools \
                pkg-config \
                || dnf5 install -y \
                python3-pip \
                python3-devel \
                gcc-c++ \
                cmake \
                python3-numpy \
                python3-setuptools \
                pkg-config
            ;;
        centos|rhel)
            yum groupinstall -y "Development Tools"
            yum install -y \
                python3-pip \
                python3-devel \
                gcc-c++ \
                cmake \
                pkgconfig
            ;;
        arch)
            pacman -Syu --noconfirm
            pacman -S --noconfirm \
                python-pip \
                base-devel \
                cmake \
                pkgconf
            ;;
        opensuse*)
            zypper refresh
            zypper install -y \
                python3-pip \
                python3-devel \
                gcc-c++ \
                cmake \
                pkg-config
            ;;
        *)
            echo -e "${YELLOW}Unsupported distribution: $distro${NC}"
            echo -e "${YELLOW}Installing minimum requirements with pip...${NC}"
            $PYTHON_CMD -m pip install --upgrade pip setuptools wheel
            ;;
    esac
}

# Upgrade pip and setuptools
upgrade_pip() {
    echo -e "${YELLOW}Upgrading pip and setuptools...${NC}"
    $PYTHON_CMD -m pip install --upgrade pip setuptools wheel

    # Install Cython if forced
    if [[ $FORCE_CYTHON -eq 1 ]]; then
        echo -e "${YELLOW}Installing/upgrading Cython (pre-requirement for spaCy)...${NC}"
        $PYTHON_CMD -m pip install --upgrade cython
    fi
}

# Install SpaCy with language models
install_spacy() {
    local install_cmd=$1
    echo -e "${YELLOW}Installing spaCy...${NC}"

    # Try with regular installation first
    if $install_cmd; then
        echo -e "${GREEN}spaCy installed successfully!${NC}"
    else
        echo -e "${YELLOW}Regular installation failed, trying with --no-binary option...${NC}"

        # If regular installation fails, try with --no-binary
        if [[ "$install_cmd" != *"--no-binary"* ]]; then
            if [[ -z "$SPACY_VERSION" ]]; then
                $PYTHON_CMD -m pip install --no-binary spacy spacy
            else
                $PYTHON_CMD -m pip install --no-binary spacy spacy==$SPACY_VERSION
            fi
        else
            echo -e "${RED}Installation failed even with --no-binary option.${NC}"
            return 1
        fi
    fi

    # Install language models
    echo -e "${YELLOW}Installing language models: ${MODELS[*]}${NC}"
    for model in "${MODELS[@]}"; do
        echo -e "${YELLOW}Installing $model...${NC}"
        if ! $PYTHON_CMD -m spacy download $model; then
            echo -e "${YELLOW}Direct download failed, trying pip installation for $model...${NC}"
            $PYTHON_CMD -m pip install https://github.com/explosion/spacy-models/releases/download/${model/-/}/${model/-/_}-py3-none-any.whl
        fi
    done
}

# Verify SpaCy installation
verify_installation() {
    if [[ $SKIP_VERIFY -eq 1 ]]; then
        echo -e "${YELLOW}Skipping verification as requested.${NC}"
        return 0
    fi

    echo -e "${YELLOW}Verifying SpaCy installation...${NC}"
    if $PYTHON_CMD -c "import spacy; print(f'SpaCy version: {spacy.__version__}')"; then
        echo -e "${GREEN}SpaCy verified successfully!${NC}"

        # Test with a simple example
        echo -e "${YELLOW}Testing with a simple example...${NC}"
        $PYTHON_CMD -c "
import spacy
print('Loading model...')
nlp = spacy.load('${MODELS[0]}')
print('Processing text...')
doc = nlp('This is a test sentence for SpaCy. It was installed successfully!')
print('Tokens:', [token.text for token in doc])
print('SpaCy is working correctly!')
"
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}SpaCy is working correctly!${NC}"
        else
            echo -e "${RED}SpaCy test example failed.${NC}"
            return 1
        fi
    else
        echo -e "${RED}SpaCy verification failed.${NC}"
        return 1
    fi
}

# Main installation process
main() {
    parse_args "$@"
    check_permissions

    local distro=$(detect_distro)

    echo -e "${GREEN}SpaCy Installation Script${NC}"
    echo -e "${GREEN}=========================${NC}"
    echo -e "${GREEN}Detected Linux Distribution: ${distro}${NC}" | tee -a "$INSTALL_LOG"

    {
        echo "SpaCy Installation Log Started: $(date)"
        echo "Distribution: $distro"
        echo "Python command: $PYTHON_CMD"
        echo "SpaCy version: ${SPACY_VERSION:-latest}"
        echo "Models to install: ${MODELS[*]}"
        echo "------------------------------"
    } >> "$INSTALL_LOG"

    # Log each step
    echo -e "${YELLOW}Installing system dependencies...${NC}"
    install_dependencies "$distro" 2>&1 | tee -a "$INSTALL_LOG"

    echo -e "${YELLOW}Upgrading pip...${NC}"
    upgrade_pip 2>&1 | tee -a "$INSTALL_LOG"

    # Check Python version and get install command
    local spacy_install_cmd=$(check_python_version 2>&1 | tee -a "$INSTALL_LOG")

    # Extract the actual command from output
    spacy_install_cmd=$(echo "$spacy_install_cmd" | grep "pip install" | tail -n 1)

    echo -e "${YELLOW}Installing SpaCy...${NC}"
    install_spacy "$spacy_install_cmd" 2>&1 | tee -a "$INSTALL_LOG"

    echo -e "${YELLOW}Verifying installation...${NC}"
    verify_installation 2>&1 | tee -a "$INSTALL_LOG"

    {
        echo "------------------------------"
        echo "SpaCy Installation Completed Successfully: $(date)"
    } >> "$INSTALL_LOG"

    echo -e "${GREEN}SpaCy installation completed successfully!${NC}"
    echo -e "${GREEN}Detailed log available at: $INSTALL_LOG${NC}"
}

# Execute main function with all arguments
main "$@"

exit 0