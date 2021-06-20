#!/bin/bash

sudo apt update
sudo apt install nfs-kernel-server jq -y
sudo mkdir -p /mnt/nfs_share/kind-pvc
sudo chown -R nobody:nogroup /mnt/nfs_share/
sudo chmod -R 777 /mnt/nfs_share/
IPs=$(kubectl get nodes -o json | jq '.items[].status.addresses[] | select(.type=="InternalIP") | .address')
IP_ARRAY=($IPs)
INTERNAL_IP=`echo ${IP_ARRAY[0]} | tr -d '"'`
SUBNET="${INTERNAL_IP%.*}"
sudo sed -i '/^\/mnt\/nfs_share/d' /etc/exports
echo "Adding NFS configuration to allow Docker containers to use NFS server"
echo "/mnt/nfs_share ${SUBNET}.0/24(rw,sync,no_subtree_check)" | sudo tee -a /etc/exports > /dev/null
sudo exportfs -a
sudo systemctl restart nfs-kernel-server
