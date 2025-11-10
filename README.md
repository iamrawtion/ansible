# Ansible Training for Beginners

Welcome to the Ansible training course! This repository contains hands-on examples designed to teach you Ansible fundamentals through practical exercises.

## Prerequisites

This training will work on any Linux environment. The setup scripts will automatically install:
- Python 3.x
- pip (Python package manager)
- Ansible (version 2.9 or higher)
- Required system dependencies

**Supported Operating Systems:**
- Ubuntu/Debian
- CentOS/RHEL/Fedora
- Alpine Linux
- Other Linux distributions with Python 3

## Quick Start

### Option 1: Automated Setup (Recommended for First-Time Users)

Run everything automatically - installs prerequisites, verifies setup, and runs training:

```bash
chmod +x setup-and-run.sh
./setup-and-run.sh
```

This script will:
1. Check if Ansible and Python are installed
2. Automatically install missing prerequisites (with your confirmation)
3. Verify the complete setup
4. Give you options to run the training lessons

### Option 2: Manual Step-by-Step Setup

#### 1. Install Prerequisites (if needed)

If Ansible is not installed, run:

```bash
chmod +x install-prerequisites.sh
./install-prerequisites.sh
```

This will automatically detect your OS and install:
- Python 3
- pip
- Ansible
- Required system packages

#### 2. Verify Your Setup

Check that everything is properly configured:

```bash
./verify-setup.sh
```

This script will:
- Check Ansible installation
- Check Python installation
- Verify required files
- Test connectivity to localhost
- **Offer to install missing prerequisites automatically**

#### 3. Run All Lessons

To run all training lessons sequentially:

```bash
./run-all-tests.sh
```

#### 4. Run Individual Lessons

To run a specific lesson:

```bash
./run-single-lesson.sh <lesson-number>
```

For example:
```bash
./run-single-lesson.sh 1  # Run Lesson 1
./run-single-lesson.sh 3  # Run Lesson 3
```

## Training Lessons

### Lesson 1: Basic Ansible Operations
**File:** `01-basic-playbook.yml`

Learn the fundamentals:
- Running your first playbook
- Using the `debug` module to display messages
- Working with Ansible facts
- Creating files and directories
- Using the `stat` module to check file information

**Run it:**
```bash
ansible-playbook 01-basic-playbook.yml
```

### Lesson 2: File and Directory Management
**File:** `02-file-operations.yml`

Master file operations:
- Creating directory structures
- Managing multiple files with loops
- Using the `copy` and `lineinfile` modules
- Finding and listing files
- Working with dynamic content

**Run it:**
```bash
ansible-playbook 02-file-operations.yml
```

### Lesson 3: Variables and Facts
**File:** `03-variables-and-facts.yml`

Understand Ansible variables:
- Defining simple variables
- Working with lists and dictionaries
- Using system facts
- Setting facts dynamically
- Conditional task execution
- Variable substitution in files

**Run it:**
```bash
ansible-playbook 03-variables-and-facts.yml
```

### Lesson 4: Templates with Jinja2
**File:** `04-templates.yml`

Learn template creation:
- Using Jinja2 template syntax
- Dynamic configuration generation
- Conditional blocks in templates
- Loops in templates
- Creating HTML and configuration files

**Run it:**
```bash
ansible-playbook 04-templates.yml
```

### Lesson 5: Handlers
**File:** `05-handlers.yml`

Understand handlers:
- What handlers are and when to use them
- Notifying handlers from tasks
- Handler execution order
- Using handlers for service restarts
- Best practices for handlers

**Run it:**
```bash
ansible-playbook 05-handlers.yml
```

### Lesson 6: Comprehensive Example
**File:** `06-comprehensive-example.yml`

Put it all together:
- Complete application deployment
- Directory structure creation
- Configuration file generation
- Using multiple Ansible features together
- Generating deployment reports

**Run it:**
```bash
ansible-playbook 06-comprehensive-example.yml
```

## File Structure

```
ansible/
├── ansible.cfg                    # Ansible configuration
├── inventory.ini                  # Inventory file (defines localhost)
├── group_vars/
│   └── all.yml                   # Global variables
├── templates/
│   ├── app-config.j2             # Application configuration template
│   └── index.html.j2             # HTML template example
├── 01-basic-playbook.yml         # Lesson 1: Basic Operations
├── 02-file-operations.yml        # Lesson 2: File Management
├── 03-variables-and-facts.yml    # Lesson 3: Variables
├── 04-templates.yml              # Lesson 4: Templates
├── 05-handlers.yml               # Lesson 5: Handlers
├── 06-comprehensive-example.yml  # Lesson 6: Complete Example
├── setup-and-run.sh              # One-command setup and execution
├── install-prerequisites.sh      # Auto-install Ansible and dependencies
├── verify-setup.sh               # Verify setup (offers auto-install)
├── run-all-tests.sh              # Run all lessons
├── run-single-lesson.sh          # Run individual lessons
├── Jenkinsfile                   # Jenkins pipeline configuration
├── README.md                     # This file (detailed guide)
└── QUICK_REFERENCE.md            # Ansible command reference
```

## Common Ansible Commands

Here are some useful commands to explore:

### Check Ansible Version
```bash
ansible --version
```

### List All Hosts
```bash
ansible all --list-hosts
```

### Test Connectivity
```bash
ansible all -m ping
```

### Run a Playbook
```bash
ansible-playbook <playbook-file.yml>
```

