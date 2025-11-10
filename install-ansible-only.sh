#!/bin/bash

# Minimal Ansible Installation - No System Permissions Required
# This script only installs Ansible via pip, assuming Python is already installed

set -e

# Color codes
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "========================================="
echo "Ansible Installation - Pip Only"
echo "========================================="
echo ""

# Check Python
echo -n "Checking Python3... "
if ! command -v python3 &> /dev/null; then
    echo -e "${RED}✗ Not found${NC}"
    echo ""
    echo "ERROR: Python3 is required but not installed."
    echo "Please install Python3 or run the full installation script."
    exit 1
fi
echo -e "${GREEN}✓ Found: $(python3 --version)${NC}"

# Check pip
echo -n "Checking pip... "
if command -v pip3 &> /dev/null; then
    echo -e "${GREEN}✓ Found${NC}"
    PIP_CMD="pip3"
elif python3 -m pip --version &> /dev/null 2>&1; then
    echo -e "${GREEN}✓ Found (python3 -m pip)${NC}"
    PIP_CMD="python3 -m pip"
else
    echo -e "${RED}✗ Not found${NC}"
    echo ""
    echo "ERROR: pip is required but not installed."
    echo "Try: python3 -m ensurepip --user"
    exit 1
fi

# Check if Ansible already installed
echo ""
echo -n "Checking Ansible... "
if command -v ansible &> /dev/null; then
    echo -e "${GREEN}✓ Already installed${NC}"
    echo "  Version: $(ansible --version | head -n1)"
    echo ""
    echo "Ansible is ready to use!"
    exit 0
fi
echo -e "${YELLOW}Not installed${NC}"

# Install Ansible
echo ""
echo "Installing Ansible via pip (no system privileges needed)..."
echo ""

$PIP_CMD install --user ansible

# Update PATH
export PATH="$HOME/.local/bin:$PATH"

# Verify installation
echo ""
echo "Verifying installation..."
echo ""

if command -v ansible &> /dev/null; then
    echo -e "${GREEN}=========================================${NC}"
    echo -e "${GREEN}✓ Ansible installed successfully!${NC}"
    echo -e "${GREEN}=========================================${NC}"
    echo ""
    echo "Version: $(ansible --version | head -n1)"
    echo "Location: $(which ansible)"
    echo ""
    echo "Note: Add this to your shell profile for permanent PATH:"
    echo "  export PATH=\"\$HOME/.local/bin:\$PATH\""
    echo ""
    echo "You can now run:"
    echo "  ./run-all-tests.sh"
    echo ""
    exit 0
else
    # Try to find it
    if [ -f "$HOME/.local/bin/ansible" ]; then
        echo -e "${YELLOW}Ansible installed but not in PATH${NC}"
        echo ""
        echo "Run this command to add it to PATH:"
        echo "  export PATH=\"\$HOME/.local/bin:\$PATH\""
        echo ""
        echo "Then verify with:"
        echo "  ansible --version"
        exit 0
    else
        echo -e "${RED}✗ Installation failed${NC}"
        echo ""
        echo "Troubleshooting:"
        echo "1. Check pip installation: $PIP_CMD --version"
        echo "2. Try: $PIP_CMD install --user --upgrade ansible"
        echo "3. Check ~/.local/bin directory exists"
        exit 1
    fi
fi
