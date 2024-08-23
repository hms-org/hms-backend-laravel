pipeline {
    agent any

    environment {
        DOCKER_IMAGE_NAME = ""
        DEPLOY_PORT = ""
        ENV_FILE = ""
    }

    stages {
        stage('Prepare') {
            steps {
                script {
                    if (env.BRANCH_NAME == 'dev') {
                        DOCKER_IMAGE_NAME = "hms-backend-laravel-dev"
                        DEPLOY_PORT = "8001"
                        ENV_FILE = ".env.dev"
                    } else if (env.BRANCH_NAME == 'uat') {
                        DOCKER_IMAGE_NAME = "hms-backend-laravel-uat"
                        DEPLOY_PORT = "8002"
                        ENV_FILE = ".env.uat"
                    } else if (env.BRANCH_NAME == 'prod') {
                        DOCKER_IMAGE_NAME = "hms-backend-laravel-prod"
                        DEPLOY_PORT = "8003"
                        ENV_FILE = ".env.prod"
                    } else {
                        error("Unknown branch for deployment!")
                    }

                    echo "Deploying branch: ${env.BRANCH_NAME}"
                    echo "Using Docker image: ${DOCKER_IMAGE_NAME}"
                    echo "Deploying on port: ${DEPLOY_PORT}"
                }
            }
        }

        stage('Clone repository') {
            steps {
                git branch: "${env.BRANCH_NAME}", url: 'https://github.com/hms-org/hms-backend-laravel.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${DOCKER_IMAGE_NAME}:${env.BUILD_ID}")
                }
            }
        }

        stage('Preparation Environment') {
            steps {
                script {
                    sh "ls -la"
                    sh "pwd"
                }
            }
        }

        stage('Deploy to Server') {
            steps {
                script {
                    sh "docker stop ${DOCKER_IMAGE_NAME} || true"
                    sh "docker rm ${DOCKER_IMAGE_NAME} || true"
                    sh "docker rmi ${DOCKER_IMAGE_NAME} || true"

                    // Pass environment file to Docker
                    sh """
                    docker run -d --name ${DOCKER_IMAGE_NAME} \
                    -p ${DEPLOY_PORT}:80 \
                    --env-file=${ENV_FILE} \
                    ${DOCKER_IMAGE_NAME}:${env.BUILD_ID}
                    """

                    sh """docker exec -it ${DOCKER_IMAGE_NAME}"""
                    sh """ls"""
                    sh """pwd"""
                }
            }
        }
    }
    
    post {
        success {
            echo 'Build and deploy successful!'
        }
        failure {
            echo 'Build or deploy failed.'
        }
    }
}