### Run with Verbose Output
```bash
ansible-playbook <playbook-file.yml> -v    # Verbose
ansible-playbook <playbook-file.yml> -vv   # More verbose
ansible-playbook <playbook-file.yml> -vvv  # Very verbose
```

### Check Syntax
```bash
ansible-playbook <playbook-file.yml> --syntax-check
```

### Dry Run (Check Mode)
```bash
ansible-playbook <playbook-file.yml> --check
```

### List Tasks
```bash
ansible-playbook <playbook-file.yml> --list-tasks
```

### Run Specific Tags
```bash
ansible-playbook <playbook-file.yml> --tags "tag_name"
```

## Exploring Results

After running the lessons, you can explore the created files:

```bash
# View files created in Lesson 1
ls -la /tmp/ansible-training/
cat /tmp/ansible-training/hello.txt

# View files from Lesson 2
tree /tmp/ansible-files-demo/  # or use: find /tmp/ansible-files-demo/
cat /tmp/ansible-files-demo/config/app1.conf

# View variables example
cat /tmp/app-info.txt

# View templates output
cat /tmp/ansible-templates/app-config.conf
cat /tmp/ansible-templates/index.html

# View comprehensive example deployment
cat /tmp/training-app/DEPLOYMENT_REPORT.txt
tree /tmp/training-app/  # or use: find /tmp/training-app/
```

## Tips for Learning

1. **Read the Playbooks**: Each playbook is heavily commented. Read through them to understand what each task does.

2. **Experiment**: Try modifying the playbooks to see how changes affect the output.

3. **Use Verbose Mode**: Run playbooks with `-v`, `-vv`, or `-vvv` flags to see more details about what Ansible is doing.

4. **Check Mode**: Use `--check` to see what would change without actually making changes.

5. **Syntax Check**: Always validate your playbooks with `--syntax-check` before running them.

6. **Read Documentation**: Use `ansible-doc <module-name>` to learn about specific modules.
   ```bash
   ansible-doc copy
   ansible-doc file
   ansible-doc template
   ```

## Troubleshooting

### Ansible Command Not Found

**Easiest Solution:** Use the automated installation script:
```bash
./install-prerequisites.sh
```

**Manual Installation:**
```bash
pip3 install ansible
# or
apt-get install ansible  # on Debian/Ubuntu
yum install ansible      # on RHEL/CentOS
```

### Python Not Found

The installation script will handle this automatically, or install manually:
```bash
# Ubuntu/Debian
sudo apt-get update && sudo apt-get install -y python3 python3-pip

# CentOS/RHEL
sudo yum install -y python3 python3-pip

# Alpine
sudo apk add python3 py3-pip
```

### Permission Denied

If you get permission errors:
- Run with sudo for system-level operations (the install script will prompt when needed)
- Check file permissions: `chmod +x *.sh`
- Ensure you have write access to /tmp (all training playbooks use /tmp)

### Module Not Found

Update Ansible to the latest version:
```bash
pip3 install --upgrade ansible
# or run the install script again
./install-prerequisites.sh
```

### Playbook Fails
- Check syntax: `ansible-playbook <file> --syntax-check`
- Run in check mode first: `ansible-playbook <file> --check`
- Use verbose output: `ansible-playbook <file> -vvv`

### PATH Issues

If Ansible is installed but not found, add to PATH:
```bash
export PATH="$HOME/.local/bin:$PATH"
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
```

The installation script handles this automatically.

## Next Steps

After completing these lessons, you can:

1. **Learn about Roles**: Organize playbooks into reusable roles
2. **Explore Ansible Galaxy**: Use pre-built roles from the community
3. **Work with Remote Hosts**: Configure Ansible to manage remote servers
4. **Use Ansible Vault**: Learn to encrypt sensitive data
5. **Try Ansible Tower/AWX**: Explore the web UI for Ansible

## Additional Resources

- [Official Ansible Documentation](https://docs.ansible.com/)
- [Ansible Galaxy](https://galaxy.ansible.com/)
- [Ansible Best Practices](https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html)
- [Jinja2 Template Documentation](https://jinja.palletsprojects.com/)

## Running in Docker

### Using Docker Compose (Easiest)

```bash
# Build and start the container
docker-compose up -d

# Access the container
docker-compose exec ansible-training /bin/bash

# Inside container, run the training
./setup-and-run.sh
```

### Using Docker directly

```bash
# Build the image
docker build -t ansible-training .

# Run the container
docker run -it ansible-training /bin/bash

# Inside container, run the training
./setup-and-run.sh
```

## Running in Jenkins

The included `Jenkinsfile` automatically:
1. Checks if Ansible is installed
2. Installs prerequisites if needed
3. Verifies the setup
4. Runs all 6 training lessons
5. Displays results

**To use in Jenkins:**

1. Create a new Pipeline job
2. Point it to this repository
3. Jenkins will automatically use the included `Jenkinsfile`
4. The pipeline will handle installation and setup automatically

**Or use this simplified Jenkinsfile:**

```groovy
pipeline {
    agent any
    stages {
        stage('Complete Training') {
            steps {
                sh 'chmod +x setup-and-run.sh'
                sh './setup-and-run.sh'
            }
        }
    }
}
```

The training will work in any Jenkins agent with basic Linux and sudo access.

## Questions or Issues?

If you encounter any problems or have questions:
1. Review the lesson comments in the YAML files
2. Check the troubleshooting section above
3. Run with verbose output (`-vvv`) to see detailed information
4. Consult the official Ansible documentation

Happy Learning! 🚀
