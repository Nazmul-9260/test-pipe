pipeline {
    agent any

    environment {
        GIT_CRED = credentials('a34e62e9-4cc1-4cb0-a62f-80360737366d')   // GitHub
        DOCKER_CRED = credentials('c9038cd8-a265-4231-ac62-0c86d5b7194c') // Docker Hub
    }

    stages {

        stage('Approval') {
            steps {
                input message: 'Proceed with deployment to Docker?', ok: 'Yes, Deploy'
            }
        }

        stage('Clone Project') {
            steps {
                git branch: 'main',
                    credentialsId: "${GIT_CRED}",
                    url: 'https://github.com/Nazmul-9260/test-pipe.git'
            }
        }

        stage('Docker Login') {
            steps {
                sh '''
                    echo "$DOCKER_CRED_PSW" | docker login -u "$DOCKER_CRED_USR" --password-stdin
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                    docker build -t nazmul9260/forum-main:latest .
                '''
            }
        }

        stage('Push to Docker Hub') {
            steps {
                sh '''
                    docker push nazmul9260/forum-main:latest
                '''
            }
        }

        stage('Deploy with Docker Compose') {
            steps {
                sh '''
                    docker-compose down || true
                    docker-compose up -d
                '''
            }
        }

        stage('Show Running Containers') {
            steps {
                sh 'docker ps'
            }
        }
    }
}
