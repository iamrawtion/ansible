FROM ubuntu:22.04

# Install Java 17 (required for Jenkins)
RUN apt-get update && \
    apt-get install -y openjdk-17-jdk wget curl && \
    rm -rf /var/lib/apt/lists/*

# Add Jenkins repository and install Jenkins
RUN wget -O /usr/share/keyrings/jenkins-keyring.asc \
    https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key && \
    echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
    https://pkg.jenkins.io/debian-stable binary/ | tee \
    /etc/apt/sources.list.d/jenkins.list > /dev/null && \
    apt-get update && \
    apt-get install -y jenkins && \
    rm -rf /var/lib/apt/lists/*

# Expose Jenkins port
EXPOSE 8080

# Start Jenkins
CMD ["java", "-jar", "/usr/share/java/jenkins.war"]
