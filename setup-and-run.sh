#!/bin/bash

# Ansible Training - Master Setup and Run Script
# This script installs prerequisites, verifies setup, and runs all training lessons

set -e  # Exit on error

# Color codes
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo ""
echo -e "${BLUE}=========================================${NC}"
echo -e "${BLUE}  Ansible Training - Complete Setup${NC}"
echo -e "${BLUE}=========================================${NC}"
echo ""
echo "This script will:"
echo "  1. Check for prerequisites (Python, Ansible)"
echo "  2. Install missing prerequisites if needed"
echo "  3. Verify the setup"
echo "  4. Run all training lessons"
echo ""

# Function to check if running in interactive mode
is_interactive() {
    [[ -t 0 ]]
}

# Make scripts executable
chmod +x install-prerequisites.sh verify-setup.sh run-all-tests.sh run-single-lesson.sh 2>/dev/null || true

# Step 1: Check if prerequisites are installed
echo -e "${BLUE}=========================================${NC}"
echo -e "${BLUE}Step 1: Checking Prerequisites${NC}"
echo -e "${BLUE}=========================================${NC}"
echo ""

NEED_INSTALL=0

# Quick check for Ansible
if ! command -v ansible &> /dev/null; then
    echo -e "${YELLOW}Ansible not found${NC}"
    NEED_INSTALL=1
fi

# Quick check for Python
if ! command -v python3 &> /dev/null; then
    echo -e "${YELLOW}Python3 not found${NC}"
    NEED_INSTALL=1
fi

# Step 2: Install prerequisites if needed
if [ $NEED_INSTALL -eq 1 ]; then
    echo -e "${YELLOW}Some prerequisites are missing.${NC}"
    echo ""

    if is_interactive; then
        read -p "Do you want to install missing prerequisites? (Y/n): " -n 1 -r
        echo ""
        if [[ ! $REPLY =~ ^[Nn]$ ]]; then
            INSTALL_CONFIRM=1
        else
            INSTALL_CONFIRM=0
        fi
    else
        # Non-interactive mode: proceed with installation
        echo "Running in non-interactive mode, proceeding with installation..."
        INSTALL_CONFIRM=1
    fi

    if [ $INSTALL_CONFIRM -eq 1 ]; then
        echo ""
        echo -e "${BLUE}=========================================${NC}"
        echo -e "${BLUE}Step 2: Installing Prerequisites${NC}"
        echo -e "${BLUE}=========================================${NC}"
        echo ""

        # Call install script with --yes flag if non-interactive
        if is_interactive; then
            ./install-prerequisites.sh
        else
            ./install-prerequisites.sh --yes
        fi

        if [ $? -ne 0 ]; then
            echo -e "${RED}Installation failed. Exiting.${NC}"
            exit 1
        fi
    else
        echo -e "${RED}Cannot proceed without prerequisites. Exiting.${NC}"
        exit 1
    fi
else
    echo -e "${GREEN}✓ Prerequisites appear to be installed${NC}"
    echo ""
fi

# Step 3: Verify setup
echo ""
echo -e "${BLUE}=========================================${NC}"
echo -e "${BLUE}Step 3: Verifying Setup${NC}"
echo -e "${BLUE}=========================================${NC}"
echo ""

# Run verification in non-interactive mode by piping 'n' to it
echo "n" | ./verify-setup.sh

if [ $? -ne 0 ]; then
    echo -e "${RED}Verification failed. Please check the errors above.${NC}"
    exit 1
fi

# Step 4: Ask to run training
echo ""
echo -e "${BLUE}=========================================${NC}"
echo -e "${BLUE}Step 4: Run Training Lessons${NC}"
echo -e "${BLUE}=========================================${NC}"
echo ""

if is_interactive; then
    echo "Setup is complete! You have the following options:"
    echo ""
    echo "  1. Run all training lessons now"
    echo "  2. Run a specific lesson"
    echo "  3. Exit and run manually later"
    echo ""
    read -p "Enter your choice (1-3): " -n 1 -r CHOICE
    echo ""
    echo ""

    case $CHOICE in
        1)
            echo -e "${BLUE}Running all training lessons...${NC}"
            echo ""
            ./run-all-tests.sh
            ;;
        2)
            echo ""
            echo "Available lessons:"
            echo "  1 - Basic Ansible Operations"
            echo "  2 - File and Directory Management"
            echo "  3 - Variables and Facts"
            echo "  4 - Templates with Jinja2"
            echo "  5 - Handlers"
            echo "  6 - Comprehensive Example"
            echo ""
            read -p "Enter lesson number (1-6): " -n 1 -r LESSON
            echo ""
            echo ""
            ./run-single-lesson.sh $LESSON
            ;;
        3)
            echo -e "${GREEN}Setup complete!${NC}"
            echo ""
            echo "You can run the training anytime with:"
            echo "  ./run-all-tests.sh        - Run all lessons"
            echo "  ./run-single-lesson.sh N  - Run lesson N"
            echo ""
            exit 0
            ;;
        *)
            echo -e "${YELLOW}Invalid choice. Exiting.${NC}"
            echo ""
            echo "You can run the training anytime with:"
            echo "  ./run-all-tests.sh        - Run all lessons"
            echo "  ./run-single-lesson.sh N  - Run lesson N"
            echo ""
            exit 0
            ;;
    esac
else
    # Non-interactive mode: run all lessons
    echo "Running in non-interactive mode, executing all lessons..."
    ./run-all-tests.sh
fi

# Final message
echo ""
echo -e "${GREEN}=========================================${NC}"
echo -e "${GREEN}Training Complete!${NC}"
echo -e "${GREEN}=========================================${NC}"
echo ""
echo "Explore the results in /tmp:"
echo "  ls -la /tmp/ansible-training/"
echo "  ls -la /tmp/training-app/"
echo "  cat /tmp/training-app/DEPLOYMENT_REPORT.txt"
echo ""
echo "Learn more by reading:"
echo "  cat README.md"
echo "  cat QUICK_REFERENCE.md"
echo ""
