pipeline {
    agent any

    environment {
        DEV_IMAGE = 'prasanna1808/e-commerce'
        IMAGE_TAG = 'latest'
    }

    stages {
        stage('Clean Workspace') {
            steps {
                deleteDir() // Clean workspace before checkout
            }
        }

        stage('Cloning the Repo') {
            steps {
                checkout([$class: 'GitSCM',
                    branches: [[name: '*/main']],
                    userRemoteConfigs: [[
                        url: 'https://github.com/Prasannaramesh13/online-shopping-app.git'
                    ]]
                ])
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
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    script {
                        sh """
                            echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                            docker push $DEV_IMAGE:$IMAGE_TAG
                        """
                    }
                }
            }
        }

        stage('Pulling Docker Image') {
            steps {
                sh """
                    echo "Pulling Docker image..."
                    docker pull $DEV_IMAGE:$IMAGE_TAG
                """
            }
        }

        stage('Run Container') {
            steps {
                sh """
                    echo "Running container..."
                    docker stop shopping-app || true
                    docker rm -f shopping-app || true
                    docker run -d --name shopping-app -p 3000:3000 $DEV_IMAGE:$IMAGE_TAG
                """
            }
        }
    }

    post {
        always {
            echo 'CI/CD pipeline finished.'
        }
    }
}

 
