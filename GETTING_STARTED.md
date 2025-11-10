# Getting Started with Ansible Training

## Quickest Way to Start

### Single Command Setup

Run this one command to install everything and start training:

```bash
./setup-and-run.sh
```

This script will:
- ✅ Check for Python and Ansible
- ✅ Install missing prerequisites automatically
- ✅ Verify the setup
- ✅ Give you options to run training lessons

## What Gets Installed?

The automated installation will install (if not already present):
- Python 3.x
- pip (Python package manager)
- Ansible (latest stable version)
- System dependencies (gcc, openssl, git, etc.)

**Supported OS:** Ubuntu, Debian, CentOS, RHEL, Fedora, Alpine Linux

## Installation Options

### Option 1: Fully Automated (Recommended)
```bash
chmod +x setup-and-run.sh
./setup-and-run.sh
```
Installs, verifies, and runs everything with prompts.

### Option 2: Install Then Run Separately
```bash
# Install
./install-prerequisites.sh

# Run all lessons
./run-all-tests.sh

# Or run specific lessons
./run-single-lesson.sh 1
```

### Option 3: Using Docker
```bash
# Using docker-compose
docker-compose up -d
docker-compose exec ansible-training /bin/bash
./setup-and-run.sh

# Or using docker directly
docker build -t ansible-training .
docker run -it ansible-training
./setup-and-run.sh
```

## What You'll Learn

### 6 Progressive Lessons:

1. **Basic Ansible Operations** - First playbook, facts, file creation
2. **File & Directory Management** - Loops, multiple files, finding files
3. **Variables & Facts** - Variables, lists, dictionaries, conditionals
4. **Templates with Jinja2** - Dynamic configuration files
5. **Handlers** - Event-driven task execution
6. **Comprehensive Example** - Complete application deployment

## After Installation

### Verify Everything Works
```bash
./verify-setup.sh
```

### Run All Training Lessons
```bash
./run-all-tests.sh
```

### Run Individual Lessons
```bash
./run-single-lesson.sh 1  # Basic Operations
./run-single-lesson.sh 2  # File Operations
./run-single-lesson.sh 3  # Variables & Facts
./run-single-lesson.sh 4  # Templates
./run-single-lesson.sh 5  # Handlers
./run-single-lesson.sh 6  # Comprehensive Example
```

### Explore Results
```bash
# View created files
ls -la /tmp/ansible-training/
ls -la /tmp/training-app/

# View deployment report
cat /tmp/training-app/DEPLOYMENT_REPORT.txt

# View generated configurations
cat /tmp/ansible-templates/app-config.conf
```

## Documentation

- **README.md** - Complete guide with detailed explanations
- **QUICK_REFERENCE.md** - Ansible commands and syntax reference
- **This file** - Quick start guide

## Troubleshooting

### Scripts not executable?
```bash
chmod +x *.sh
```

### Ansible not found after installation?
```bash
export PATH="$HOME/.local/bin:$PATH"
source ~/.bashrc
```

### Permission errors?
```bash
# The install script will prompt for sudo when needed
# All training playbooks work in /tmp (no special permissions needed)
```

### Still having issues?
```bash
# Re-run the installation
./install-prerequisites.sh

# Check what's installed
ansible --version
python3 --version
```

## For Jenkins Users

The included `Jenkinsfile` handles everything automatically:
- Installs prerequisites if missing
- Verifies setup
- Runs all lessons
- Displays results

Just point your Jenkins job to this repository and run!

## Quick Tips

1. **Start simple** - Run `./setup-and-run.sh` first
2. **Read the playbooks** - They're heavily commented for learning
3. **Experiment** - Modify playbooks and re-run them
4. **Use verbose mode** - Add `-v`, `-vv`, or `-vvv` to see more details
5. **Check mode** - Use `--check` to preview changes without applying them

## Ready to Begin?

```bash
./setup-and-run.sh
```

Happy Learning! 🚀
