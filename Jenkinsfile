pipeline {
    agent any

    environment {
        DEV_IMAGE = 'e-commerce:latest'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Prasannaramesh13/online-shopping-app.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh 'chmod +x build.sh'
                    sh './build.sh'
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    script {
                        sh """
                            echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        """
                        sh "docker push $DEV_IMAGE"
                    }
                }
            }
        }
    }

    post {
        success {
            echo 'Image pushed successfully!'
        }
        failure {
            echo 'Image push failed!'
        }
    }
}
 
