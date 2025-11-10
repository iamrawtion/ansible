# How to Test in jenkins/jenkins Container

## Quick Test on Your Machine

### Step 1: Run the jenkins/jenkins container

```bash
docker run -it --rm \
  -v $(pwd):/ansible-training \
  -w /ansible-training \
  jenkins/jenkins:lts \
  /bin/bash
```

### Step 2: Inside the container, run the test script

```bash
./test-in-jenkins-container.sh
```

This will check:
- Python availability
- pip availability
- sudo availability
- Write permissions
- pip install capability

### Step 3: Based on the test results, install Ansible

If test says "Use pip-only installation":
```bash
./install-ansible-only.sh
```

### Step 4: Run the training

```bash
./run-all-tests.sh
```

## Full Test Script

Here's a complete test you can run:

```bash
# On your host machine
cd /path/to/ansible-training

# Start jenkins/jenkins container
docker run -it --rm \
  -v $(pwd):/ansible-training \
  -w /ansible-training \
  jenkins/jenkins:lts \
  /bin/bash -c '
    echo "=== Environment Check ==="
    whoami
    id
    python3 --version
    pip3 --version || python3 -m pip --version

    echo ""
    echo "=== Testing Installation ==="
    python3 -m pip install --user ansible
    export PATH="$HOME/.local/bin:$PATH"
    ansible --version

    echo ""
    echo "=== Running Training ==="
    ./run-all-tests.sh
  '
```

## Test Individual Scripts

### Test 1: install-ansible-only.sh

```bash
docker run -it --rm \
  -v $(pwd):/ansible-training \
  -w /ansible-training \
  jenkins/jenkins:lts \
  /bin/bash -c './install-ansible-only.sh && ansible --version'
```

### Test 2: JENKINS_QUICKSTART.sh

```bash
docker run -it --rm \
  -v $(pwd):/ansible-training \
  -w /ansible-training \
  jenkins/jenkins:lts \
  /bin/bash -c './JENKINS_QUICKSTART.sh'
```

### Test 3: Direct pip install

```bash
docker run -it --rm \
  -v $(pwd):/ansible-training \
  -w /ansible-training \
  jenkins/jenkins:lts \
  /bin/bash -c '
    python3 -m pip install --user ansible
    export PATH="$HOME/.local/bin:$PATH"
    ansible --version
    ./run-all-tests.sh
  '
```

## Common Issues in jenkins/jenkins Container

### Issue 1: pip not in PATH

**Symptom:** `pip3: command not found`

**Solution:** Use `python3 -m pip` instead:
```bash
python3 -m pip install --user ansible
```

### Issue 2: ansible not found after installation

**Symptom:** Ansible installs but `ansible: command not found`

**Solution:** Add to PATH:
```bash
export PATH="$HOME/.local/bin:$PATH"
ansible --version
```

### Issue 3: Permission denied on /tmp

**Symptom:** Cannot write to /tmp directories

**Solution:** The playbooks should work as the jenkins user already has access to /tmp. If not, check:
```bash
ls -ld /tmp
# Should show: drwxrwxrwt
```

## What the jenkins/jenkins Image Has

The official `jenkins/jenkins` image includes:

✅ **Python 3** - Pre-installed
✅ **pip** - Available via `python3 -m pip`
✅ **Java** - For Jenkins
✅ **git** - Pre-installed
✅ **/tmp** - Writable by all users
✅ **User home** - jenkins user has a home directory

❌ **sudo** - NOT installed by default
❌ **System packages** - Cannot install without root

## Expected Test Results

When you run `./test-in-jenkins-container.sh`, you should see:

```
✓ Python: Available
✓ pip: Available
⚠ sudo: Not available (OK - not needed)
✓ HOME: Writable
✓ pip can install packages

RECOMMENDATION:
Use pip-only installation:
  ./install-ansible-only.sh
```

## Debugging

If something fails, run this debug script:

```bash
docker run -it --rm \
  -v $(pwd):/ansible-training \
  -w /ansible-training \
  jenkins/jenkins:lts \
  /bin/bash -c '
    echo "=== User Info ==="
    whoami
    id
    echo $HOME
    echo $PATH

    echo ""
    echo "=== Python Info ==="
    which python3
    python3 --version
    python3 -c "import sys; print(sys.executable)"

    echo ""
    echo "=== pip Info ==="
    which pip3 || echo "pip3 not in PATH"
    python3 -m pip --version
    python3 -m pip list --user

    echo ""
    echo "=== Directory Permissions ==="
    ls -ld $HOME
    ls -ld $HOME/.local 2>/dev/null || echo ".local does not exist yet"
    ls -ld /tmp

    echo ""
    echo "=== Test Write ==="
    touch $HOME/test.txt && echo "✓ Can write to HOME" || echo "✗ Cannot write to HOME"
    touch /tmp/test.txt && echo "✓ Can write to /tmp" || echo "✗ Cannot write to /tmp"
  '
```

## Final Test - Complete Pipeline

```bash
docker run -it --rm \
  -v $(pwd):/ansible-training \
  -w /ansible-training \
  jenkins/jenkins:lts \
  /bin/bash << 'SCRIPT'

set -e

echo "========================================="
echo "Complete Ansible Training Test"
echo "========================================="

# Install Ansible
echo "Installing Ansible..."
python3 -m pip install --user ansible

# Update PATH
export PATH="$HOME/.local/bin:$PATH"

# Verify
echo ""
echo "Verifying Ansible installation..."
ansible --version

# Run all training
echo ""
echo "Running all training lessons..."
./run-all-tests.sh

echo ""
echo "========================================="
echo "SUCCESS! All tests passed!"
echo "========================================="

SCRIPT
```

Save this and run it to test everything end-to-end.

## Share the Error

Please run one of these tests and share:
1. The complete error output
2. Which test you ran
3. At what point it failed

Then I can provide the exact fix for your specific issue!
