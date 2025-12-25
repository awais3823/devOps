#!/bin/bash

# Script to build and push Docker images to Docker Hub
# Usage: ./push-images.sh YOUR_DOCKERHUB_USERNAME

set -e

DOCKERHUB_USERNAME=${1:-"YOUR_DOCKERHUB_USERNAME"}

if [ "$DOCKERHUB_USERNAME" == "YOUR_DOCKERHUB_USERNAME" ]; then
    echo "Error: Please provide your Docker Hub username"
    echo "Usage: ./push-images.sh YOUR_DOCKERHUB_USERNAME"
    exit 1
fi

echo "Building and pushing images to Docker Hub..."
echo "Docker Hub Username: $DOCKERHUB_USERNAME"

# Build web image
echo "Building web image..."
docker build -t ${DOCKERHUB_USERNAME}/nginx-nodejs-redis-web:latest ./web
docker tag ${DOCKERHUB_USERNAME}/nginx-nodejs-redis-web:latest ${DOCKERHUB_USERNAME}/nginx-nodejs-redis-web:v1.0.0

# Build nginx image
echo "Building nginx image..."
docker build -t ${DOCKERHUB_USERNAME}/nginx-nodejs-redis-nginx:latest ./nginx
docker tag ${DOCKERHUB_USERNAME}/nginx-nodejs-redis-nginx:latest ${DOCKERHUB_USERNAME}/nginx-nodejs-redis-nginx:v1.0.0

# Login to Docker Hub
echo "Logging in to Docker Hub..."
docker login -u ${DOCKERHUB_USERNAME}

# Push web image
echo "Pushing web image..."
docker push ${DOCKERHUB_USERNAME}/nginx-nodejs-redis-web:latest
docker push ${DOCKERHUB_USERNAME}/nginx-nodejs-redis-web:v1.0.0

# Push nginx image
echo "Pushing nginx image..."
docker push ${DOCKERHUB_USERNAME}/nginx-nodejs-redis-nginx:latest
docker push ${DOCKERHUB_USERNAME}/nginx-nodejs-redis-nginx:v1.0.0

echo "✅ All images pushed successfully!"
echo ""
echo "Images pushed:"
echo "  - ${DOCKERHUB_USERNAME}/nginx-nodejs-redis-web:latest"
echo "  - ${DOCKERHUB_USERNAME}/nginx-nodejs-redis-web:v1.0.0"
echo "  - ${DOCKERHUB_USERNAME}/nginx-nodejs-redis-nginx:latest"
echo "  - ${DOCKERHUB_USERNAME}/nginx-nodejs-redis-nginx:v1.0.0"


