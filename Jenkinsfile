pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('c9038cd8-a265-4231-ac62-0c86d5b7194c')
        GITHUB_CREDENTIALS = credentials('a34e62e9-4cc1-4cb0-a62f-80360737366d')
    }

    stages {
        stage('Checkout') {
            steps {
                git credentialsId: "${GITHUB_CREDENTIALS}", url: 'https://github.com/Nazmul-9260/test-pipe.git', branch: 'main'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker image prune -f'  // Old unused images clean
                sh 'docker-compose -f docker-compose.yml down --volumes --remove-orphans'
                sh 'docker-compose -f docker-compose.yml build'
            }
        }

        stage('Run Containers') {
            steps {
                sh 'docker-compose -f docker-compose.yml up -d'
            }
        }

        stage('Laravel Cache Clear') {
            steps {
                // container নাম adjust করুন আপনার environment অনুযায়ী
                sh 'docker exec laravel_nginx php artisan config:clear'
                sh 'docker exec laravel_nginx php artisan route:clear'
                sh 'docker exec laravel_nginx php artisan view:clear'
                sh 'docker exec laravel_nginx composer install --no-interaction --prefer-dist --optimize-autoloader'
            }
        }
    }

    post {
        always {
            echo 'Cleaning up...'
            sh 'docker image prune -a -f'
            sh 'docker container prune -f'
        }
    }
}
