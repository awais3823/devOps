# Task 3: CI/CD Pipeline with GitHub Actions

This document describes the CI/CD pipeline implementation for the nginx-nodejs-redis project using GitHub Actions.

## Overview

The CI/CD pipeline automatically builds Docker images and deploys them to a Kubernetes cluster when a new release is created in GitHub. This enables automated deployment workflows with minimal manual intervention.

## Features

- ✅ **Automated builds** - Builds Docker images for web and nginx components
- ✅ **Version tagging** - Tags images with both `latest` and release version
- ✅ **Docker Hub integration** - Pushes images to Docker Hub
- ✅ **Kubernetes deployment** - Automatically updates deployments in the cluster
- ✅ **Rollout verification** - Ensures deployments complete successfully
- ✅ **Docker layer caching** - Optimizes build times with GitHub Actions cache

## Prerequisites

Before using the CI/CD pipeline, ensure you have:

1. **GitHub Repository** - Your code must be in a GitHub repository
2. **Docker Hub Account** - Account with username `awais382` (or update secrets)
3. **Kubernetes Cluster** - Accessible cluster with kubectl configured
4. **GitHub Secrets** - Required secrets configured (see setup below)

## Setup Instructions

### Step 1: Configure GitHub Secrets

The workflow requires three secrets to be configured in your GitHub repository:

1. Go to your repository on GitHub
2. Navigate to **Settings** → **Secrets and variables** → **Actions**
3. Add the following secrets:

#### DOCKERHUB_USERNAME
- **Name**: `DOCKERHUB_USERNAME`
- **Value**: `awais382`

#### DOCKERHUB_PASSWORD
- **Name**: `DOCKERHUB_PASSWORD`
- **Value**: Your Docker Hub password or access token
  - **Recommended**: Create a Docker Hub access token
  - Go to Docker Hub → Account Settings → Security → New Access Token

#### KUBECONFIG
- **Name**: `KUBECONFIG`
- **Value**: Your Kubernetes cluster configuration
  - Get it with: `cat ~/.kube/config`
  - Encode it: `cat ~/.kube/config | base64`
  - Paste the base64 encoded output

📖 **Detailed Setup Guide**: See [`.github/GITHUB_SECRETS_SETUP.md`](.github/GITHUB_SECRETS_SETUP.md)

### Step 2: Verify Workflow File

Ensure the workflow file exists at:
```
.github/workflows/ci-cd.yaml
```

### Step 3: Verify Kubernetes Deployments

Make sure your Kubernetes deployment files exist:
- `k8s/web-deployment.yaml`
- `k8s/nginx-deployment.yaml`

The namespace `nginx-nodejs-redis` must exist in your cluster:
```bash
kubectl create namespace nginx-nodejs-redis
# Or apply the namespace file
kubectl apply -f k8s/namespace.yaml
```

## How to Use

### Creating a Release

1. **Push your code changes** to the repository
2. **Create a new release** on GitHub:
   - Go to **Releases** → **Draft a new release**
   - Enter a tag (e.g., `v1.0.0` or `1.0.0`)
   - Fill in release title and description
   - Click **Publish release**

3. **Workflow triggers automatically**:
   - The CI/CD pipeline starts immediately
   - Monitor progress in the **Actions** tab

### What Happens During Deployment

1. **Build Phase**:
   - Builds Docker image for `web` component
   - Builds Docker image for `nginx` component
   - Tags images with `latest` and release version

2. **Push Phase**:
   - Logs in to Docker Hub
   - Pushes images to:
     - `awais382/nginx-nodejs-redis-web:latest`
     - `awais382/nginx-nodejs-redis-web:<version>`
     - `awais382/nginx-nodejs-redis-nginx:latest`
     - `awais382/nginx-nodejs-redis-nginx:<version>`

3. **Deploy Phase**:
   - Configures kubectl connection
   - Updates `web` deployment with new image version
   - Updates `nginx` deployment with new image version
   - Waits for rollouts to complete (up to 5 minutes each)
   - Verifies pods are healthy

4. **Verification Phase**:
   - Displays deployment status
   - Shows pod status
   - Confirms image versions in use

## Workflow File Structure

The workflow (`.github/workflows/ci-cd.yaml`) includes:

```yaml
- Checkout repository
- Set up Docker Buildx
- Extract release version from tag
- Log in to Docker Hub
- Build and push web image (with caching)
- Build and push nginx image (with caching)
- Set up kubectl
- Configure Kubernetes connection
- Verify cluster connection
- Update web deployment
- Update nginx deployment
- Verify web deployment rollout
- Verify nginx deployment rollout
- Display deployment status
- Verify pods are healthy
```

## Monitoring the Pipeline

### View Workflow Runs

1. Go to your repository on GitHub
2. Click on the **Actions** tab
3. Select the **CI/CD Pipeline** workflow
4. Click on a specific run to see detailed logs

### Check Deployment Status

After the workflow completes, verify deployments:

```bash
# Check deployments
kubectl get deployments -n nginx-nodejs-redis

# Check pods
kubectl get pods -n nginx-nodejs-redis

# Check image versions
kubectl get deployments -n nginx-nodejs-redis -o jsonpath='{range .items[*]}{.metadata.name}{": "}{.spec.template.spec.containers[0].image}{"\n"}{end}'
```

## Troubleshooting

### Workflow Fails at Docker Hub Login
- **Issue**: Authentication failed
- **Solution**: 
  - Verify `DOCKERHUB_USERNAME` and `DOCKERHUB_PASSWORD` secrets are correct
  - Check if Docker Hub token has expired
  - Ensure token has write permissions

