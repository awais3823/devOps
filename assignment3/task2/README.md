#For installing kompose user command 
curl -L https://github.com/kubernetes/kompose/releases/latest/download/kompose-linux-amd64 -o kompose
chmod +x kompose
#build image 
docker build -t awais3823/webapp:latest .
# login to docker 
docker login
# Now push image on dockerhub 
docker push awais3823/webapp:latest
# use this command to created compose file
kompose convert
# Now start minikube 
minikube start --driver=docker
# Now deploy 
kubectl apply -f web-deployment.yaml
kubectl apply -f redis-deployment.yaml
kubectl apply -f web-service.yaml
kubectl apply -f redis-service.yaml
# List the all pods 
kubectl get pods 
# list all services 
kubectl get svc 
# For to vist web runnig on port 
minikube service web
 


