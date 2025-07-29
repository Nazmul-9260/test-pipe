pipeline {
    agent any

    environment {
        IMAGE_NAME = 'nazmul9260/forum-main-app'
        BRANCH = 'main'
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: "${env.BRANCH}",
                    url: 'https://github.com/Nazmul-9260/test-pipe.git',
                    credentialsId: 'a34e62e9-4cc1-4cb0-a62f-80360737366d'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    dockerImage = docker.build("${IMAGE_NAME}:${BRANCH}")
                }
            }
        }

        stage('Docker Login') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'c9038cd8-a265-4231-ac62-0c86d5b7194c', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    dockerImage.push()
                }
            }
        }

        stage('Docker Logout') {
            steps {
                sh 'docker logout'
            }
        }
    }

    post {
        failure {
            echo '❌ Deployment failed!'
        }
        success {
            echo '✅ Deployment succeeded!'
        }
    }
}
