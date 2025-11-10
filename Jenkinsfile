pipeline {
    agent any

    environment {
        ANSIBLE_FORCE_COLOR = 'true'
    }

    stages {
        stage('Setup Verification') {
            steps {
                echo 'Verifying Ansible setup...'
                sh '''
                    chmod +x verify-setup.sh
                    ./verify-setup.sh
                '''
            }
        }

        stage('Lesson 1: Basic Operations') {
            steps {
                echo 'Running Lesson 1: Basic Ansible Operations'
                sh 'ansible-playbook 01-basic-playbook.yml'
            }
        }

        stage('Lesson 2: File Operations') {
            steps {
                echo 'Running Lesson 2: File and Directory Management'
                sh 'ansible-playbook 02-file-operations.yml'
            }
        }

        stage('Lesson 3: Variables and Facts') {
            steps {
                echo 'Running Lesson 3: Variables and Facts'
                sh 'ansible-playbook 03-variables-and-facts.yml'
            }
        }

        stage('Lesson 4: Templates') {
            steps {
                echo 'Running Lesson 4: Templates with Jinja2'
                sh 'ansible-playbook 04-templates.yml'
            }
        }

        stage('Lesson 5: Handlers') {
            steps {
                echo 'Running Lesson 5: Handlers'
                sh 'ansible-playbook 05-handlers.yml'
            }
        }

        stage('Lesson 6: Comprehensive Example') {
            steps {
                echo 'Running Lesson 6: Comprehensive Example'
                sh 'ansible-playbook 06-comprehensive-example.yml'
            }
        }

        stage('Verify Results') {
            steps {
                echo 'Verifying created artifacts...'
                sh '''
                    echo "Checking created directories..."
                    ls -la /tmp/ansible-training/ || true
                    ls -la /tmp/ansible-files-demo/ || true
                    ls -la /tmp/training-app/ || true

                    echo ""
                    echo "Displaying deployment report..."
                    cat /tmp/training-app/DEPLOYMENT_REPORT.txt || true
                '''
            }
        }
    }

    post {
        success {
            echo 'All Ansible training lessons completed successfully!'
        }
        failure {
            echo 'Some lessons failed. Please check the logs.'
        }
        always {
            echo 'Ansible training pipeline finished.'
        }
    }
}
