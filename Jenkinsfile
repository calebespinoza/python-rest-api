pipeline {
    options { buildDiscarder(logRotator(numToKeepStr: '5')) }
    agent { label 'automation' }
    environment {
        PROJECT_NAME = "python-rest-api"
        PRIVATE_REGISTRY_URL = "192.168.90.7:8083"
        TAG = "$BUILD_NUMBER-stg"
        PROD_TAG = "$BUILD_NUMBER-prod"
        NEXUS_CREDENTIAL = credentials("nexus-credential")
    }

    stages {
        stage ('Build') {
            steps {
                // These packages should already be installed in the agent
                // apt install python3 python3-pip python3-venv -y
                sh "pip3 install -r requirements.txt"
            }
        }

        stage ('Unit Tests and Coverage') {
            steps {
                //sh "python3 test.py"
                sh "coverage run -m unittest test.py"
            }
        }

        stage ('Static Code Analysis') {
            steps {
                script {
                    def scannerHome = tool 'sonarqube-scanner-at'
                    def scannerParameters = "-Dsonar.projectName=$PROJECT_NAME " + 
                        "-Dsonar.projectKey=$PROJECT_NAME -Dsonar.sources=. -Dsonar.python.coverage.reportPaths=coverage.xml"
                    withSonarQubeEnv('sonarqube-automation') {
                        sh "${scannerHome}/bin/sonar-scanner ${scannerParameters}"
                    }
                }
            }
        }

        stage ('Image Build') {
            when { branch 'dev' }
            steps {
                sh "docker build -t $PRIVATE_REGISTRY_URL/$PROJECT_NAME:$TAG ."
            }
            post {
                failure {
                    script {
                        sh "docker rmi \$(docker images --filter dangling=true -q)"
                    }
                }
            }
        }

        stage ("Promote Image") {
            when { branch 'dev' }
            steps {
                sh "echo $NEXUS_CREDENTIAL_PSW | docker login -u $NEXUS_CREDENTIAL_USR --password-stdin $PRIVATE_REGISTRY_URL"
                sh "docker push $PRIVATE_REGISTRY_URL/$PROJECT_NAME:$TAG"
            }
            post {
                always {
                    script {
                        sh "docker rmi -f $PRIVATE_REGISTRY_URL/$PROJECT_NAME:$TAG"
                        sh "docker logout $PRIVATE_REGISTRY_URL"
                    }
                }
            }
        }

        stage ('Deploy to Staging') {
            when { branch 'dev' }
            steps {
                script {
                    build job: 'python-rest-api-staging', 
                    parameters: [
                        string(name: 'PRIVATE_REGISTRY_URL_PARAM', value: "$PRIVATE_REGISTRY_URL"), 
                        string(name: 'PROJECT_NAME_PARAM', value: "$PROJECT_NAME"), 
                        string(name: 'TAG_PARAM', value: "$TAG"), 
                        string(name: 'RANGE_PORTS_PARAM', value: '8003-8004')
                    ]
                }
            }
        }

        stage ('Deploy to Production') {
            when { branch 'main' }
            environment {
                RANGE_PORTS = "8001-8002"
                TAG = "$PROD_TAG"
            }
            steps {
                sh "echo $NEXUS_CREDENTIAL_PSW | docker login -u $NEXUS_CREDENTIAL_USR --password-stdin $PRIVATE_REGISTRY_URL"
                sh "docker-compose up -d --scale api=2"
                sleep 15
                sh "curl -I http://localhost:8001 --silent | grep 200"
                sh "curl -I http://localhost:8002 --silent | grep 200"
            }
            post {
                always {
                    script {
                        // comment 2
                        sh "docker logout $PRIVATE_REGISTRY_URL"
                    }
                }
            }
        }
    }
}