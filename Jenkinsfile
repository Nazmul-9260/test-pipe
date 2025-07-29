pipeline {
    agent any

    environment {
        IMAGE_NAME = 'nazmul9260/forum-main'
        VERSION = "${env.BUILD_NUMBER ?: 'latest'}"
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
                    credentialsId: 'a34e62e9-4cc1-4cb0-a62f-80360737366d',
                    url: 'https://github.com/Nazmul-9260/test-pipe.git'
            }
        }

        stage('Docker Login') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'c9038cd8-a265-4231-ac62-0c86d5b7194c', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh 'echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    dockerImage = docker.build("${IMAGE_NAME}:${VERSION}")
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    dockerImage.push()
                    // Optional: update latest tag too
                    sh "docker tag ${IMAGE_NAME}:${VERSION} ${IMAGE_NAME}:latest"
                    sh "docker push ${IMAGE_NAME}:latest"
                }
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

    post {
        success {
            echo "✅ Deployment successful: ${IMAGE_NAME}:${VERSION}"
        }
        failure {
            echo '❌ Deployment failed!'
        }
    }
}
