#!/bin/bash

DEV_IMAGE = 'prasanna1808/e-commerce'
IMAGE_TAG = 'latest'

echo "Building image with tag: $DEV_IMAGE:$IMAGE_TAG"

docker build -t $DEV_IMAGE:$IMAGE_TAG .
