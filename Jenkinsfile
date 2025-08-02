pipeline {
    agent {
        docker {
            image 'node:18-alpine'
            args '-u root:root'
        }
    }

    environment {
        DEPLOY_BRANCH = 'main'
        COMMIT_MESSAGE = 'Auto: React build pushed by Jenkins'
        DEPLOY_DIR = '/media/justtry/external/mach001/projects/office_projects/justtry/build-artifact'
        GIT_URL = 'github.com/Prasannaramesh13/deploy-justtrytech.git'
    }

    stages {
        stage('Checkout & Build in Node Docker') {
            steps {
                withCredentials([string(credentialsId: 'GITHUB_TOKEN', variable: 'GITHUB_TOKEN')]) {
                    sh '''
                        # Install git inside Alpine-based container
                        apk add --no-cache git

                        # Install dependencies and build the React app
                        npm install --legacy-peer-deps
                        npm run build

                        # Prepare deployment directory
                        rm -rf $DEPLOY_DIR
                        mkdir -p $DEPLOY_DIR
                        cp -r public/* $DEPLOY_DIR/

                        # Git push build artifacts to target repo
                        cd $DEPLOY_DIR
                        git init
                        git config user.name "jenkins-bot"
                        git config user.email "jenkins@example.com"
                        git checkout -b $DEPLOY_BRANCH

                        git remote add origin https://$GITHUB_TOKEN@$GIT_URL
                        git add .
                        git commit -m "$COMMIT_MESSAGE" || echo 'Nothing to commit'
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
