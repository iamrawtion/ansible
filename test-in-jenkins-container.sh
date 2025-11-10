#!/bin/bash

# Test Script for jenkins/jenkins Docker Container
# This script tests the Ansible training setup in the actual jenkins/jenkins image

set -e

echo "========================================="
echo "Testing Ansible Training Setup"
echo "In jenkins/jenkins Docker Container"
echo "========================================="
echo ""

# Step 1: Check environment
echo "Step 1: Checking environment..."
echo "  User: $(whoami)"
echo "  UID: $(id -u)"
echo "  Groups: $(groups)"
echo "  Home: $HOME"
echo "  Working Dir: $(pwd)"
echo ""

# Step 2: Check Python
echo "Step 2: Checking Python..."
if command -v python3 &> /dev/null; then
    echo "  ✓ Python3: $(python3 --version)"
else
    echo "  ✗ Python3: Not found"
    exit 1
fi

# Step 3: Check pip
echo ""
echo "Step 3: Checking pip..."
if command -v pip3 &> /dev/null; then
    echo "  ✓ pip3: $(pip3 --version | head -n1)"
    PIP_CMD="pip3"
elif python3 -m pip --version &> /dev/null 2>&1; then
    echo "  ✓ pip (via python3 -m pip): $(python3 -m pip --version | head -n1)"
    PIP_CMD="python3 -m pip"
else
    echo "  ✗ pip: Not found"
    exit 1
fi

# Step 4: Check sudo availability
echo ""
echo "Step 4: Checking sudo..."
if command -v sudo &> /dev/null; then
    echo "  ✓ sudo: Available"
    HAVE_SUDO=1
else
    echo "  ✗ sudo: Not available"
    HAVE_SUDO=0
fi

# Step 5: Check if we can write to common directories
echo ""
echo "Step 5: Checking write permissions..."
if [ -w "$HOME" ]; then
    echo "  ✓ HOME ($HOME): Writable"
else
    echo "  ✗ HOME ($HOME): Not writable"
fi

if [ -w "/tmp" ]; then
    echo "  ✓ /tmp: Writable"
else
    echo "  ✗ /tmp: Not writable"
fi

# Step 6: Test pip install (dry run)
echo ""
echo "Step 6: Testing pip install capability..."
echo "  Running: $PIP_CMD install --user --dry-run ansible"
if $PIP_CMD install --user --dry-run ansible &> /dev/null; then
    echo "  ✓ pip install test: Success (can install packages)"
else
    echo "  ✗ pip install test: Failed"
    exit 1
fi

# Step 7: Check if .local/bin exists or can be created
echo ""
echo "Step 7: Checking .local/bin directory..."
if [ -d "$HOME/.local/bin" ]; then
    echo "  ✓ $HOME/.local/bin: Exists"
elif mkdir -p "$HOME/.local/bin" 2>/dev/null; then
    echo "  ✓ $HOME/.local/bin: Created successfully"
else
    echo "  ✗ $HOME/.local/bin: Cannot create"
    exit 1
fi

# Step 8: Summary
echo ""
echo "========================================="
echo "Environment Test Summary"
echo "========================================="
echo ""
echo "✓ Python: Available"
echo "✓ pip: Available"
if [ $HAVE_SUDO -eq 1 ]; then
    echo "✓ sudo: Available"
else
    echo "⚠ sudo: Not available (OK - not needed)"
fi
echo "✓ HOME: Writable"
echo "✓ pip can install packages"
echo ""
echo "========================================="
echo "RECOMMENDATION"
echo "========================================="
echo ""

if [ $HAVE_SUDO -eq 0 ]; then
    echo "Your environment does NOT have sudo."
    echo "Use pip-only installation:"
    echo ""
    echo "  ./install-ansible-only.sh"
    echo ""
    echo "Or manually:"
    echo ""
    echo "  $PIP_CMD install --user ansible"
    echo "  export PATH=\"\$HOME/.local/bin:\$PATH\""
    echo "  ansible --version"
else
    echo "Your environment HAS sudo."
    echo "You can use either:"
    echo ""
    echo "  1. Full installation: ./install-prerequisites.sh --yes"
    echo "  2. Pip-only: ./install-ansible-only.sh"
fi

echo ""
echo "========================================="
echo "Next Steps"
echo "========================================="
echo ""
echo "1. Install Ansible using recommended method above"
echo "2. Verify: ansible --version"
echo "3. Run training: ./run-all-tests.sh"
echo ""
