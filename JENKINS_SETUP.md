# Jenkins Setup Guide for Ansible Training

This guide helps you run the Ansible training in various Jenkins Docker container configurations.

## Quick Start

### Option 1: Using the Jenkinsfile (Recommended)

The included `Jenkinsfile` handles everything automatically:

```groovy
// Your Jenkinsfile is already configured
// Just point Jenkins to this repository
```

### Option 2: Simple Pipeline Script

```groovy
pipeline {
    agent any
    stages {
        stage('Run Ansible Training') {
            steps {
                sh '''
                    cd ansible
                    chmod +x *.sh
                    ./install-prerequisites.sh --yes
                    ./run-all-tests.sh
                '''
            }
        }
    }
}
```

## Common Jenkins Docker Container Scenarios

### Scenario 1: Running as Root (No sudo needed)

If your Jenkins container runs as root, the script automatically detects this:

```bash
# The script will show:
Running as root
```

Everything works automatically. No sudo required.

### Scenario 2: Running as jenkins User WITH sudo

If your container has sudo installed and configured:

```bash
# The script will show:
Will use sudo for system operations
```

Commands will use sudo automatically.

### Scenario 3: Running as jenkins User WITHOUT sudo (Your Case)

If sudo is not installed in the container:

```bash
# The script will show:
Warning: sudo not found, attempting without sudo
```

**Two solutions:**

#### Solution A: Install sudo first (Recommended)

Add this to your Jenkins Docker container or pipeline:

```bash
# In Dockerfile
RUN apt-get update && apt-get install -y sudo

# Or in Jenkins pipeline (if running as root)
sh 'apt-get update && apt-get install -y sudo'
```

#### Solution B: Run the whole pipeline as root

Update your Jenkinsfile or Docker container to run as root:

```groovy
pipeline {
    agent {
        docker {
            image 'your-image'
            args '--user root'  // Run as root
        }
    }
    stages {
        // ... your stages
    }
}
```

#### Solution C: Pre-install Python and Ansible in Docker Image

Create a custom Docker image with Ansible pre-installed:

```dockerfile
FROM jenkins/jenkins:lts

USER root

# Install Python and Ansible
RUN apt-get update && \
    apt-get install -y python3 python3-pip && \
    pip3 install ansible && \
    apt-get clean

USER jenkins
```

Then in Jenkins, the training scripts will detect Ansible is already installed.

## Recommended Jenkins Docker Setup

### Dockerfile for Jenkins with Ansible Support

**IMPORTANT:** The standard `jenkins/jenkins:lts` image does **NOT** include Python!

You need to create a custom Dockerfile:

```dockerfile
FROM jenkins/jenkins:lts

USER root

# Install Python and dependencies
RUN apt-get update && \
    apt-get install -y \
    python3 \
    python3-pip \
    python3-venv \
    sudo \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Configure sudo for jenkins user (optional)
RUN echo "jenkins ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Install Ansible system-wide
RUN pip3 install ansible

USER jenkins

# Add pip binaries to PATH
ENV PATH="/var/jenkins_home/.local/bin:${PATH}"
```

Build and use:

```bash
docker build -t jenkins-with-python .
docker run -p 8080:8080 jenkins-with-python
```

Build and run:

```bash
docker build -t jenkins-ansible .
docker run -p 8080:8080 jenkins-ansible
```

## Troubleshooting Jenkins Issues

### Issue: "sudo: command not found"

**Cause:** The Jenkins Docker container doesn't have sudo installed.

**Solutions:**

1. **Add sudo to your Docker image:**
   ```dockerfile
   RUN apt-get update && apt-get install -y sudo
   ```

2. **Run as root in Jenkins:**
   ```groovy
   agent {
       docker {
           image 'your-image'
           args '--user root'
       }
   }
   ```

3. **Pre-install Ansible in the Docker image** (see Dockerfile above)

### Issue: "Permission denied" when installing packages

**Cause:** Running as non-root user without sudo.

