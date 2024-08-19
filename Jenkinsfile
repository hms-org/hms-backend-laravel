pipeline {
    agent any
    
    stages {
        stage('Clone repository') {
            steps {
                // Clone the repository
                git branch: 'dev', url: 'https://github.com/hms-org/hms-backend-laravel.git'
            }
        }
        
        stage('Install dependencies') {
            steps {
                // Install Laravel dependencies
                sh 'composer install'
                sh 'cp .env.example .env'
                sh 'php artisan key:generate'
            }
        }

        stage('Build Docker Image') {
            steps {
                // Build Docker image
                script {
                    def appImage = docker.build("hms-backend-laravel:${env.BUILD_ID}")
                }
            }
        }

        stage('Run Tests') {
            steps {
                // Run Laravel tests
                sh 'php artisan test'
            }
        }

        stage('Deploy to Server') {
            steps {
                // Stop the old container
                sh 'docker stop laravel_container || true'
                sh 'docker rm laravel_container || true'
                
                // Run the new container
                sh '''
                docker run -d --name hms_backend_laravel \
                -p 8000:80 \
                hms-backend-laravel:${env.BUILD_ID}
                '''
            }
        }
    }
}
