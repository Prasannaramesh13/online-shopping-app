#!/bin/bash

DEV_IMAGE = 'e-commerce:latest'

echo "Building image with tag: $DEV_IMAGE"

docker build -t $DEV_IMAGE .