**Solution:** Use one of the solutions from "sudo: command not found" above.

### Issue: Python/Ansible already installed but not found

**Cause:** PATH not configured correctly.

**Solution:** Add to Jenkinsfile:

```groovy
environment {
    PATH = "$HOME/.local/bin:/usr/local/bin:$PATH"
}
```

### Issue: Installation takes too long

**Cause:** Installing packages every time the pipeline runs.

**Solution:** Pre-install in Docker image:

```dockerfile
FROM jenkins/jenkins:lts
USER root
RUN apt-get update && \
    apt-get install -y python3 python3-pip && \
    pip3 install ansible
USER jenkins
```

## Complete Working Examples

### Example 1: Minimal Jenkinsfile (Assuming Ansible Installed)

```groovy
pipeline {
    agent any
    stages {
        stage('Run Training') {
            steps {
                sh './run-all-tests.sh'
            }
        }
    }
}
```

### Example 2: Full Jenkinsfile with Installation

```groovy
pipeline {
    agent any

    environment {
        PATH = "$HOME/.local/bin:$PATH"
        ANSIBLE_FORCE_COLOR = 'true'
    }

    stages {
        stage('Setup') {
            steps {
                sh '''
                    chmod +x install-prerequisites.sh
                    ./install-prerequisites.sh --yes
                '''
            }
        }

        stage('Verify') {
            steps {
                sh '''
                    ansible --version
                    python3 --version
                '''
            }
        }

        stage('Run Training') {
            steps {
                sh './run-all-tests.sh'
            }
        }
    }
}
```

### Example 3: Multi-Agent Setup

```groovy
pipeline {
    agent none

    stages {
        stage('Run on Debian') {
            agent {
                docker {
                    image 'debian:latest'
                    args '--user root'
                }
            }
            steps {
                sh '''
                    ./install-prerequisites.sh --yes
                    ./run-all-tests.sh
                '''
            }
        }

        stage('Run on Ubuntu') {
            agent {
                docker { image 'ubuntu:22.04' }
            }
            steps {
                sh '''
                    ./install-prerequisites.sh --yes
                    ./run-all-tests.sh
                '''
            }
        }
    }
}
```

## Best Practices for Jenkins

1. **Cache Dependencies**: Pre-install Ansible in Docker image to speed up builds

2. **Use Specific Docker Images**: Don't use `latest` tags in production
   ```groovy
   agent { docker { image 'ubuntu:22.04' } }
   ```

3. **Set Timeouts**: Add timeouts to prevent hanging builds
   ```groovy
   options {
       timeout(time: 30, unit: 'MINUTES')
   }
   ```

4. **Archive Results**: Save training artifacts
   ```groovy
   post {
       always {
           sh 'tar -czf training-results.tar.gz /tmp/ansible-* /tmp/training-app/'
           archiveArtifacts artifacts: 'training-results.tar.gz'
       }
   }
   ```

5. **Use Non-Interactive Mode**: Always use `--yes` flag in automation
   ```bash
   ./install-prerequisites.sh --yes
   ```

## Quick Fix for Your Current Setup

If you're getting the "sudo: command not found" error right now:

### Option A: Add this at the start of your pipeline

```groovy
stage('Install sudo') {
    steps {
        sh '''
            # Only works if running as root
            apt-get update && apt-get install -y sudo
        '''
    }
}
```

### Option B: Modify your Jenkins Docker run command

```bash
docker run -u root jenkins/jenkins:lts
```

### Option C: Use the workspace directly

If Python is already in your container:

```bash
# Check if Python and pip are already there
python3 --version && pip3 --version

# If yes, just install Ansible with pip
pip3 install --user ansible

# Then run training
./run-all-tests.sh
```

## Minimal Requirements for Jenkins Container

For the training to work, you need ONE of:

1. **Root user** (no sudo needed)
2. **Non-root user + sudo installed**
3. **Pre-installed Python + Ansible** (no system packages needed)

Choose the approach that fits your Jenkins security requirements!
