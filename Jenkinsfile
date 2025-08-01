pipeline {
    agent any

    environment {
        DEPLOY_BRANCH = 'main'
        COMMIT_MESSAGE = 'Auto: React build pushed by Jenkins'
        DEPLOY_DIR = '/media/justtry/external/mach001/projects/office_projects/justtry/build-artifact'
        GIT_URL = 'github.com/Prasannaramesh13/deploy-justtrytech.git'
    }

    stages {
        stage('Checkout & Build in Node Docker') {
            steps {
                script {
                    docker.image('node:20-bullseye-slim').inside('-u root:root') {
                        sh '''
                            # Clone source and install
                            npm install --legacy-peer-deps
                            npm run build

                            # Prepare deploy dir
                            rm -rf $DEPLOY_DIR
                            mkdir -p $DEPLOY_DIR
                            cp -r public/* $DEPLOY_DIR/

                            # Push to GitHub
                            cd $DEPLOY_DIR
                            git init
                            git config user.name "jenkins-bot"
                            git config user.email "jenkins@example.com"
                            git checkout -b $DEPLOY_BRANCH

                            git remote add origin https://$GITHUB_TOKEN@$GIT_URL
                            git add .
                            git commit -m "$COMMIT_MESSAGE" || echo "No changes to commit"
                            git push -f origin $DEPLOY_BRANCH
                        '''
                    }
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
