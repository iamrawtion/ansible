#!/bin/bash

# Ansible Training - Prerequisites Installation Script
# This script automatically installs Ansible and required dependencies
# Usage: ./install-prerequisites.sh [-y|--yes|--non-interactive]

set -e  # Exit on error

# Color codes
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check for non-interactive mode
NON_INTERACTIVE=0
if [[ "$1" == "-y" ]] || [[ "$1" == "--yes" ]] || [[ "$1" == "--non-interactive" ]] || [[ "$ANSIBLE_TRAINING_NONINTERACTIVE" == "1" ]] || [[ ! -t 0 ]]; then
    NON_INTERACTIVE=1
fi

echo "========================================="
echo "Ansible Training - Prerequisites Setup"
echo "========================================="
echo ""

if [ $NON_INTERACTIVE -eq 1 ]; then
    echo -e "${YELLOW}Running in non-interactive mode${NC}"
    echo ""
fi

# Detect OS
detect_os() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS=$ID
        VERSION=$VERSION_ID
    elif type lsb_release >/dev/null 2>&1; then
        OS=$(lsb_release -si | tr '[:upper:]' '[:lower:]')
        VERSION=$(lsb_release -sr)
    elif [ -f /etc/lsb-release ]; then
        . /etc/lsb-release
        OS=$(echo $DISTRIB_ID | tr '[:upper:]' '[:lower:]')
        VERSION=$DISTRIB_RELEASE
    else
        OS=$(uname -s)
        VERSION=$(uname -r)
    fi

    echo -e "${BLUE}Detected OS: $OS $VERSION${NC}"
}

# Check if running as root and sudo availability
check_root() {
    if [ "$EUID" -eq 0 ]; then
        SUDO=""
        echo -e "${YELLOW}Running as root${NC}"
    elif command -v sudo &> /dev/null; then
        SUDO="sudo"
        echo -e "${YELLOW}Will use sudo for system operations${NC}"
    else
        SUDO=""
        echo -e "${YELLOW}Warning: sudo not found, attempting without sudo${NC}"
        echo -e "${YELLOW}If you get permission errors, install sudo or run as root${NC}"
    fi
}

# Update package manager
update_package_manager() {
    echo ""
    echo -e "${BLUE}Updating package manager...${NC}"

    case $OS in
        ubuntu|debian)
            $SUDO apt-get update -qq
            ;;
        centos|rhel|fedora)
            $SUDO yum check-update -q || true
            ;;
        alpine)
            $SUDO apk update -q
            ;;
        *)
            echo -e "${YELLOW}Unknown OS, skipping package manager update${NC}"
            ;;
    esac
}

# Install Python3
install_python() {
    echo ""
    echo -n "Checking Python3... "

    if command -v python3 &> /dev/null; then
        echo -e "${GREEN}✓ Already installed${NC}"
        PYTHON_VERSION=$(python3 --version)
        echo "  $PYTHON_VERSION"
        return 0
    fi

    echo -e "${YELLOW}Not found, installing...${NC}"

    case $OS in
        ubuntu|debian)
            $SUDO apt-get install -y python3 python3-pip 2>/dev/null || {
                echo -e "${YELLOW}Failed with apt-get, trying without package manager...${NC}"
                echo -e "${RED}Python3 is required but cannot be installed automatically${NC}"
                echo "Please install Python3 manually or run this script as root"
                return 1
            }
            ;;
        centos|rhel)
            $SUDO yum install -y python3 python3-pip 2>/dev/null || {
                echo -e "${RED}Python3 is required but cannot be installed automatically${NC}"
                return 1
            }
            ;;
        fedora)
            $SUDO dnf install -y python3 python3-pip 2>/dev/null || {
                echo -e "${RED}Python3 is required but cannot be installed automatically${NC}"
                return 1
            }
            ;;
        alpine)
            $SUDO apk add --no-cache python3 py3-pip 2>/dev/null || {
                echo -e "${RED}Python3 is required but cannot be installed automatically${NC}"
                return 1
            }
            ;;
        *)
            echo -e "${RED}Unsupported OS for automatic installation${NC}"
            echo "Please install Python3 manually"
            return 1
            ;;
    esac

    if command -v python3 &> /dev/null; then
        echo -e "${GREEN}✓ Python3 installed successfully${NC}"
        return 0
    else
        echo -e "${RED}✗ Failed to install Python3${NC}"
        return 1
    fi
}

