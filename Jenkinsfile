pipeline {
    agent { label 'automation' }
    stages {
        stage ('build') {
            steps {
                bash """
                #!/bin/bash
                # These packages should already be installed in the agent
                # apt install python3 python3-pip python3-venv -y
                python3 -m venv ./venv
                source $WORKSPACE/venv/bin/activate
                pip install pipenv
                pipenv install -d --system --ignore-pipfile
                deactivate
                """
            }
        }
    }
}