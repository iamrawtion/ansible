# Ansible Training for Beginners

Welcome to the Ansible training course! This repository contains hands-on examples designed to teach you Ansible fundamentals through practical exercises.

## Prerequisites

Before starting, ensure you have:
- Ansible installed (version 2.9 or higher recommended)
- Python 3.x installed
- Access to a Linux environment (the Jenkins Docker container)

## Quick Start

### 1. Verify Your Setup

First, verify that everything is properly configured:

```bash
./verify-setup.sh
```

This script will check:
- Ansible installation
- Python installation
- Required files
- Connectivity to localhost

### 2. Run All Lessons

To run all training lessons sequentially:

```bash
./run-all-tests.sh
```

### 3. Run Individual Lessons

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
├── 01-basic-playbook.yml         # Lesson 1
├── 02-file-operations.yml        # Lesson 2
├── 03-variables-and-facts.yml    # Lesson 3
├── 04-templates.yml              # Lesson 4
├── 05-handlers.yml               # Lesson 5
├── 06-comprehensive-example.yml  # Lesson 6
├── run-all-tests.sh              # Script to run all lessons
├── run-single-lesson.sh          # Script to run individual lessons
├── verify-setup.sh               # Setup verification script
└── README.md                     # This file
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
Make sure Ansible is installed:
```bash
pip3 install ansible
# or
apt-get install ansible  # on Debian/Ubuntu
yum install ansible      # on RHEL/CentOS
```

### Permission Denied
If you get permission errors, you might need to:
- Run with sudo (for system-level operations)
- Check file permissions
- Ensure you have write access to /tmp

### Module Not Found
Update Ansible to the latest version:
```bash
pip3 install --upgrade ansible
```

### Playbook Fails
- Check syntax: `ansible-playbook <file> --syntax-check`
- Run in check mode first: `ansible-playbook <file> --check`
- Use verbose output: `ansible-playbook <file> -vvv`

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

## Running in Jenkins

To run these training materials in a Jenkins pipeline, you can use this example Jenkinsfile:

```groovy
pipeline {
    agent {
        docker {
            image 'your-ansible-docker-image'
        }
    }
    stages {
        stage('Verify Setup') {
            steps {
                sh './verify-setup.sh'
            }
        }
        stage('Run Ansible Training') {
            steps {
                sh './run-all-tests.sh'
            }
        }
    }
}
```

## Questions or Issues?

If you encounter any problems or have questions:
1. Review the lesson comments in the YAML files
2. Check the troubleshooting section above
3. Run with verbose output (`-vvv`) to see detailed information
4. Consult the official Ansible documentation

Happy Learning! 🚀
