# -------------------------------
# TASK-5 : ConfigMaps & Secrets in Kubernetes
# -------------------------------

# STEP-1: Start Minikube
minikube start --driver=docker

# STEP-2: Create ConfigMap
kubectl apply -f app-configmap.yaml

# STEP-3: Create Secret
kubectl apply -f app-secret.yaml

# STEP-4: Deploy Application using ConfigMap & Secret
kubectl apply -f app-deployment.yaml

# STEP-5: Expose Application Service
kubectl apply -f app-service.yaml

# ----------------------------------------
# VERIFY RESOURCES
# ----------------------------------------

# List ConfigMaps
kubectl get configmaps

# List Secrets
kubectl get secrets

# View Deployment
kubectl get deployments

# List Pods
kubectl get pods

# Describe Pod to see ENV injected
kubectl describe pod <pod-name>

# ----------------------------------------
# VERIFY ENVIRONMENT VARIABLES INSIDE POD
# ----------------------------------------

# Enter Pod Shell
kubectl exec -it <pod-name> -- sh

# Print environment variables
printenv

# Expected Output Example:
# APP_MODE=production
# APP_VERSION=1.0
# DB_USER=root
# DB_PASS=admin123 (hidden value from Secret)

# Exit Pod
exit


# ----------------------------------------
# YAML FILES USED
# ----------------------------------------


# app-configmap.yaml
--------------------------------------------------
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
data:
  APP_MODE: "production"
  APP_VERSION: "1.0"
--------------------------------------------------


# app-secret.yaml
--------------------------------------------------
apiVersion: v1
kind: Secret
metadata:
  name: app-secret
type: Opaque
data:
  DB_USER: cm9vdA==
  DB_PASS: YWRtaW4xMjM=
--------------------------------------------------


# app-deployment.yaml
--------------------------------------------------
apiVersion: apps/v1
kind: Deployment
metadata:
  name: sample-app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: sample-app
  template:
    metadata:
      labels:
        app: sample-app
    spec:
      containers:
      - name: sample-container
        image: nginx:latest
        env:
        - name: APP_MODE
          valueFrom:
            configMapKeyRef:
              name: app-config
              key: APP_MODE
        - name: APP_VERSION
          valueFrom:
            configMapKeyRef:
              name: app-config
              key: APP_VERSION
        - name: DB_USER
          valueFrom:
            secretKeyRef:
              name: app-secret
              key: DB_USER
        - name: DB_PASS
          valueFrom:
            secretKeyRef:
              name: app-secret
              key: DB_PASS
--------------------------------------------------


# app-service.yaml
--------------------------------------------------
apiVersion: v1
kind: Service
metadata:
  name: app-service
spec:
  selector:
    app: sample-app
  ports:
    - port: 80
      targetPort: 80
  type: ClusterIP
--------------------------------------------------

