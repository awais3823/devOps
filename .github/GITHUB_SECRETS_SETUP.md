# GitHub Secrets Setup Guide

This guide explains how to set up the required secrets for the CI/CD workflow.

## Required Secrets

The workflow requires the following secrets to be configured in your GitHub repository:

1. **DOCKERHUB_USERNAME** - Your Docker Hub username
2. **DOCKERHUB_PASSWORD** - Your Docker Hub password or access token
3. **KUBECONFIG** - Your Kubernetes cluster configuration file

## How to Set Up Secrets

### Step 1: Access Repository Settings

1. Go to your GitHub repository
2. Click on **Settings** (top navigation bar)
3. In the left sidebar, click on **Secrets and variables** → **Actions**

### Step 2: Add DOCKERHUB_USERNAME

1. Click **New repository secret**
2. Name: `DOCKERHUB_USERNAME`
3. Value: `awais382` (or your Docker Hub username)
4. Click **Add secret**

**Note:** For this project, set the value to `awais382`

### Step 3: Add DOCKERHUB_PASSWORD

1. Click **New repository secret**
2. Name: `DOCKERHUB_PASSWORD`
3. Value: Your Docker Hub password or access token
   - **Recommended**: Use a Docker Hub access token instead of your password
   - To create an access token: Docker Hub → Account Settings → Security → New Access Token
4. Click **Add secret**

### Step 4: Add KUBECONFIG

1. Get your Kubernetes config file:
   ```bash
   # On your local machine or cluster node
   cat ~/.kube/config
   ```

2. **Option A: Base64 encoded (recommended)**
   ```bash
   # Encode the config file
   cat ~/.kube/config | base64
   ```
   - Copy the entire base64 output
   - Add as secret `KUBECONFIG` with the base64 value

3. **Option B: Plain text**
   - Copy the entire contents of `~/.kube/config`
   - Add as secret `KUBECONFIG` with the plain text content

4. Click **New repository secret**
5. Name: `KUBECONFIG`
6. Value: Your kubeconfig content (base64 encoded or plain text)
7. Click **Add secret**

## For Single-Node Kubernetes Cluster (Kind/minikube)

If you're using Kind, minikube, or a similar single-node cluster, you may need to:

1. **Get the kubeconfig from the cluster:**
   ```bash
   # For Kind
   kind get kubeconfig --name <cluster-name> > kubeconfig.yaml
   
   # For minikube
   minikube kubectl -- config view --flatten > kubeconfig.yaml
   ```

2. **Encode and add to GitHub secrets:**
   ```bash
   cat kubeconfig.yaml | base64
   ```

3. **For remote cluster access**, ensure:
   - The cluster endpoint is accessible from GitHub Actions runners
   - Firewall rules allow access (if applicable)
   - Certificates in kubeconfig are valid and not expired

## Security Best Practices

1. **Never commit secrets to the repository** - Always use GitHub Secrets
2. **Use access tokens** instead of passwords when possible
3. **Rotate secrets regularly** - Update Docker Hub tokens and kubeconfig periodically
4. **Limit token permissions** - Grant only necessary permissions to access tokens
5. **Use separate tokens** for different services

## Verifying Secrets Setup

After setting up secrets, you can verify the workflow will work by:

1. Creating a test release in GitHub
2. The workflow will trigger automatically
3. Check the Actions tab to see if the workflow runs successfully
4. Review logs for any authentication or connection errors

## Troubleshooting

### Docker Hub Authentication Fails
- Verify `DOCKERHUB_USERNAME` and `DOCKERHUB_PASSWORD` are correct
- Check if Docker Hub access token has expired
- Ensure the token has write permissions to push images

### Kubernetes Connection Fails
- Verify `KUBECONFIG` secret is correctly set
- Check if kubeconfig is base64 encoded (workflow handles both)
- Ensure cluster endpoint is accessible from GitHub Actions runners
- Verify certificates in kubeconfig are not expired
- Check if cluster requires VPN or network access

### Image Push Fails
- Verify Docker Hub username matches your repository namespace (should be `awais382` for this project)
- Check if you have permissions to push to the repository
- Ensure image names match: `nginx-nodejs-redis-web` and `nginx-nodejs-redis-nginx`
- Images will be pushed as:
  - `awais382/nginx-nodejs-redis-web:latest` and `awais382/nginx-nodejs-redis-web:<version>`
  - `awais382/nginx-nodejs-redis-nginx:latest` and `awais382/nginx-nodejs-redis-nginx:<version>`

