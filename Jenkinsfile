pipeline {
    options { buildDiscarder(logRotator(numToKeepStr: '5')) }
    agent { label 'automation' }
    environment {
        PROJECT_NAME = "python-rest-api"
        PRIVATE_REGISTRY_URL = "192.168.90.7:8083"
    }

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
                script {
                    def scannerHome = tool 'sonarqube-scanner-at'
                    def scannerParameters = "-Dsonar.projectName=$PROJECT_NAME " + 
                        "-Dsonar.projectKey=$PROJECT_NAME -Dsonar.sources=."
                    withSonarQubeEnv('sonarqube-automation') {
                        sh "${scannerHome}/bin/sonar-scanner ${scannerParameters}"
                    }
                }
            }
        }

        stage ('Image Build') {
            steps {
                sh "docker build -t $PRIVATE_REGISTRY_URL/$PROJECT_NAME:$BUILD_NUMBER ."
            }
        }
        post {
            failure {
                sh "docker rmi \$(docker images --filter dangling=true -q)"
            }
        }

        stage ("Promote Image") {
            environment {
                NEXUS_CREDENTIAL = credentials("nexus-credential")
            }
            steps {
                sh "echo $NEXUS_CREDENTIAL_PWD | docker login -u $NEXUS_CREDENTIAL_USR --password-stdin $PRIVATE_REGISTRY_URL"
            }
        }
        post {
            success {
                sh "docker rmi -f $PRIVATE_REGISTRY_URL/$PROJECT_NAME:$BUILD_NUMBER"
            }
        }
    }
}