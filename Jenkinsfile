pipeline {
    agent any

    environment {
        DEV_IMAGE = 'prasanna1808/e-commerce'
        IMAGE_TAG = 'latest'
    }

    stages {
        stage('cloning the repo') {
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
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', username: 'DOCKER_USER', password: 'DOCKER_PASS')]) {
                 {
                    script {
                        sh """
                          echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                      """
                       sh "docker push $DEV_IMAGE:$IMAGE_TAG"
                    }
                }
            }
        }
        stage('Pull Docker Image') {
            steps {
                sh '''
                    echo "Pulling Docker image..."
                    docker pull $DEV_IMAGE:$IMAGE_TAG
                '''
            }
        }

        stage('Run Container') {
            steps {
                sh '''
                    echo "Running container..."
                    docker run -d --name shopping-app -p 3000:3000 $DEV_IMAGE:$IMAGE_TAG
                '''
            }
        }
    }

    post {
        always {
            echo 'CI/CD pipeline finished.'
        }
    }
}
 