# Install pip
install_pip() {
    echo ""
    echo -n "Checking pip... "

    if command -v pip3 &> /dev/null || python3 -m pip --version &> /dev/null; then
        echo -e "${GREEN}✓ Already installed${NC}"
        return 0
    fi

    echo -e "${YELLOW}Not found, installing...${NC}"

    case $OS in
        ubuntu|debian)
            $SUDO apt-get install -y python3-pip
            ;;
        centos|rhel)
            $SUDO yum install -y python3-pip
            ;;
        fedora)
            $SUDO dnf install -y python3-pip
            ;;
        alpine)
            $SUDO apk add --no-cache py3-pip
            ;;
        *)
            # Try to install pip using get-pip.py
            echo "Attempting to install pip using get-pip.py..."
            curl -sS https://bootstrap.pypa.io/get-pip.py | python3
            ;;
    esac

    if command -v pip3 &> /dev/null || python3 -m pip --version &> /dev/null; then
        echo -e "${GREEN}✓ pip installed successfully${NC}"
    else
        echo -e "${RED}✗ Failed to install pip${NC}"
        exit 1
    fi
}

# Install additional system dependencies
install_system_dependencies() {
    echo ""
    echo -e "${BLUE}Installing system dependencies...${NC}"

    case $OS in
        ubuntu|debian)
            $SUDO apt-get install -y \
                software-properties-common \
                build-essential \
                libssl-dev \
                libffi-dev \
                git \
                curl \
                sshpass 2>/dev/null || {
                echo -e "${YELLOW}Some system packages failed to install${NC}"
                echo -e "${YELLOW}Will try to continue with pip-only installation${NC}"
            }
            ;;
        centos|rhel)
            $SUDO yum install -y \
                gcc \
                openssl-devel \
                libffi-devel \
                git \
                curl \
                sshpass 2>/dev/null || {
                echo -e "${YELLOW}Some system packages failed to install${NC}"
            }
            ;;
        fedora)
            $SUDO dnf install -y \
                gcc \
                openssl-devel \
                libffi-devel \
                git \
                curl \
                sshpass 2>/dev/null || {
                echo -e "${YELLOW}Some system packages failed to install${NC}"
            }
            ;;
        alpine)
            $SUDO apk add --no-cache \
                gcc \
                musl-dev \
                libffi-dev \
                openssl-dev \
                git \
                curl \
                sshpass 2>/dev/null || {
                echo -e "${YELLOW}Some system packages failed to install${NC}"
            }
            ;;
        *)
            echo -e "${YELLOW}Skipping system dependencies for unknown OS${NC}"
            ;;
    esac

    echo -e "${GREEN}✓ System dependencies installation completed${NC}"
}

# Install Ansible
install_ansible() {
    echo ""
    echo -n "Checking Ansible... "

    if command -v ansible &> /dev/null; then
        CURRENT_VERSION=$(ansible --version | head -n 1)
        echo -e "${GREEN}✓ Already installed${NC}"
        echo "  $CURRENT_VERSION"

        if [ $NON_INTERACTIVE -eq 0 ]; then
            read -p "Do you want to upgrade Ansible? (y/N): " -n 1 -r
            echo
            if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                return 0
            fi
            echo "Upgrading Ansible..."
        else
            echo "Skipping upgrade in non-interactive mode"
            return 0
        fi
    else
        echo -e "${YELLOW}Not found, installing...${NC}"
    fi

    # Try pip installation first (recommended method)
    echo "Installing Ansible via pip..."

    if command -v pip3 &> /dev/null; then
        pip3 install --user ansible --upgrade
    elif python3 -m pip --version &> /dev/null; then
        python3 -m pip install --user ansible --upgrade
    else
        echo -e "${YELLOW}pip not available, trying package manager...${NC}"

        case $OS in
            ubuntu|debian)
                $SUDO apt-get install -y ansible
                ;;
            centos|rhel|fedora)
                $SUDO yum install -y ansible || $SUDO dnf install -y ansible
                ;;
            alpine)
                $SUDO apk add --no-cache ansible
                ;;
            *)
                echo -e "${RED}Cannot install Ansible automatically${NC}"
                echo "Please install manually: pip3 install ansible"
                exit 1
                ;;
        esac
    fi

    # Add user bin to PATH if needed
    if ! command -v ansible &> /dev/null; then
        if [ -f "$HOME/.local/bin/ansible" ]; then
            export PATH="$HOME/.local/bin:$PATH"
            echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
            echo -e "${YELLOW}Added ~/.local/bin to PATH${NC}"
        fi
    fi

    # Verify installation
    if command -v ansible &> /dev/null; then
        echo -e "${GREEN}✓ Ansible installed successfully${NC}"
        ANSIBLE_VERSION=$(ansible --version | head -n 1)
        echo "  $ANSIBLE_VERSION"
    else
        echo -e "${RED}✗ Failed to install Ansible${NC}"
        echo "Please try manually: pip3 install --user ansible"
        exit 1
    fi
}

