#!/bin/bash

# Ansible Training - Test Runner Script
# This script runs all training playbooks sequentially

set -e  # Exit on error

echo "========================================="
echo "Ansible Training - Running All Lessons"
echo "========================================="
echo ""

# Color codes for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to run a playbook
run_playbook() {
    local playbook=$1
    local lesson_name=$2

    echo ""
    echo -e "${BLUE}=========================================${NC}"
    echo -e "${BLUE}Running: $lesson_name${NC}"
    echo -e "${BLUE}Playbook: $playbook${NC}"
    echo -e "${BLUE}=========================================${NC}"
    echo ""

    if ansible-playbook "$playbook"; then
        echo -e "${GREEN}✓ $lesson_name completed successfully${NC}"
    else
        echo -e "${RED}✗ $lesson_name failed${NC}"
        exit 1
    fi
}

# Check if Ansible is installed
if ! command -v ansible-playbook &> /dev/null; then
    echo -e "${RED}Error: ansible-playbook command not found${NC}"
    echo "Please install Ansible first"
    exit 1
fi

# Display Ansible version
echo "Ansible version:"
ansible --version
echo ""

# Run all playbooks in order
run_playbook "01-basic-playbook.yml" "Lesson 1: Basic Ansible Operations"
run_playbook "02-file-operations.yml" "Lesson 2: File and Directory Management"
run_playbook "03-variables-and-facts.yml" "Lesson 3: Variables and Facts"
run_playbook "04-templates.yml" "Lesson 4: Templates with Jinja2"
run_playbook "05-handlers.yml" "Lesson 5: Handlers"
run_playbook "06-comprehensive-example.yml" "Lesson 6: Comprehensive Example"

echo ""
echo -e "${GREEN}=========================================${NC}"
echo -e "${GREEN}All lessons completed successfully!${NC}"
echo -e "${GREEN}=========================================${NC}"
echo ""
echo "Training artifacts created in /tmp:"
echo "  - /tmp/ansible-training/"
echo "  - /tmp/ansible-files-demo/"
echo "  - /tmp/ansible-templates/"
echo "  - /tmp/ansible-handlers-demo/"
echo "  - /tmp/training-app/"
echo ""
echo "You can explore these directories to see what Ansible created!"
