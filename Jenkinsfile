pipeline {
    agent { label 'automation' }
    stages {
        stage ('build') {
            steps {
                // These packages should already be installed in the agent
                // apt install python3 python3-pip python3-venv -y
                sh "pip3 install -r requirements.txt"
            }
        }
    }
}