pipeline {
    agent { label 'automation' }
    stages {
        stage ('build') {
            steps {
                // These packages should already be installed in the agent
                // apt install python3 python3-pip python3-venv -y
                sh """
                pip3 install pipenv
                pipenv lock
                PIP_USER=1 PIP_IGNORE_INSTALLED=1 pipenv install -d --system --ignore-pipfile
                """
            }
        }
    }
}