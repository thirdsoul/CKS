#check version of kubeadm, kubelet, nodes
kubectl cluster-info;
# [ec2-user@ip-172-31-26-79 ~]$ k cluster-info
# Kubernetes control plane is running at https://172.31.26.79:6443
# CoreDNS is running at https://172.31.26.79:6443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy

kubectl get nodes;
# [ec2-user@ip-172-31-26-79 ~]$ k get no
# NAME                                          STATUS     ROLES           AGE    VERSION
# ip-172-31-26-79.eu-west-2.compute.internal    Ready      control-plane   366d   v1.26.3
# ip-172-31-27-231.eu-west-2.compute.internal   NotReady   <none>          366d   v1.26.3
# ip-172-31-29-63.eu-west-2.compute.internal    Ready      <none>          366d   v1.26.3

kubectl version;
# [ec2-user@ip-172-31-26-79 ~]$ k version
# WARNING: This version information is deprecated and will be replaced with the output from kubectl version --short.  Use --output=yaml|json to get the full version.
# Client Version: version.Info{Major:"1", Minor:"26", GitVersion:"v1.26.3", GitCommit:"9e644106593f3f4aa98f8a84b23db5fa378900bd", GitTreeState:"clean", BuildDate:"2023-03-15T13:40:17Z", GoVersion:"go1.19.7", Compiler:"gc", Platform:"linux/amd64"}
# Kustomize Version: v4.5.7
# Server Version: version.Info{Major:"1", Minor:"26", GitVersion:"v1.26.3", GitCommit:"9e644106593f3f4aa98f8a84b23db5fa378900bd", GitTreeState:"clean", BuildDate:"2023-03-15T13:33:12Z", GoVersion:"go1.19.7", Compiler:"gc", Platform:"linux/amd64"}

sudo kubeadm version;
# [ec2-user@ip-172-31-26-79 ~]$ sudo kubeadm version
# kubeadm version: &version.Info{Major:"1", Minor:"26", GitVersion:"v1.26.3", GitCommit:"9e644106593f3f4aa98f8a84b23db5fa378900bd", GitTreeState:"clean", BuildDate:"2023-03-15T13:38:47Z", GoVersion:"go1.19.7", Compiler:"gc", Platform:"linux/amd64"}