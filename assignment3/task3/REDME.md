#!/bin/bash

# ==============================
# Task 3 – Scale Up Your App
# ==============================

# 1. Delete old Minikube cluster
echo "Deleting old Minikube cluster..."
minikube delete

# 2. Start new Minikube cluster with 2 nodes
echo "Starting Minikube with 2 nodes..."
minikube start --nodes 2

# 3. Wait until both nodes are ready
echo "Waiting for nodes to be ready..."
kubectl wait --for=condition=Ready node --all --timeout=180s
kubectl get nodes

# 4. Apply original deployment
echo "Applying original deployment..."
kubectl apply -f qu3/hello-deployment.yaml

echo "Checking pod status and nodes..."
kubectl get pods -o wide

# 5. Delete previous deployment
echo "Deleting original deployment..."
kubectl delete deployment hello

# 6. Label preferred node
NODE_NAME=$(kubectl get nodes -o jsonpath='{.items[1].metadata.name}')
echo "Labeling node $NODE_NAME with disktype=ssd..."
kubectl label nodes $NODE_NAME disktype=ssd --overwrite
kubectl get nodes --show-labels

# 7. Create updated deployment YAML
echo "Creating hello-deployment_updated.yaml..."
cat <<EOF > hello-deployment_updated.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: hello
spec:
  replicas: 2
  selector:
    matchLabels:
      app: hello
  template:
    metadata:
      labels:
        app: hello
    spec:
      nodeSelector:
        disktype: ssd
      containers:
        - name: hello-from
          image: pbitty/hello-from:latest
          ports:
            - containerPort: 80
      terminationGracePeriodSeconds: 1
EOF

# 8. Apply updated deployment
echo "Applying updated deployment..."
kubectl apply -f hello-deployment_updated.yaml

# 9. Verify pods
echo "Checking pods and which node they are on..."
kubectl get pods -o wide

echo "Task 3 completed!"

