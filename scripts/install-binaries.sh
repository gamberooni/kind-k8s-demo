#!/bin/bash

sudo apt install curl dos2unix -y
find .. -type f -print0 | xargs -0 dos2unix

echo "Installing KinD"
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.11.0/kind-linux-amd64
sudo chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind
echo "KinD installation completed"


echo "Installing kubectl version 1.20.0"
curl -LO https://dl.k8s.io/release/v1.21.0/bin/linux/amd64/kubectl
curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
echo "$(<kubectl.sha256) kubectl" | sha256sum --check
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
kubectl version --client
sudo rm kubectl kubectl.sha256
echo "kubectl installation completed"


echo "Installing Helm 3"
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
sudo rm get_helm.sh


echo "Installing Docker engine"
echo "Docker engine already installed. Skipping installation..."
sudo apt-get update
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io -y
echo "Docker engine installation completed"


sudo usermod -aG docker $USER
newgrp docker &

echo "
Please reboot to allow changes to take effect...
Do you want to reboot now?
"
read -r -p "Are you sure? [Y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
then
    sudo reboot
else
    echo "Please do a manual reboot"
fi
