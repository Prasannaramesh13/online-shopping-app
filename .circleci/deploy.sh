#!/bin/bash

set -e

ssh -o StrictHostKeyChecking=no $EC2_USER@$EC2_HOST << 'EOF'
  cd /home/ubuntu
  sudo chown -R $USER:$USER .

  # Install required tools
  sudo apt update
  sudo apt install -y git curl

  # Install Node.js
  curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
  sudo apt install -y nodejs

  # Clone or pull the repo
  if [ -d "react-app" ]; then
    echo "Repo exists. Pulling latest changes..."
    cd react-app
    git pull
  else
    echo "Cloning repo..."
    git clone https://github.com/Prasannaramesh13/online-shopping-app.git
    cd react-app
  fi

  # Build the app
  npm install
  npm run build

  # Install and run serve
  sudo npm install -g serve
  fuser -k 3000/tcp || true
  nohup serve -s build -l tcp://0.0.0.0:3000 > /tmp/serve.log 2>&1 &
EOF
