#To intsall minikube we use this command (download minikube file  is not pushed because it is 132 md max size is 100 mb allowed by git )
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
#To start the minikube 
minikube start --driver=docker
#To check either minikube is running or not 
minikube status 
#create file deployment.yml 
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:latest
        ports:
        - containerPort: 80
#To create deployment 
kubectl apply -f deployment.yaml
#For verifying we use this command 
kubectl get deployments
kubectl get pods -o wide
#For cluster  run time u use these command 
# get node will provide u node name u will use that name in a place <node name>
kubectl get nodes 
kubectl describe node <node-name>
minikube status
# For dashboard we use 
minikube dashbord 

