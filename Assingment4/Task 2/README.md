# -------------------------------
# Task 2: Kubernetes Observability & Ingress Setup
# -------------------------------

# Helm Setup
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
helm version

# Install NGINX Ingress Controller (DaemonSet)
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
helm install ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx \
  --create-namespace \
  --set controller.kind=DaemonSet \
  --set controller.hostNetwork=false \
  --set controller.service.type=ClusterIP
kubectl get pods -n ingress-nginx

# Install Metrics Server
helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/
helm repo update
helm install metrics-server metrics-server/metrics-server \
  -n kube-system \
  --set args[0]=--kubelet-insecure-tls \
  --set args[1]=--kubelet-preferred-address-types=InternalIP,Hostname
kubectl top nodes
kubectl top pods -A

# Install Prometheus + Monitoring Stack
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install monitoring prometheus-community/kube-prometheus-stack \
  -n monitoring \
  --create-namespace \
  --set prometheusOperator.admissionWebhooks.enabled=false \
  --set prometheusOperator.resources.requests.memory=200Mi \
  --set prometheusOperator.resources.limits.memory=300Mi \
  --set prometheus.resources.requests.memory=300Mi \
  --set alertmanager.resources.requests.memory=200Mi \
  --set nodeExporter.enabled=false
kubectl get pods -n monitoring

# Grafana Access
kubectl get secret monitoring-grafana -n monitoring -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
kubectl port-forward svc/monitoring-grafana -n monitoring 3000:80

# Import Kubernetes Dashboard (Grafana UI)
# Open browser: http://localhost:3000
# Login: admin:<password-from-above>
# Dashboard → Import → Dashboard ID 315 → Select Prometheus → Import

# Verification
kubectl get pods -n monitoring
kubectl top nodes
kubectl top pods -A
