pipeline {
    agent { label 'automation' }
    stages {
        stage ('build') {
            steps {
                // These packages should already be installed in the agent
                // apt install python3 python3-pip python3-venv -y
                sh "bash ./script.sh"
                //sh """
                //#!/bin/bash
                //bash source $WORKSPACE/venv/bin/activate
                //pip install pipenv
                //pipenv install -d --system --ignore-pipfile
                //deactivate
                //"""
            }
        }
    }
}