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

# Check Python (try python3 first, then python)
echo -n "Checking Python... "
PYTHON_CMD=""
if command -v python3 &> /dev/null; then
    PYTHON_CMD="python3"
    echo -e "${GREEN}✓ Found: $(python3 --version)${NC}"
elif command -v python &> /dev/null; then
    # Check if it's Python 3
    PYTHON_VERSION=$(python --version 2>&1)
    if echo "$PYTHON_VERSION" | grep -q "Python 3"; then
        PYTHON_CMD="python"
        echo -e "${GREEN}✓ Found: $PYTHON_VERSION${NC}"
    else
        echo -e "${RED}✗ Found Python 2 (Python 3 required)${NC}"
        echo ""
        echo "ERROR: Python 3 is required but only Python 2 was found."
        echo "Please install Python 3."
        exit 1
    fi
else
    echo -e "${RED}✗ Not found${NC}"
    echo ""
    echo "ERROR: Python is not installed in this container."
    echo ""
    echo "The jenkins/jenkins image may not include Python by default."
    echo "You need to either:"
    echo "  1. Use a Jenkins image that includes Python"
    echo "  2. Install Python in your Jenkins container"
    echo "  3. Use a custom Dockerfile"
    echo ""
    echo "See JENKINS_SETUP.md for Docker images with Python pre-installed."
    exit 1
fi

# Check pip
echo -n "Checking pip... "
if command -v pip3 &> /dev/null; then
    echo -e "${GREEN}✓ Found${NC}"
    PIP_CMD="pip3"
elif command -v pip &> /dev/null; then
    echo -e "${GREEN}✓ Found${NC}"
    PIP_CMD="pip"
elif $PYTHON_CMD -m pip --version &> /dev/null 2>&1; then
    echo -e "${GREEN}✓ Found ($PYTHON_CMD -m pip)${NC}"
    PIP_CMD="$PYTHON_CMD -m pip"
else
    echo -e "${RED}✗ Not found${NC}"
    echo ""
    echo "ERROR: pip is not installed."
    echo "Try: $PYTHON_CMD -m ensurepip --user"
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
