# Installation Guide

## Interactive Installation (Local Development)

For local development and learning, use the interactive mode:

```bash
./install-prerequisites.sh
```

The script will:
1. Detect your operating system
2. Ask for confirmation before proceeding
3. Prompt for sudo password when needed
4. Ask if you want to upgrade existing Ansible installation

## Non-Interactive Installation (CI/CD, Jenkins, Docker)

For automated environments, use non-interactive mode:

```bash
./install-prerequisites.sh --yes
# or
./install-prerequisites.sh -y
# or
./install-prerequisites.sh --non-interactive
```

You can also set an environment variable:
```bash
export ANSIBLE_TRAINING_NONINTERACTIVE=1
./install-prerequisites.sh
```

**The script automatically detects non-interactive mode when:**
- Running in a pipeline without TTY
- Using any of the flags above
- Environment variable is set

## What Gets Installed

### Python Stack
- Python 3.x
- pip (Python package manager)
- Python development headers

### System Dependencies
**Ubuntu/Debian:**
- software-properties-common
- build-essential
- libssl-dev
- libffi-dev
- git
- curl

**CentOS/RHEL/Fedora:**
- gcc
- openssl-devel
- libffi-devel
- git
- curl

**Alpine:**
- gcc
- musl-dev
- libffi-dev
- openssl-dev
- git
- curl

### Ansible
- Latest stable version via pip
- Installed to user directory (~/.local/bin)
- Automatically added to PATH

## Supported Operating Systems

- ✅ Ubuntu (18.04+)
- ✅ Debian (10+)
- ✅ CentOS (7+)
- ✅ RHEL (7+)
- ✅ Fedora (30+)
- ✅ Alpine Linux (3.12+)

## Installation Methods

### Method 1: One-Command Setup (Recommended for Beginners)
```bash
./setup-and-run.sh
```
Installs, verifies, and runs training interactively.

### Method 2: Manual Installation
```bash
# Install prerequisites
./install-prerequisites.sh --yes

# Verify installation
./verify-setup.sh

# Run training
./run-all-tests.sh
```

### Method 3: Docker
```bash
docker-compose up -d
docker-compose exec ansible-training /bin/bash
./setup-and-run.sh
```

### Method 4: Jenkins Pipeline
The included `Jenkinsfile` handles everything automatically.

## Verification

After installation, verify everything works:

```bash
# Check Ansible
ansible --version

# Check Python
python3 --version

# Run verification script
./verify-setup.sh

# Test Ansible connectivity
ansible local -m ping
```

## Troubleshooting Installation

### Issue: Ansible command not found after installation

**Solution:** Ansible is installed to ~/.local/bin, add it to PATH:
```bash
export PATH="$HOME/.local/bin:$PATH"
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

The installation script does this automatically, but you may need to reload your shell.

### Issue: Permission denied during installation

**Solution:** The script needs sudo for system packages:
```bash
# Run as regular user (script will prompt for sudo)
./install-prerequisites.sh --yes

# If sudo is not available, install system packages manually first
# Then run with just pip installation
pip3 install --user ansible
```

### Issue: pip install fails

**Solution:** Ensure pip and Python dev tools are installed:
```bash
# Ubuntu/Debian
sudo apt-get install python3-pip python3-dev

# CentOS/RHEL
sudo yum install python3-pip python3-devel

# Then retry
./install-prerequisites.sh --yes
```

### Issue: Old Ansible version

**Solution:** Upgrade Ansible:
```bash
pip3 install --user --upgrade ansible

# Or re-run the installation
./install-prerequisites.sh --yes
```

### Issue: Installation hangs waiting for input

**Solution:** You're in non-interactive mode without the flag:
```bash
# Use the --yes flag
./install-prerequisites.sh --yes

# Or pipe yes
yes | ./install-prerequisites.sh
```

## Manual Installation (Without Scripts)

If the automated scripts don't work for your environment:

### Step 1: Install Python and pip
```bash
# Ubuntu/Debian
sudo apt-get update
sudo apt-get install -y python3 python3-pip

# CentOS/RHEL
sudo yum install -y python3 python3-pip

# Alpine
sudo apk add python3 py3-pip
```

### Step 2: Install System Dependencies
```bash
# Ubuntu/Debian
sudo apt-get install -y build-essential libssl-dev libffi-dev git

# CentOS/RHEL
sudo yum install -y gcc openssl-devel libffi-devel git

# Alpine
sudo apk add gcc musl-dev libffi-dev openssl-dev git
```

### Step 3: Install Ansible
```bash
pip3 install --user ansible
```

### Step 4: Add to PATH
```bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

### Step 5: Verify
```bash
ansible --version
```

## Uninstallation

To remove Ansible and related tools:

```bash
# Remove Ansible
pip3 uninstall ansible

# Remove from PATH (edit ~/.bashrc)
# Remove the line: export PATH="$HOME/.local/bin:$PATH"

# Clean up Python cache
rm -rf ~/.local/lib/python*/site-packages/ansible*
rm -rf ~/.cache/pip
```

## Getting Help

If you encounter issues:

1. Check this INSTALL.md guide
2. Review TROUBLESHOOTING section in README.md
3. Run with verbose output:
   ```bash
   bash -x ./install-prerequisites.sh --yes
   ```
4. Check system logs:
   ```bash
   tail -f /var/log/syslog  # Ubuntu/Debian
   tail -f /var/log/messages  # CentOS/RHEL
   ```

## Minimal Requirements

- **OS:** Any Linux distribution with bash
- **Memory:** 512MB RAM minimum
- **Disk:** 100MB free space
- **Network:** Internet connection for downloading packages
- **Privileges:** sudo access for system package installation
