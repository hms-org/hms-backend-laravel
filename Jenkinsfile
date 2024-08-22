pipeline {
    agent any

    environment {
        DOCKER_IMAGE_NAME = ""
        DEPLOY_PORT = ""
    }

    stages {
        stage('Prepare') {
            steps {
                script {
                    env.BRANCH_NAME = "dev"
                    if (env.BRANCH_NAME == 'dev') {
                        DOCKER_IMAGE_NAME = "hms-backend-laravel-dev"
                        DEPLOY_PORT = "8001"
                    } else if (env.BRANCH_NAME == 'uat') {
                        DOCKER_IMAGE_NAME = "hms-backend-laravel-uat"
                        DEPLOY_PORT = "8002"
                    } else if (env.BRANCH_NAME == 'prod') {
                        DOCKER_IMAGE_NAME = "hms-backend-laravel-prod"
                        DEPLOY_PORT = "80"
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

        stage('Run Tests') {
            steps {
                script {
                    docker.image("${DOCKER_IMAGE_NAME}:${env.BUILD_ID}").inside {
                        sh 'ls'
                        sh 'php artisan test'
                    }
                }
            }
        }

        stage('Deploy to Server') {
            steps {
                script {
                    sh "docker stop ${DOCKER_IMAGE_NAME} || true"
                    sh "docker rm ${DOCKER_IMAGE_NAME} || true"

                    sh """
                    docker run -d --name ${DOCKER_IMAGE_NAME} \
                    -p ${DEPLOY_PORT}:80 \
                    ${DOCKER_IMAGE_NAME}:${env.BUILD_ID}
                    """
                }
            }
        }

        stage('Verify Deployment') {
            steps {
                script {
                    // Example: Send an HTTP request to verify the app is running
                    sh "curl -f http://localhost:${env.DEPLOY_PORT} || (echo 'Deployment failed!' && exit 1)"
                }
            }
        }
    }
}
