# Build and Deploy Nginx + Node.js + Redis on Kubernetes

# Build web image
docker build -t awais3823/nginx-nodejs-redis-web:latest ./web

# Build nginx image
docker build -t awais3823/nginx-nodejs-redis-nginx:latest ./nginx

# Login to Docker Hub
docker login

# Push images to Docker Hub
docker push awais3823/nginx-nodejs-redis-web:latest
docker push awais3823/nginx-nodejs-redis-nginx:latest


# Create namespace
kubectl apply -f k8s/namespace.yaml

# Deploy Redis
kubectl apply -f k8s/redis-deployment.yaml

# Deploy Node.js web app
kubectl apply -f k8s/web-deployment.yaml

# Deploy Nginx
kubectl apply -f k8s/nginx-deployment.yaml

# List all pods
kubectl get pods -n nginx-nodejs-redis

# List all services
kubectl get svc -n nginx-nodejs-redis

# Install Nginx Ingress Controller
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

helm install ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx \
  --create-namespace

# Apply ingress
kubectl apply -f k8s/ingress.yaml

# Add host entry for local access
echo "<NODE_IP> nginx-nodejs-redis.local" | sudo tee -a /etc/hosts

# Access application
curl http://nginx-nodejs-redis.local
curl http://nginx-nodejs-redis.local/api/visits

# Install monitoring (Prometheus + Grafana)
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

helm install monitoring prometheus-community/kube-prometheus-stack \
  -n monitoring --create-namespace

# Check monitoring pods
kubectl get pods -n monitoring

# Access Grafana dashboard
http://<NODE_IP>:30000
# Username: admin
# Password: admin

#verication 
kubectl get ingress -n nginx-nodejs-redis
http://nginx-nodejs-redis.local

kubectl get nodes -o wide
http://172.29.254.201:30000