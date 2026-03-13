#!/bin/bash

# Script to deploy application to Kubernetes
# Usage: ./deploy-k8s.sh YOUR_DOCKERHUB_USERNAME

set -e

DOCKERHUB_USERNAME=${1:-"YOUR_DOCKERHUB_USERNAME"}

if [ "$DOCKERHUB_USERNAME" == "YOUR_DOCKERHUB_USERNAME" ]; then
    echo "Error: Please provide your Docker Hub username"
    echo "Usage: ./deploy-k8s.sh YOUR_DOCKERHUB_USERNAME"
    exit 1
fi

echo "Deploying application to Kubernetes..."
echo "Docker Hub Username: $DOCKERHUB_USERNAME"

# Update image references in manifests
echo "Updating image references..."
sed -i "s/YOUR_DOCKERHUB_USERNAME/$DOCKERHUB_USERNAME/g" k8s/web-deployment.yaml
sed -i "s/YOUR_DOCKERHUB_USERNAME/$DOCKERHUB_USERNAME/g" k8s/nginx-deployment.yaml

# Create namespace
echo "Creating namespace..."
kubectl apply -f k8s/namespace.yaml

# Deploy Redis
echo "Deploying Redis..."
kubectl apply -f k8s/redis-deployment.yaml

# Wait for Redis to be ready
echo "Waiting for Redis to be ready..."
kubectl wait --for=condition=available --timeout=120s deployment/redis -n nginx-nodejs-redis

# Deploy Web
echo "Deploying Web backend..."
kubectl apply -f k8s/web-deployment.yaml

# Wait for Web to be ready
echo "Waiting for Web to be ready..."
kubectl wait --for=condition=available --timeout=120s deployment/web -n nginx-nodejs-redis

# Deploy Nginx
echo "Deploying Nginx..."
kubectl apply -f k8s/nginx-deployment.yaml

# Wait for Nginx to be ready
echo "Waiting for Nginx to be ready..."
kubectl wait --for=condition=available --timeout=120s deployment/nginx -n nginx-nodejs-redis

# Deploy Ingress
echo "Deploying Ingress..."
kubectl apply -f k8s/ingress.yaml

echo "✅ Deployment complete!"
echo ""
echo "Check status with:"
echo "  kubectl get all -n nginx-nodejs-redis"
echo "  kubectl get ingress -n nginx-nodejs-redis"