### Workflow Fails at Image Push
- **Issue**: Cannot push to Docker Hub
- **Solution**:
  - Verify Docker Hub username is `awais382`
  - Check repository permissions on Docker Hub
  - Ensure images don't exceed size limits

### Workflow Fails at Kubernetes Connection
- **Issue**: Cannot connect to cluster
- **Solution**:
  - Verify `KUBECONFIG` secret is correctly set
  - Check if kubeconfig is base64 encoded
  - Ensure cluster endpoint is accessible from GitHub Actions runners
  - Verify certificates are not expired
  - For local clusters (Kind/minikube), ensure cluster is accessible externally

### Deployment Rollout Times Out
- **Issue**: Rollout doesn't complete within 5 minutes
- **Solution**:
  - Check pod logs: `kubectl logs <pod-name> -n nginx-nodejs-redis`
  - Verify image exists and is pullable
  - Check resource constraints: `kubectl describe pod <pod-name> -n nginx-nodejs-redis`
  - Increase timeout in workflow if needed (default: 300s)

### Images Not Updating in Cluster
- **Issue**: Deployment shows old image version
- **Solution**:
  - Verify workflow completed successfully
  - Check deployment history: `kubectl rollout history deployment/web -n nginx-nodejs-redis`
  - Force rollout restart if needed: `kubectl rollout restart deployment/web -n nginx-nodejs-redis`

## Image Naming Convention

Images are built and tagged as follows:

- **Web component**:
  - `awais382/nginx-nodejs-redis-web:latest`
  - `awais382/nginx-nodejs-redis-web:<version>` (e.g., `1.0.0`)

- **Nginx component**:
  - `awais382/nginx-nodejs-redis-nginx:latest`
  - `awais382/nginx-nodejs-redis-nginx:<version>` (e.g., `1.0.0`)

## Version Handling

The workflow automatically extracts the version from the GitHub release tag:
- Tag `v1.0.0` → Version `1.0.0` (removes 'v' prefix)
- Tag `1.0.0` → Version `1.0.0` (as-is)
- Tag `v2.1.3` → Version `2.1.3`

## Performance Optimizations

- **Docker Layer Caching**: Uses GitHub Actions cache to speed up builds
- **Parallel Builds**: Web and nginx images could build in parallel (sequential in current implementation for clarity)
- **Buildx**: Uses Docker Buildx for advanced build features

## Security Considerations

- ✅ Secrets are never exposed in logs
- ✅ Uses Docker Hub access tokens (recommended over passwords)
- ✅ Kubeconfig is stored securely in GitHub Secrets
- ✅ Workflow runs in isolated GitHub Actions runners
- ✅ Image tags include version for traceability

## Best Practices

1. **Use semantic versioning** for release tags (e.g., `v1.0.0`, `v1.1.0`, `v2.0.0`)
2. **Test locally** before creating a release
3. **Monitor workflow runs** to catch issues early
4. **Keep secrets updated** - Rotate Docker Hub tokens periodically
5. **Review deployment logs** after each deployment
6. **Use release notes** to document changes in each release

## Manual Deployment (Alternative)

If you need to deploy manually instead of using the pipeline:

```bash
# Set your Docker Hub username
export DOCKERHUB_USERNAME="awais382"
export VERSION="1.0.0"

# Build and push images
docker build -t ${DOCKERHUB_USERNAME}/nginx-nodejs-redis-web:${VERSION} ./web
docker build -t ${DOCKERHUB_USERNAME}/nginx-nodejs-redis-web:latest ./web
docker push ${DOCKERHUB_USERNAME}/nginx-nodejs-redis-web:${VERSION}
docker push ${DOCKERHUB_USERNAME}/nginx-nodejs-redis-web:latest

docker build -t ${DOCKERHUB_USERNAME}/nginx-nodejs-redis-nginx:${VERSION} ./nginx
docker build -t ${DOCKERHUB_USERNAME}/nginx-nodejs-redis-nginx:latest ./nginx
docker push ${DOCKERHUB_USERNAME}/nginx-nodejs-redis-nginx:${VERSION}
docker push ${DOCKERHUB_USERNAME}/nginx-nodejs-redis-nginx:latest

# Update Kubernetes deployments
kubectl set image deployment/web web=${DOCKERHUB_USERNAME}/nginx-nodejs-redis-web:${VERSION} -n nginx-nodejs-redis
kubectl set image deployment/nginx nginx=${DOCKERHUB_USERNAME}/nginx-nodejs-redis-nginx:${VERSION} -n nginx-nodejs-redis

# Verify rollouts
kubectl rollout status deployment/web -n nginx-nodejs-redis
kubectl rollout status deployment/nginx -n nginx-nodejs-redis
```

## Related Files

- **Workflow**: `.github/workflows/ci-cd.yaml`
- **Secrets Setup Guide**: `.github/GITHUB_SECRETS_SETUP.md`
- **Kubernetes Deployments**: `k8s/web-deployment.yaml`, `k8s/nginx-deployment.yaml`
- **Other Documentation**: See project README files for Kubernetes deployment details

## Summary

The CI/CD pipeline automates the entire deployment process from code commit to production deployment. Simply create a GitHub release, and the pipeline handles:

1. ✅ Building Docker images
2. ✅ Pushing to Docker Hub
3. ✅ Deploying to Kubernetes
4. ✅ Verifying successful rollout

This reduces manual errors and ensures consistent, repeatable deployments.

