#!/bin/sh

# create a cluster with the local registry enabled in containerd
cat <<EOF | kind create cluster --config=-
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
networking:
  apiServerAddress: "127.0.0.1"
  apiServerPort: 6443
  kubeProxyMode: "ipvs"
nodes:
- role: control-plane
  extraPortMappings:
  - containerPort: 30000 
    hostPort: 80
- role: worker
  extraMounts:
  - hostPath: /mnt/nfs_share/kind-pvc
    containerPath: /var/local-path-provisioner
EOF

kubectl cluster-info --context kind-kind