# Based on https://www.howtogeek.com/devops/how-to-start-a-kubernetes-cluster-from-scratch-with-kubeadm-and-kubectl/

echo Setting up kubernetes cluster node..

echo Installing packages
sudo apt update
sudo apt install -y \
    ca-certificates \
    apt-transport-https \
    curl \
    gpg \
    lsb-release

# Get all keyrings
echo Installing keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
    sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | \
    sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes.gpg

# Add repositories
echo Add repositories
echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list
echo \
    'deb [signed-by=/etc/apt/keyrings/kubernetes.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | \
    sudo tee /etc/apt/sources.list.d/kubernetes.list

# Update and install containerd
echo Update and install containerd
sudo apt update
sudo apt install -y containerd.io

# Configure containerd and system
echo Configure containerd and system
sudo containerd config default > /etc/containerd/config.toml
sudo sed -i.old "s/SystemdCgroup = false/SystemdCgroup = true/" /etc/containerd/config.toml
sudo service containerd restart

echo Enable ip_forward
sudo sysctl -w net.ipv4.ip_forward=1

echo Install kubeadm, kubelet and kubectl
sudo apt install -y kubeadm kubelet kubectl
# prevent auto-update, as is best practice to do manually here
sudo apt-mark hold kubeadm kubelet kubectl
echo br_netfilter | sudo tee /etc/modules-load.d/kubernetes.conf
sudo modprobe br_netfilter