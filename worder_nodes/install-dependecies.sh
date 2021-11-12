echo "[INFO] - Adding docker and Kubernetes Repositories"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"
echo "[INFO] - Installing doker-ce, kubelet, kubeadm, and kubectl"
sudo apt-get update
sudo apt-get install -y docker-ce=5:19.03.13~3-0~ubuntu-$(lsb_release -cs) kubelet=1.16.15-00 kubeadm=1.16.15-00 kubectl=1.16.15-00
sudo apt-mark hold docker-ce kubelet kubeadm kubectl
