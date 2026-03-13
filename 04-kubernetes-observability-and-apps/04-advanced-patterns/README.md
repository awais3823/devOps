\# -------------------------------

\# Task 4: Kubernetes Cluster Upgrade v1.32 → v1.33

\# -------------------------------



\# 1 Update apt repository for Kubernetes v1.33

sudo rm -f /etc/apt/sources.list.d/kubernetes.list

echo 'deb \[signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.33/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt update



\# 2 Upgrade kubeadm on Control Plane Node

sudo apt-mark unhold kubeadm

sudo apt install -y kubeadm=1.33.\*

sudo apt-mark hold kubeadm



\# Verify kubeadm version

kubeadm version



\# 3 Check upgrade plan

sudo kubeadm upgrade plan



\# 4 Apply upgrade on Control Plane Node

sudo kubeadm upgrade apply v1.33.x   # Replace x with latest patch version (example: 1.33.6)



\# 5 Upgrade kubelet \& kubectl on Control Plane Node

sudo apt-mark unhold kubelet kubectl

sudo apt install -y kubelet=1.33.\* kubectl=1.33.\*

sudo apt-mark hold kubelet kubectl



\# Reload \& restart kubelet

sudo systemctl daemon-reload

sudo systemctl daemon-reexec

sudo systemctl restart kubelet



\# Verify cluster version

kubectl version

kubectl get nodes



\# 6 Upgrade Worker Nodes (one by one)

\# On each worker node:

sudo rm -f /etc/apt/sources.list.d/kubernetes.list

echo 'deb \[signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.33/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt update



\# Upgrade kubeadm

sudo apt-mark unhold kubeadm

sudo apt install -y kubeadm=1.33.\*

sudo apt-mark hold kubeadm



\# Join node upgrade

sudo kubeadm upgrade node



\# Upgrade kubelet \& kubectl

sudo apt-mark unhold kubelet kubectl

sudo apt install -y kubelet=1.33.\* kubectl=1.33.\*

sudo apt-mark hold kubelet kubectl



sudo systemctl daemon-reload

sudo systemctl daemon-reexec

sudo systemctl restart kubelet



\# 7 Verify cluster after all nodes upgraded

kubectl get nodes

kubectl get pods -A



