# Works on Ubuntu 18.0.4.x
cat > /etc/docker/daemon.json <<EOF\n{\n  "exec-opts": ["native.cgroupdriver=systemd"],\n  "log-driver": "json-file",\n  "log-opts": {\n    "max-size": "100m"\n  },\n  "storage-driver": "overlay2"\n}\nEOF
cat <<EOF | tee /boot/firmware/cmdline.txt cgroup_enable=cpuset\ncgroup_enable=memory\ncgroup_memory=1\nswapaccount=1\nEOF
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf net.bridge.bridge-nf-call-ip6tables = 1\nnet.bridge.bridge-nf-call-iptables = 1\nEOF
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list deb https://apt.kubernetes.io/ kubernetes-xenial main\nEOF
apt update && sudo apt install -y kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl

TOKEN=$(sudo kubeadm token generate)
echo $TOKEN
kubeadm init --token=${TOKEN} --kubernetes-version=v1.18.2 --pod-network-cidr=10.244.0.0/16
