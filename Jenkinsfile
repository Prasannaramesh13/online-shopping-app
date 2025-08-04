pipeline {
    agent any

    environment {
        IMAGE_TAG = 'latest'
        DEPLOY_DIR = '/media/justtry/external/mach001/projects/office_projects/justtry/build-artifact'
        COMMIT_MESSAGE = 'Auto: React build pushed by Jenkins'
        RELEASE_REPO = 'github.com/justtrytechnologies/justtrytechnologies.github.io.git'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
                script {
                    echo "Current branch: ${env.BRANCH_NAME}"
                }
            }
        }

        stage('Branch Based Actions') {
            steps {
                withCredentials([string(credentialsId: 'justtry-site-token', variable: 'justtry-site-token')]) {
                script {
                    if (env.BRANCH_NAME == 'local-dev') {
                        env.IMAGE_NAME = 'website/dev'
                        env.BUILD_MODE = 'dev'

                        echo "Using image: ${env.IMAGE_NAME}:${env.IMAGE_TAG}"
                        echo "Using build mode: ${env.BUILD_MODE}"
                    } else if (env.BRANCH_NAME == 'local-prod') {
                        env.IMAGE_NAME = 'website/prod'
                        env.BUILD_MODE = 'prod'

                        echo "Using image: ${env.IMAGE_NAME}:${env.IMAGE_TAG}"
                        echo "Using build mode: ${env.BUILD_MODE}"
                    } else if (env.BRANCH_NAME == 'release') {
                        docker.image('node:20-bullseye-slim').inside('-u root:root') {
                            sh """
                                apk add --no-cache git

                                # Build React app
                                npm install --legacy-peer-deps && npm run build

                                # Prepare deployment
                                rm -rf $DEPLOY_DIR
                                mkdir -p $DEPLOY_DIR
                                cp -r public/* $DEPLOY_DIR/

                                cd $DEPLOY_DIR
                                git init
                                git config user.name "jenkins-bot"
                                git config user.email "jenkins@example.com"
                                git checkout -b ${BRANCH_NAME}
                                git remote add origin https://$GITHUB_TOKEN@$RELEASE_REPO
                                git add .
                                git commit -m "$COMMIT_MESSAGE" || echo 'Nothing to commit'
                                git push -f origin ${BRANCH_NAME}
                            """
                        }
                    } else {
                        error "Unsupported branch: ${env.BRANCH_NAME}"
                        }
                    }
                }
            }
        }    

        stage('Build Docker Image') {
            when {
                anyOf {
                    branch 'local-dev'
                    branch 'local-prod'
                }
            }
            steps {
                script {
                    sh """
                        docker build \
                          --build-arg BUILD_MODE=${BUILD_MODE} \
                          -t ${IMAGE_NAME}:${IMAGE_TAG} .
                    """
                }
            }
        }

        stage('Run Container') {
            when {
                anyOf {
                    branch 'local-dev'
                    branch 'local-prod'
                }
            }
            steps {
                script {
                    sh 'chmod +x deploy.sh'
                    sh "./deploy.sh ${env.BRANCH_NAME}"
                }
            }
        }
    }

    post {
        always {
            echo 'CI/CD pipeline finished.'
        }
    }
}

