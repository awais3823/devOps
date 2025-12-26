#!/bin/bash
# Script to push Docker images to Docker Hub for awais382

set -e

DOCKERHUB_USERNAME="awais382"

echo "Pushing images to Docker Hub for ${DOCKERHUB_USERNAME}..."

# Login to Docker Hub
echo "Please login to Docker Hub..."
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



