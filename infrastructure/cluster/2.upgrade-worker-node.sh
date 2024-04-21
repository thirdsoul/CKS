#Update repo
cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/v1.27/rpm/
enabled=1
gpgcheck=1
gpgkey=https://pkgs.k8s.io/core:/stable:/v1.27/rpm/repodata/repomd.xml.key
exclude=kubelet kubeadm kubectl cri-tools kubernetes-cni
EOF

#Install kubeadm
sudo yum install -y kubeadm-'1.27.12-150500.1.1' --disableexcludes=kubernetes;

#Actualizar nodo
sudo kubeadm upgrade node

#OJO HA FALLADO EN NODE2. tendre que mirar Node Authorization
# [upgrade] Reading configuration from the cluster...
# [upgrade] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -o yaml'
# unable to fetch the kubeadm-config ConfigMap: failed to get config map: Unauthorized
# To see the stack trace of this error execute with --v=5 or higher

#drain node 1 (From master)
kubectl drain node2 --ignore-daemonsets --delete-emptydir-data

#Install kubelet and kubectl
sudo yum install -y kubelet-'1.27.12-150500.1.1' kubectl-'1.27.12-150500.1.1' --disableexcludes=kubernetes

#Restart kubelet process
sudo systemctl daemon-reload;
sudo systemctl restart kubelet;

#uncordon (FROM MASTER)
kubectl uncordon node2;