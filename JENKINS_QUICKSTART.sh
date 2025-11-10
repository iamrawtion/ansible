#!/bin/bash

# Quick Start Script for Jenkins Without Sudo
# Use this if you're getting "sudo: command not found" errors

set -e

echo "========================================="
echo "Jenkins Quick Start - No Sudo Required"
echo "========================================="
echo ""

# Check if Python is already installed
if command -v python3 &> /dev/null; then
    echo "✓ Python3 found: $(python3 --version)"
else
    echo "✗ Python3 not found"
    echo "ERROR: Python3 is required but not installed"
    echo "Please install Python3 or use a Docker image that includes it"
    exit 1
fi

# Check if pip is available
if command -v pip3 &> /dev/null || python3 -m pip --version &> /dev/null; then
    echo "✓ pip found"
else
    echo "✗ pip not found"
    echo "ERROR: pip is required but not installed"
    exit 1
fi

# Check if Ansible is already installed
if command -v ansible &> /dev/null; then
    echo "✓ Ansible already installed: $(ansible --version | head -n 1)"
    echo ""
    echo "Proceeding directly to training..."
else
    echo "Installing Ansible via pip (no sudo required)..."

    # Install Ansible using pip (user installation, no sudo needed)
    if command -v pip3 &> /dev/null; then
        pip3 install --user ansible
    else
        python3 -m pip install --user ansible
    fi

    # Add to PATH
    export PATH="$HOME/.local/bin:$PATH"

    # Verify installation
    if command -v ansible &> /dev/null; then
        echo "✓ Ansible installed successfully: $(ansible --version | head -n 1)"
    else
        echo "✗ Ansible installation failed"
        echo "Trying to add ~/.local/bin to PATH..."
        export PATH="$HOME/.local/bin:$PATH"

        if command -v ansible &> /dev/null; then
            echo "✓ Ansible found after PATH update"
        else
            echo "ERROR: Could not find Ansible after installation"
            exit 1
        fi
    fi
fi

echo ""
echo "========================================="
echo "Setup Complete!"
echo "========================================="
echo ""

# Make other scripts executable
chmod +x *.sh 2>/dev/null || true

echo "You can now run:"
echo "  ./run-all-tests.sh        - Run all 6 training lessons"
echo "  ./run-single-lesson.sh 1  - Run a specific lesson"
echo ""

# Ask if user wants to run training now
if [ -t 0 ]; then
    # Interactive
    read -p "Run all training lessons now? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        ./run-all-tests.sh
    fi
else
    # Non-interactive (Jenkins)
    echo "Running in non-interactive mode, executing all lessons..."
    ./run-all-tests.sh
fi
