

### Step 1: Update Ubuntu Packages
```bash
sudo apt update && sudo apt upgrade -y
sudo reboot
```
**Explanation:** Updates all system packages and kernel. Reboot ensures the latest kernel is loaded.

### Step 2: Disable Swap
```bash
sudo swapoff -a
sudo sed -i '/ swap / s/^/#/' /etc/fstab
swapon --show  # Should return nothing
```
**Explanation:** Kubernetes requires swap to be disabled. The first command disables swap temporarily, the second makes it permanent.

### Step 3: Load Required Kernel Modules
```bash
sudo modprobe overlay
sudo modprobe br_netfilter
sudo tee /etc/modules-load.d/k8s.conf << EOF
overlay
br_netfilter
EOF
```
**Explanation:**
- `overlay` is needed for container storage drivers
- `br_netfilter` allows iptables to see bridged network traffic
- The configuration file ensures modules load on reboot

### Step 4: Configure Networking Parameters
```bash
sudo tee /etc/sysctl.d/k8s.conf << EOF
net.bridge.bridge-nf-call-iptables = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward = 1
EOF
sudo sysctl --system
```
**Explanation:** Enables bridged traffic processing by iptables and IPv4 forwarding, required for pod networking.

### Step 5: Install Container Runtime (containerd)
```bash
sudo apt install -y containerd
sudo mkdir -p /etc/containerd
sudo containerd config default | sudo tee /etc/containerd/config.toml
sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml
sudo systemctl restart containerd
sudo systemctl enable containerd
```
**Explanation:** Containerd is a lightweight container runtime supported by Kubernetes. The configuration ensures proper runtime settings.

### Step 6: Add Kubernetes APT Repository
```bash
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl gpg
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.32/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.32/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
```
**Explanation:** Adds the official Kubernetes v1.32 repository for installing kubeadm, kubelet, and kubectl.

### Step 7: Install Kubernetes Components
```bash
sudo apt-get install -y kubelet=1.32.* kubeadm=1.32.* kubectl=1.32.*
sudo apt-mark hold kubelet kubeadm kubectl
```
**Explanation:** Installs kubelet (node agent), kubeadm (cluster bootstrap tool), and kubectl (command-line interface). Holding the packages prevents accidental upgrades.

### Step 8: Set Hostname (if not already set)
```bash
sudo hostnamectl set-hostname "k8s-master01"
exec bash
```

### Step 9: Initialize Control-Plane Node
```bash
sudo kubeadm init --pod-network-cidr=10.244.0.0/16
```
**Explanation:** Initializes the master node. `--pod-network-cidr` is required for the network plugin.

### Step 10: Configure kubectl
```bash
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```
**Explanation:** Setting up kubeconfig allows kubectl to manage the cluster.

### Step 11: Install Pod Network Plugin (Calico)
```bash
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.29.1/manifests/calico.yaml
```
**Explanation:** Enables pod-to-pod communication across the cluster. After installation, nodes should transition to Ready.

### Step 12: Configure Firewall (UFW) - Optional for WSL
```bash
sudo ufw enable
sudo ufw allow ssh
sudo ufw allow 6443/tcp
sudo ufw allow 2379:2380/tcp
sudo ufw allow 10250/tcp
sudo ufw allow 10257/tcp
sudo ufw allow 10259/tcp
sudo ufw allow 4789/udp
sudo ufw allow 179/tcp
sudo ufw allow from 10.244.0.0/16
```
**Explanation:** These rules ensure that Kubernetes API, etcd, kubelet, and Calico networking can function correctly.

### Step 13: Remove Taint from Control-Plane Node (for Single Node)
```bash
kubectl taint nodes --all node-role.kubernetes.io/control-plane-
```
**Explanation:** By default, control-plane nodes are tainted to prevent scheduling workloads. For a single node cluster, remove this taint to allow pods to run on the control-plane node.

## Verification Commands
```bash
# Check node status
kubectl get nodes

# Check all pods
kubectl get pods -A

# Check cluster info
kubectl cluster-info

# Verify versions
kubectl version
kubeadm version
```

