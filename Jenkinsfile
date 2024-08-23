pipeline {
    agent any

    environment {
        DOCKER_IMAGE_NAME = ""
        DEPLOY_PORT = ""
        ENV_FILE = ""
    }

    stages {
        stage('Determine Branch') {
            steps {
                script {
                    try {
                        def branchName = sh(
                            script: 'git rev-parse --abbrev-ref HEAD',
                            returnStdout: true
                        ).trim()

                        if (branchName == 'dev') {
                            env.DOCKER_IMAGE_NAME = "hms-backend-laravel-dev"
                            env.DEPLOY_PORT = "8001"
                            env.ENV_FILE = ".env.dev"
                        } else if (branchName == 'uat') {
                            env.DOCKER_IMAGE_NAME = "hms-backend-laravel-uat"
                            env.DEPLOY_PORT = "8002"
                            env.ENV_FILE = ".env.uat"
                        } else if (branchName == 'prod') {
                            env.DOCKER_IMAGE_NAME = "hms-backend-laravel-prod"
                            env.DEPLOY_PORT = "8003"
                            env.ENV_FILE = ".env.prod"
                        } else {
                            error("Unknown branch for deployment!")
                        }

                        echo "Deploying branch: ${branchName}"
                        echo "Using Docker image: ${env.DOCKER_IMAGE_NAME}"
                        echo "Deploying on port: ${env.DEPLOY_PORT}"
                    } catch (Exception e) {
                        echo "Failed to determine branch: ${e.message}"
                        error("Branch determination failed")
                    }
                }
            }
        }

        stage('Clone repository') {
            steps {
                script {
                    git branch: "${env.BRANCH_NAME}", url: 'https://github.com/hms-org/hms-backend-laravel.git'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${env.DOCKER_IMAGE_NAME}:${env.BUILD_ID}")
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
                    sh "docker stop ${env.DOCKER_IMAGE_NAME} || true"
                    sh "docker rm ${env.DOCKER_IMAGE_NAME} || true"
                    sh "docker rmi ${env.DOCKER_IMAGE_NAME} || true"

                    // Pass environment file to Docker
                    sh """
                    docker run -d --name ${env.DOCKER_IMAGE_NAME} \
                    -p ${env.DEPLOY_PORT}:80 \
                    --env-file=${env.ENV_FILE} \
                    ${env.DOCKER_IMAGE_NAME}:${env.BUILD_ID}
                    """
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