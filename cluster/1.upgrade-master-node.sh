# 1. Upgrade a primary control plane node.
# 2. Upgrade additional control plane nodes.
# 3. Upgrade worker nodes


#Upgrade repository (from December 2023 this has changed)
cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/v1.28/rpm/
enabled=1
gpgcheck=1
gpgkey=https://pkgs.k8s.io/core:/stable:/v1.28/rpm/repodata/repomd.xml.key
exclude=kubelet kubeadm kubectl cri-tools kubernetes-cni
EOF

#check packages
sudo yum list --showduplicates kubeadm --disableexcludes=kubernetes

#install necessary.
sudo yum install -y kubeadm-'1.28.8-150500.1.1' --disableexcludes=kubernetes

#Verify, it should state 1.28.8
sudo kubeadm version;

# Upgrade and we got an error!!!!!
sudo kubeadm upgrade plan
#ERROR - version cant be upgraded from 1.26.3
# [upgrade/config] Making sure the configuration is correct:
# [upgrade/config] Reading configuration from the cluster...
# [upgrade/config] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -o yaml'
# [upgrade/config] FATAL: this version of kubeadm 
# only supports deploying clusters with the control plane version >= 1.27.0. Current version: v1.26.3
# To see the stack trace of this error execute with --v=5 or higher
#

#The problem was with the repo, pointing to 1.28. Lets point it to 1.27
cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/v1.27/rpm/
enabled=1
gpgcheck=1
gpgkey=https://pkgs.k8s.io/core:/stable:/v1.27/rpm/repodata/repomd.xml.key
exclude=kubelet kubeadm kubectl cri-tools kubernetes-cni
EOF

#install 1.27
sudo yum install -y kubeadm-'1.27.12-150500.1.1' --disableexcludes=kubernetes;

#Plan and install kubeadm
sudo kubeadm upgrade plan;
sudo kubeadm upgrade apply v1.27.12;

#drain master node
kubectl drain master --ignore-daemonsets --delete-emptydir-data --force

#Install kubelet and kubectl
sudo yum install -y kubelet-'1.27.12-150500.1.1' kubectl-'1.27.12-150500.1.1' --disableexcludes=kubernetes

#Restart kubelet process
sudo systemctl daemon-reload;
sudo systemctl restart kubelet;

#Verify
systemctl status kubelet;
journalctl -xeu kubelet;
kubectl get nodes;
# NAME                                          STATUS                     ROLES           AGE    VERSION
# ip-172-31-26-79.eu-west-2.compute.internal    Ready,SchedulingDisabled   control-plane   366d   v1.27.12
# ip-172-31-27-231.eu-west-2.compute.internal   NotReady                   <none>          366d   v1.26.3
# ip-172-31-29-63.eu-west-2.compute.internal    Ready                      <none>          366d   v1.26.3

kubectl version;
# WARNING: This version information is deprecated and will be replaced with the output from kubectl version --short.  Use --output=yaml|json to get the full version.
# Client Version: version.Info{Major:"1", Minor:"27", GitVersion:"v1.27.12", GitCommit:"12031002905c0410706974560cbdf2dad9278919", GitTreeState:"clean", BuildDate:"2024-03-15T02:15:31Z", GoVersion:"go1.21.8", Compiler:"gc", Platform:"linux/amd64"}
# Kustomize Version: v5.0.1
# Server Version: version.Info{Major:"1", Minor:"27", GitVersion:"v1.27.12", GitCommit:"12031002905c0410706974560cbdf2dad9278919", GitTreeState:"clean", BuildDate:"2024-03-15T02:06:14Z", GoVersion:"go1.21.8", Compiler:"gc", Platform:"linux/amd64"}

kubectl uncordon master;