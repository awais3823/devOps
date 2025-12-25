# PowerShell script to deploy application to Kubernetes
# Usage: .\deploy-k8s.ps1 YOUR_DOCKERHUB_USERNAME

param(
    [Parameter(Mandatory=$true)]
    [string]$DockerHubUsername
)

Write-Host "Deploying application to Kubernetes..." -ForegroundColor Green
Write-Host "Docker Hub Username: $DockerHubUsername" -ForegroundColor Cyan

# Update image references in manifests
Write-Host "`nUpdating image references..." -ForegroundColor Yellow
(Get-Content k8s/web-deployment.yaml) -replace 'YOUR_DOCKERHUB_USERNAME', $DockerHubUsername | Set-Content k8s/web-deployment.yaml
(Get-Content k8s/nginx-deployment.yaml) -replace 'YOUR_DOCKERHUB_USERNAME', $DockerHubUsername | Set-Content k8s/nginx-deployment.yaml

# Create namespace
Write-Host "Creating namespace..." -ForegroundColor Yellow
kubectl apply -f k8s/namespace.yaml

# Deploy Redis
Write-Host "`nDeploying Redis..." -ForegroundColor Yellow
kubectl apply -f k8s/redis-deployment.yaml

# Wait for Redis to be ready
Write-Host "Waiting for Redis to be ready..." -ForegroundColor Yellow
kubectl wait --for=condition=available --timeout=120s deployment/redis -n nginx-nodejs-redis

# Deploy Web
Write-Host "`nDeploying Web backend..." -ForegroundColor Yellow
kubectl apply -f k8s/web-deployment.yaml

# Wait for Web to be ready
Write-Host "Waiting for Web to be ready..." -ForegroundColor Yellow
kubectl wait --for=condition=available --timeout=120s deployment/web -n nginx-nodejs-redis

# Deploy Nginx
Write-Host "`nDeploying Nginx..." -ForegroundColor Yellow
kubectl apply -f k8s/nginx-deployment.yaml

# Wait for Nginx to be ready
Write-Host "Waiting for Nginx to be ready..." -ForegroundColor Yellow
kubectl wait --for=condition=available --timeout=120s deployment/nginx -n nginx-nodejs-redis

# Deploy Ingress
Write-Host "`nDeploying Ingress..." -ForegroundColor Yellow
kubectl apply -f k8s/ingress.yaml

Write-Host "`n✅ Deployment complete!" -ForegroundColor Green
Write-Host "`nCheck status with:" -ForegroundColor Cyan
Write-Host "  kubectl get all -n nginx-nodejs-redis"
Write-Host "  kubectl get ingress -n nginx-nodejs-redis"


