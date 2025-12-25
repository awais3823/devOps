# PowerShell script to build and push Docker images to Docker Hub
# Usage: .\push-images.ps1 YOUR_DOCKERHUB_USERNAME

param(
    [Parameter(Mandatory=$true)]
    [string]$DockerHubUsername
)

Write-Host "Building and pushing images to Docker Hub..." -ForegroundColor Green
Write-Host "Docker Hub Username: $DockerHubUsername" -ForegroundColor Cyan

# Build web image
Write-Host "`nBuilding web image..." -ForegroundColor Yellow
docker build -t "${DockerHubUsername}/nginx-nodejs-redis-web:latest" ./web
docker tag "${DockerHubUsername}/nginx-nodejs-redis-web:latest" "${DockerHubUsername}/nginx-nodejs-redis-web:v1.0.0"

# Build nginx image
Write-Host "Building nginx image..." -ForegroundColor Yellow
docker build -t "${DockerHubUsername}/nginx-nodejs-redis-nginx:latest" ./nginx
docker tag "${DockerHubUsername}/nginx-nodejs-redis-nginx:latest" "${DockerHubUsername}/nginx-nodejs-redis-nginx:v1.0.0"

# Login to Docker Hub
Write-Host "`nLogging in to Docker Hub..." -ForegroundColor Yellow
docker login -u $DockerHubUsername

# Push web image
Write-Host "`nPushing web image..." -ForegroundColor Yellow
docker push "${DockerHubUsername}/nginx-nodejs-redis-web:latest"
docker push "${DockerHubUsername}/nginx-nodejs-redis-web:v1.0.0"

# Push nginx image
Write-Host "Pushing nginx image..." -ForegroundColor Yellow
docker push "${DockerHubUsername}/nginx-nodejs-redis-nginx:latest"
docker push "${DockerHubUsername}/nginx-nodejs-redis-nginx:v1.0.0"

Write-Host "`n✅ All images pushed successfully!" -ForegroundColor Green
Write-Host "`nImages pushed:" -ForegroundColor Cyan
Write-Host "  - ${DockerHubUsername}/nginx-nodejs-redis-web:latest"
Write-Host "  - ${DockerHubUsername}/nginx-nodejs-redis-web:v1.0.0"
Write-Host "  - ${DockerHubUsername}/nginx-nodejs-redis-nginx:latest"
Write-Host "  - ${DockerHubUsername}/nginx-nodejs-redis-nginx:v1.0.0"


