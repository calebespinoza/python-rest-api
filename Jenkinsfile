pipeline {
    agent { label 'automation' }
    stages {
        stage ('build') {
            steps {
                // These packages should already be installed in the agent
                // apt install python3 python3-pip python3-venv -y
                sh """
                PYTHON_BIN_PATH='$(python3 -m site --user-base)/bin'
                PATH='$PATH:$PYTHON_BIN_PATH'
                pip3 install pipenv
                pipenv lock
                PIP_USER=1 PIP_IGNORE_INSTALLED=1 pipenv install -d --system --ignore-pipfile
                """
            }
        }
    }
}