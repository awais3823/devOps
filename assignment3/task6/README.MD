#start the minikube 
minikube start 
#Enable ingress 
minikube addons enable ingress --force
#APPly files 
kubectl apply -f mysql-pv.yaml
kubectl apply -f mysql-pvc.yaml
kubectl apply -f mysql-deployment.yaml
kubectl apply -f phpmyadmin-deployment.yaml
#Verify 
kubectl get pods
kubectl get svc
kubectl get pvc
kubectl logs deployment/mysql
# Make sure the host entry exists
sudo nano /etc/hosts
# Add this line 
192.168.49.2  phpmyadmin.local
#open the address
http://phpmyadmin.local

