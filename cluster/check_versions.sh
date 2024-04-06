#check version of kubeadm, kubelet, nodes
kubectl cluster-info;
# [ec2-user@server ~]$ k cluster-info
# Kubernetes control plane is running at https://xxx.yyy.zzzz:6443
# CoreDNS is running at https://zzzz.yyyy.zzzz:6443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy

kubectl get nodes;
# [ec2-user@server ~]$ k get no
# NAME                                          STATUS     ROLES           AGE    VERSION
# a    Ready      control-plane   366d   v1.26.3
# b    NotReady   <none>          366d   v1.26.3
# c    Ready      <none>          366d   v1.26.3

kubectl version;
# [ec2-user@server ~]$ k version
# WARNING: This version information is deprecated and will be replaced with the output from kubectl version --short.  Use --output=yaml|json to get the full version.
# Client Version: version.Info{Major:"1", Minor:"26", GitVersion:"v1.26.3", GitCommit:"9e644106593f3f4aa98f8a84b23db5fa378900bd", GitTreeState:"clean", BuildDate:"2023-03-15T13:40:17Z", GoVersion:"go1.19.7", Compiler:"gc", Platform:"linux/amd64"}
# Kustomize Version: v4.5.7
# Server Version: version.Info{Major:"1", Minor:"26", GitVersion:"v1.26.3", GitCommit:"9e644106593f3f4aa98f8a84b23db5fa378900bd", GitTreeState:"clean", BuildDate:"2023-03-15T13:33:12Z", GoVersion:"go1.19.7", Compiler:"gc", Platform:"linux/amd64"}

sudo kubeadm version;
# [ec2-user@server ~]$ sudo kubeadm version
# kubeadm version: &version.Info{Major:"1", Minor:"26", GitVersion:"v1.26.3", GitCommit:"9e644106593f3f4aa98f8a84b23db5fa378900bd", GitTreeState:"clean", BuildDate:"2023-03-15T13:38:47Z", GoVersion:"go1.19.7", Compiler:"gc", Platform:"linux/amd64"}