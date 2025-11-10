#!/bin/bash

# Quick Python Check for Jenkins Container
# This helps diagnose Python availability issues

echo "========================================="
echo "Python Environment Check"
echo "========================================="
echo ""

echo "Checking for Python installations..."
echo ""

# Check python3
echo -n "python3: "
if command -v python3 &> /dev/null; then
    echo "✓ Found at: $(which python3)"
    python3 --version
else
    echo "✗ Not found"
fi

echo ""

# Check python
echo -n "python: "
if command -v python &> /dev/null; then
    echo "✓ Found at: $(which python)"
    python --version 2>&1
else
    echo "✗ Not found"
fi

echo ""
echo "----------------------------------------"
echo "Checking for pip..."
echo ""

# Check pip3
echo -n "pip3: "
if command -v pip3 &> /dev/null; then
    echo "✓ Found"
else
    echo "✗ Not found"
fi

# Check pip
echo -n "pip: "
if command -v pip &> /dev/null; then
    echo "✓ Found"
else
    echo "✗ Not found"
fi

# Check pip via python module
echo -n "python -m pip: "
if python -m pip --version &> /dev/null 2>&1; then
    echo "✓ Available"
elif python3 -m pip --version &> /dev/null 2>&1; then
    echo "✓ Available (via python3)"
else
    echo "✗ Not available"
fi

echo ""
echo "========================================="
echo "Environment Variables"
echo "========================================="
echo "PATH: $PATH"
echo "HOME: $HOME"
echo "USER: $(whoami)"
echo ""

echo "========================================="
echo "Recommendation"
echo "========================================="
echo ""

if command -v python3 &> /dev/null || command -v python &> /dev/null; then
    echo "✓ Python is available"
    echo ""
    echo "You can install Ansible with:"
    if command -v python3 &> /dev/null; then
        echo "  python3 -m pip install --user ansible"
    else
        echo "  python -m pip install --user ansible"
    fi
else
    echo "✗ Python is NOT available in this container"
    echo ""
    echo "The jenkins/jenkins:lts image does NOT include Python by default!"
    echo ""
    echo "Solutions:"
    echo "  1. Use jenkins/jenkins:lts-jdk17 (may have Python)"
    echo "  2. Use a custom Dockerfile to add Python"
    echo "  3. Install Python in Jenkins startup scripts"
    echo ""
    echo "See: JENKINS_SETUP.md for examples"
fi

echo ""
