#!/bin/bash

# Ansible Training - Single Lesson Runner
# Usage: ./run-single-lesson.sh <lesson-number>

if [ -z "$1" ]; then
    echo "Usage: $0 <lesson-number>"
    echo ""
    echo "Available lessons:"
    echo "  1 - Basic Ansible Operations"
    echo "  2 - File and Directory Management"
    echo "  3 - Variables and Facts"
    echo "  4 - Templates with Jinja2"
    echo "  5 - Handlers"
    echo "  6 - Comprehensive Example"
    echo ""
    echo "Example: $0 1"
    exit 1
fi

LESSON=$1
PLAYBOOK=$(printf "%02d" $LESSON)

case $LESSON in
    1)
        LESSON_NAME="Basic Ansible Operations"
        PLAYBOOK_FILE="01-basic-playbook.yml"
        ;;
    2)
        LESSON_NAME="File and Directory Management"
        PLAYBOOK_FILE="02-file-operations.yml"
        ;;
    3)
        LESSON_NAME="Variables and Facts"
        PLAYBOOK_FILE="03-variables-and-facts.yml"
        ;;
    4)
        LESSON_NAME="Templates with Jinja2"
        PLAYBOOK_FILE="04-templates.yml"
        ;;
    5)
        LESSON_NAME="Handlers"
        PLAYBOOK_FILE="05-handlers.yml"
        ;;
    6)
        LESSON_NAME="Comprehensive Example"
        PLAYBOOK_FILE="06-comprehensive-example.yml"
        ;;
    *)
        echo "Error: Invalid lesson number. Please choose 1-6."
        exit 1
        ;;
esac

echo "========================================="
echo "Running Lesson $LESSON: $LESSON_NAME"
echo "========================================="
echo ""

ansible-playbook "$PLAYBOOK_FILE"

echo ""
echo "Lesson $LESSON completed!"
