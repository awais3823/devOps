\# -------------------------------

\# Task 3: Guestbook Application Deployment \& Ingress

\# -------------------------------



\# 1 Deploy Redis Leader

kubectl apply -f https://k8s.io/examples/application/guestbook/redis-leader-deployment.yaml

kubectl get pods -l app=redis -l role=leader



\# Check logs (optional)

kubectl logs -f deployment/redis-leader



\# 2 Expose Redis Leader via Service

kubectl apply -f https://k8s.io/examples/application/guestbook/redis-leader-service.yaml

kubectl get service redis-leader



\# 3 Deploy Redis Followers

kubectl apply -f https://k8s.io/examples/application/guestbook/redis-follower-deployment.yaml

kubectl get pods -l app=redis -l role=follower



\# 4 Expose Redis Followers via Service

kubectl apply -f https://k8s.io/examples/application/guestbook/redis-follower-service.yaml

kubectl get service redis-follower



\# 5 Deploy Guestbook Frontend

kubectl apply -f https://k8s.io/examples/application/guestbook/frontend-deployment.yaml

kubectl get pods -l app=guestbook -l tier=frontend



\# 6 Expose Guestbook Frontend

kubectl apply -f https://k8s.io/examples/application/guestbook/frontend-service.yaml

kubectl get service frontend



\# 7 Port-forward to access frontend (if using ClusterIP)

kubectl port-forward svc/frontend 8080:80

\# Then open browser: http://localhost:8080



\# 8 Optional: Scale Frontend up or down

kubectl scale deployment frontend --replicas=5

kubectl get pods -l app=guestbook -l tier=frontend



kubectl scale deployment frontend --replicas=2

kubectl get pods -l app=guestbook -l tier=frontend



\# -------------------------------

\# 9 Expose Frontend via Ingress (Requires NGINX Ingress installed)

\# Create guestbook-ingress.yaml



cat <<EOF | kubectl apply -f -

apiVersion: networking.k8s.io/v1

kind: Ingress

metadata:

&nbsp; name: guestbook-ingress

&nbsp; namespace: default

&nbsp; annotations:

&nbsp;   nginx.ingress.kubernetes.io/rewrite-target: /

spec:

&nbsp; rules:

&nbsp; - host: guestbook.local

&nbsp;   http:

&nbsp;     paths:

&nbsp;     - path: /

&nbsp;       pathType: Prefix

&nbsp;       backend:

&nbsp;         service:

&nbsp;           name: frontend

&nbsp;           port:

&nbsp;             number: 80

EOF



kubectl get ingress guestbook-ingress



\# Add host mapping for local testing (edit hosts file)

\# For WSL2:

\# sudo nano /etc/hosts

\# Add line: 127.0.0.1 guestbook.local

\# Save file



\# Test in browser: http://guestbook.local



