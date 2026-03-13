# -------------------------------
# TASK-4 : MySQL + PhpMyAdmin
# -------------------------------

# STEP-1: Start Minikube
minikube start --driver=docker

# STEP-2: Apply Persistent Volume (PV)
kubectl apply -f mysql-pv.yaml

# STEP-3: Apply Persistent Volume Claim (PVC)
kubectl apply -f mysql-pvc.yaml

# STEP-4: Deploy MySQL Deployment
kubectl apply -f mysql-deployment.yaml

# STEP-5: Expose MySQL as ClusterIP
kubectl apply -f mysql-service.yaml

# STEP-6: Deploy PhpMyAdmin Deployment
kubectl apply -f phpmyadmin-deployment.yaml

# STEP-7: Expose PhpMyAdmin service (NodePort)
kubectl apply -f phpmyadmin-service.yaml

# ----------------------------------------
# VERIFY DEPLOYMENT & SERVICES
# ----------------------------------------

# List all pods
kubectl get pods

# List services
kubectl get svc

# Check PV status
kubectl get pv

# Check PVC status
kubectl get pvc

# Check if MySQL pod mounted the PVC
kubectl describe pod <mysql-pod-name>

# ----------------------------------------
# ACCESSING PHPMYADMIN
# ----------------------------------------

# Open PhpMyAdmin in browser
minikube service phpmyadmin

# Result example:
# URL → http://192.168.49.2:30080

# ----------------------------------------
# CHECKING DATA PERSISTENCE
# ----------------------------------------

# Enter MySQL pod
kubectl exec -it <mysql-pod-name> -- bash

# Log in to MySQL
mysql -u root -p

# Create a database (optional)
CREATE DATABASE testdb;

# Exit MySQL
exit

# Restart MySQL Pod
kubectl delete pod <mysql-pod-name>

# Verify that database still exists after restart
kubectl exec -it <new-mysql-pod-name> -- mysql -u root -p

