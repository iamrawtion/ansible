# THE PROBLEM WITH jenkins/jenkins:lts

## The Issue

**The `jenkins/jenkins:lts` image does NOT include Python!**

That's why you're getting:
```
Checking Python3... ✗ Not found
ERROR: Python3 is required but not installed.
```

## The Solution

You have **3 options**:

---

## Option 1: Use Custom Dockerfile (RECOMMENDED)

Create a Jenkins image with Python pre-installed.

### Step 1: Create the Dockerfile

I've created `Dockerfile.jenkins` for you. Build it:

```bash
docker build -f Dockerfile.jenkins -t jenkins-with-python .
```

### Step 2: Run your custom Jenkins

```bash
docker run -d -p 8080:8080 -p 50000:50000 \
  -v jenkins_home:/var/jenkins_home \
  --name jenkins \
  jenkins-with-python
```

### Step 3: Use it in your pipeline

Your Jenkinsfile will now work because Python is installed!

---

## Option 2: Install Python in Jenkins Startup

Add Python installation to your Jenkins startup script.

### Create a startup script:

```bash
# install-python.sh
#!/bin/bash
apt-get update
apt-get install -y python3 python3-pip
pip3 install ansible
```

### Mount and run it:

```bash
docker run -d -p 8080:8080 \
  -v $(pwd)/install-python.sh:/usr/local/bin/install-python.sh \
  --entrypoint /bin/bash \
  jenkins/jenkins:lts \
  -c "apt-get update && apt-get install -y python3 python3-pip && /usr/local/bin/jenkins.sh"
```

---

## Option 3: Use Different Base Image

Some Jenkins images include Python:

### Try jenkins/jenkins:lts-jdk11

```bash
docker run -it --rm jenkins/jenkins:lts-jdk11 python3 --version
```

### Or use a generic Ubuntu + Jenkins approach

```dockerfile
FROM ubuntu:22.04

# Install Jenkins and Python
RUN apt-get update && \
    apt-get install -y \
    openjdk-11-jdk \
    python3 \
    python3-pip \
    wget

# Install Jenkins
RUN wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | apt-key add - && \
    sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list' && \
    apt-get update && \
    apt-get install -y jenkins

# Install Ansible
RUN pip3 install ansible

CMD ["java", "-jar", "/usr/share/jenkins/jenkins.war"]
```

---

## Quick Test

### Check if your Jenkins has Python:

```bash
docker run -it --rm jenkins/jenkins:lts python3 --version
```

**Expected:** `bash: python3: command not found` ← This confirms the problem

### Check with custom image:

```bash
docker build -f Dockerfile.jenkins -t jenkins-with-python .
docker run -it --rm jenkins-with-python python3 --version
```

**Expected:** `Python 3.x.x` ← This works!

---

## For Your Current Setup

If you're already running jenkins/jenkins:lts and can't change it:

### 1. Check what's available:

```bash
./check-jenkins-python.sh
```

### 2. If Python is NOT available:

You **must** either:
- Use Option 1 (Custom Dockerfile) - BEST
- Use Option 2 (Install Python at startup)
- Use Option 3 (Different base image)

You **cannot** run Ansible training without Python!

---

## Complete Working Example

### 1. Build custom Jenkins image:

```bash
cd /path/to/ansible-training
docker build -f Dockerfile.jenkins -t my-jenkins .
```

### 2. Run Jenkins:

```bash
docker run -d \
  -p 8080:8080 \
  -p 50000:50000 \
  -v jenkins_home:/var/jenkins_home \
  -v $(pwd):/ansible-training \
  --name my-jenkins \
  my-jenkins
```

### 3. Access Jenkins:

```
http://localhost:8080
```

### 4. Create pipeline job with this:

```groovy
pipeline {
    agent any

    environment {
        PATH = "/var/jenkins_home/.local/bin:$PATH"
    }

    stages {
        stage('Verify Python') {
            steps {
                sh 'python3 --version'
                sh 'ansible --version'
            }
        }

        stage('Run Training') {
            steps {
                dir('/ansible-training') {
                    sh './run-all-tests.sh'
                }
            }
        }
    }
}
```

### 5. Run the pipeline

It will work because Python and Ansible are pre-installed!

---

## Summary

| Approach | Pros | Cons |
|----------|------|------|
| Custom Dockerfile | ✓ Clean, reusable<br>✓ Python pre-installed<br>✓ Fast builds | Requires building image |
| Startup script | ✓ No image build | ✗ Slow (installs every time)<br>✗ Requires root access |
| Different base | ✓ May already have Python | ✗ Limited options<br>✗ May not be official Jenkins |

**Recommendation:** Use **Option 1 (Custom Dockerfile)** - I've created `Dockerfile.jenkins` for you!

---

## Files Created for You

1. **Dockerfile.jenkins** - Jenkins + Python + Ansible (USE THIS!)
2. **check-jenkins-python.sh** - Check if Python is available
3. **install-ansible-only.sh** - Updated to handle missing Python better
4. **This file** - Complete solution guide

---

## Bottom Line

The `jenkins/jenkins:lts` image is **just Jenkins + Java**. No Python.

**You need:** Jenkins + Java + Python

**Solution:** Build from `Dockerfile.jenkins`

```bash
docker build -f Dockerfile.jenkins -t jenkins-with-python .
docker run -p 8080:8080 jenkins-with-python
```

Done! 🚀
