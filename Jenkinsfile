pipeline {
    options { buildDiscarder(logRotator(numToKeepStr: '5')) }
    agent { label 'automation' }
    stages {
        stage ('Build') {
            steps {
                // These packages should already be installed in the agent
                // apt install python3 python3-pip python3-venv -y
                sh "pip3 install -r requirements.txt"
            }
        }

        stage ('Unit Tests') {
            steps {
                sh "python3 test.py"
            }
        }

        stage ('Static Code Analysis') {
            steps {
                echo "Sonarqube"
            }
        }
    }
}