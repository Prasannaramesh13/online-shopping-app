pipeline {
    agent any

    environment {
        DEPLOY_BRANCH = 'main'
        COMMIT_MESSAGE = 'Auto: React build pushed by Jenkins'
        DEPLOY_DIR = '/media/justtry/external/mach001/projects/office_projects/justtry/build-artifact'
        REPO_NAME = 'Prasannaramesh13/deploy-justtrytech'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Install & Build in Node Docker') {
            steps {
                script {
                    docker.image('node:20-bullseye-slim').inside('-u root:root') {
                        sh 'npm install --legacy-peer-deps'
                        sh 'npm run build'
                    }
                }
            }
        }

        stage('Push Build to GitHub (via token)') {
            steps {
                withCredentials([string(credentialsId: 'build-github-access-token', variable: 'GITHUB_TOKEN')]) {
                    sh '''
                        rm -rf $DEPLOY_DIR
                        mkdir -p $DEPLOY_DIR
                        cp -r public/* $DEPLOY_DIR/

                        cd $DEPLOY_DIR
                        git init
                        git config user.name "jenkins-bot"
                        git config user.email "jenkins@example.com"
                        git checkout -b $DEPLOY_BRANCH

                        git remote add origin https://$GITHUB_TOKEN@github.com/$REPO_NAME.git
                        git add .
                        git commit -m "$COMMIT_MESSAGE"
                        git push -f origin $DEPLOY_BRANCH
                    '''
                }
            }
        }
    }

    post {
        success {
            echo "React app built and pushed to GitHub branch '$DEPLOY_BRANCH'."
        }
        failure {
            echo "Build or push to GitHub failed."
        }
    }
}
