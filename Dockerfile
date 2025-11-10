# Dockerfile for Ansible Training Environment
# This creates a container ready for running Ansible training lessons

FROM ubuntu:22.04

# Avoid interactive prompts during build
ENV DEBIAN_FRONTEND=noninteractive

# Set working directory
WORKDIR /ansible-training

# Install basic utilities (Ansible and Python will be installed by our scripts)
RUN apt-get update && \
    apt-get install -y \
    curl \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Copy all training files
COPY . /ansible-training/

# Make scripts executable
RUN chmod +x *.sh

# Create a non-root user for running Ansible
RUN useradd -m -s /bin/bash ansible && \
    echo "ansible ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Switch to ansible user
USER ansible
WORKDIR /ansible-training

# Set environment variables
ENV PATH="/home/ansible/.local/bin:${PATH}"
ENV ANSIBLE_FORCE_COLOR=true

# Display instructions on container start
CMD ["/bin/bash", "-c", "echo '\n===========================================\nAnsible Training Environment\n===========================================\n\nWelcome! This container is ready for Ansible training.\n\nQuick Start:\n  ./setup-and-run.sh       # Automated setup and run\n  ./install-prerequisites.sh  # Install Ansible\n  ./run-all-tests.sh       # Run all lessons\n\nOr run individual lessons:\n  ./run-single-lesson.sh 1\n\nFor help, see:\n  cat README.md\n\n===========================================\n' && /bin/bash"]
