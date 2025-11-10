#!/bin/bash

# Ansible Training - Setup Verification Script
# This script verifies that Ansible is properly installed and configured

echo "========================================="
echo "Ansible Training - Setup Verification"
echo "========================================="
echo ""

# Color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

ERRORS=0
MISSING_PREREQUISITES=0

# Check Ansible installation
echo -n "Checking Ansible installation... "
if command -v ansible &> /dev/null; then
    echo -e "${GREEN}✓${NC}"
    ANSIBLE_VERSION=$(ansible --version | head -n 1)
    echo "  Version: $ANSIBLE_VERSION"
else
    echo -e "${RED}✗${NC}"
    echo "  Ansible is not installed!"
    ERRORS=$((ERRORS + 1))
    MISSING_PREREQUISITES=1
fi

# Check ansible-playbook
echo -n "Checking ansible-playbook command... "
if command -v ansible-playbook &> /dev/null; then
    echo -e "${GREEN}✓${NC}"
else
    echo -e "${RED}✗${NC}"
    ERRORS=$((ERRORS + 1))
    MISSING_PREREQUISITES=1
fi

# Check Python
echo -n "Checking Python installation... "
if command -v python3 &> /dev/null; then
    echo -e "${GREEN}✓${NC}"
    PYTHON_VERSION=$(python3 --version)
    echo "  Version: $PYTHON_VERSION"
else
    echo -e "${RED}✗${NC}"
    echo "  Python 3 is not installed!"
    ERRORS=$((ERRORS + 1))
    MISSING_PREREQUISITES=1
fi

echo ""
echo "Checking required files..."

# Check for required files
FILES=(
    "ansible.cfg"
    "inventory.ini"
    "01-basic-playbook.yml"
    "02-file-operations.yml"
    "03-variables-and-facts.yml"
    "04-templates.yml"
    "05-handlers.yml"
    "06-comprehensive-example.yml"
    "templates/app-config.j2"
    "templates/index.html.j2"
)

for file in "${FILES[@]}"; do
    echo -n "  Checking $file... "
    if [ -f "$file" ]; then
        echo -e "${GREEN}✓${NC}"
    else
        echo -e "${RED}✗${NC}"
        ERRORS=$((ERRORS + 1))
    fi
done

echo ""

# Test Ansible configuration
echo -n "Testing Ansible configuration... "
if ansible all --list-hosts &> /dev/null; then
    echo -e "${GREEN}✓${NC}"
    echo "  Configured hosts:"
    ansible all --list-hosts | sed 's/^/    /'
else
    echo -e "${RED}✗${NC}"
    ERRORS=$((ERRORS + 1))
fi

echo ""

# Test connectivity
echo -n "Testing localhost connectivity... "
if ansible local -m ping &> /dev/null; then
    echo -e "${GREEN}✓${NC}"
else
    echo -e "${RED}✗${NC}"
    ERRORS=$((ERRORS + 1))
fi

echo ""
echo "========================================="

if [ $ERRORS -eq 0 ]; then
    echo -e "${GREEN}All checks passed! Setup is ready.${NC}"
    echo ""
    echo "You can now run the training lessons:"
    echo "  ./run-all-tests.sh        - Run all lessons"
    echo "  ./run-single-lesson.sh 1  - Run a specific lesson"
    echo ""
    exit 0
else
    echo -e "${RED}Setup verification failed with $ERRORS error(s).${NC}"
    echo ""

    # Offer to install prerequisites if they're missing
    if [ $MISSING_PREREQUISITES -eq 1 ]; then
        echo -e "${YELLOW}Missing prerequisites detected.${NC}"
        echo ""
        read -p "Would you like to automatically install missing prerequisites? (y/N): " -n 1 -r
        echo ""

        if [[ $REPLY =~ ^[Yy]$ ]]; then
            if [ -f "./install-prerequisites.sh" ]; then
                echo ""
                echo "Running installation script..."
                chmod +x ./install-prerequisites.sh
                ./install-prerequisites.sh

                # Re-run verification after installation
                if [ $? -eq 0 ]; then
                    echo ""
                    echo "Re-running verification..."
                    exec "$0"
                else
                    echo -e "${RED}Installation failed. Please check the errors above.${NC}"
                    exit 1
                fi
            else
                echo -e "${RED}Installation script not found!${NC}"
                echo "Please run: ./install-prerequisites.sh manually"
                exit 1
            fi
        else
            echo "Please install missing prerequisites manually:"
            echo "  ./install-prerequisites.sh"
            echo ""
            exit 1
        fi
    else
        echo "Please fix the issues above before running the training."
        echo ""
        exit 1
    fi
fi