# Verify installation
verify_installation() {
    echo ""
    echo "========================================="
    echo "Verifying Installation"
    echo "========================================="

    FAILED=0

    # Check Python
    echo -n "Python3: "
    if command -v python3 &> /dev/null; then
        echo -e "${GREEN}✓ $(python3 --version)${NC}"
    else
        echo -e "${RED}✗ Not found${NC}"
        FAILED=1
    fi

    # Check pip
    echo -n "pip: "
    if command -v pip3 &> /dev/null; then
        echo -e "${GREEN}✓ $(pip3 --version | cut -d' ' -f1-2)${NC}"
    elif python3 -m pip --version &> /dev/null; then
        echo -e "${GREEN}✓ $(python3 -m pip --version | cut -d' ' -f1-2)${NC}"
    else
        echo -e "${RED}✗ Not found${NC}"
        FAILED=1
    fi

    # Check Ansible
    echo -n "Ansible: "
    if command -v ansible &> /dev/null; then
        echo -e "${GREEN}✓ $(ansible --version | head -n 1)${NC}"
    else
        echo -e "${RED}✗ Not found${NC}"
        FAILED=1
    fi

    # Check ansible-playbook
    echo -n "ansible-playbook: "
    if command -v ansible-playbook &> /dev/null; then
        echo -e "${GREEN}✓ Available${NC}"
    else
        echo -e "${RED}✗ Not found${NC}"
        FAILED=1
    fi

    echo ""

    if [ $FAILED -eq 0 ]; then
        echo -e "${GREEN}=========================================${NC}"
        echo -e "${GREEN}All prerequisites installed successfully!${NC}"
        echo -e "${GREEN}=========================================${NC}"
        echo ""
        echo "You can now run the training:"
        echo "  ./verify-setup.sh       - Verify Ansible configuration"
        echo "  ./run-all-tests.sh      - Run all training lessons"
        echo ""
        return 0
    else
        echo -e "${RED}=========================================${NC}"
        echo -e "${RED}Some prerequisites failed to install${NC}"
        echo -e "${RED}=========================================${NC}"
        echo ""
        return 1
    fi
}

# Main installation flow
main() {
    detect_os
    check_root

    if [ $NON_INTERACTIVE -eq 0 ]; then
        echo ""
        read -p "Do you want to proceed with installation? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo "Installation cancelled."
            exit 0
        fi
    else
        echo "Proceeding with installation automatically..."
        echo ""
    fi

    # Quick check: if Python and Ansible are already available, skip system installation
    if command -v python3 &> /dev/null && command -v pip3 &> /dev/null; then
        echo -e "${GREEN}Python3 and pip are already installed!${NC}"
        echo "Python: $(python3 --version)"
        echo "pip: $(pip3 --version 2>&1 | head -n1 || echo 'available')"
        echo ""

        # If we don't have sudo/root, skip system packages entirely
        if [ -z "$SUDO" ] && [ "$EUID" -ne 0 ]; then
            echo -e "${YELLOW}No system privileges detected.${NC}"
            echo -e "${YELLOW}Skipping system package installation (not needed).${NC}"
            echo ""
            install_ansible
            verify_installation
            return
        fi
    fi

    # Standard installation flow with system packages
    update_package_manager
    install_python
    install_pip
    install_system_dependencies
    install_ansible
    verify_installation
}

# Run main function
main
