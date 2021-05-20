pipeline {
    agent { label 'automation' }
    stages {
        stage ('build') {
            steps {
                sh """
                #!/bin/bash
                sudo apt install python3 python3-pip python3-venv
                python3 -m venv ./venv
                source ./venv/bin/activate
                pip install pipenv
                pipenv install -d --system --ignore-pipfile
                deactivate
                """
            }
        }
    }
}