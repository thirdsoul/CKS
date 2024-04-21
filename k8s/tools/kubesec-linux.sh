#Check last version in kubesec
#https://github.com/controlplaneio/kubesec/releases

#download kubesec
mkdir kubesec/;
wget https://github.com/controlplaneio/kubesec/releases/download/v2.14.0/kubesec_linux_amd64.tar.gz;
tar -xf kubesec_linux_amd64.tar.gz --directory kubesec/;
sudo mv kubesec/kubesec /usr/bin/;


#We can launch kubesec scan vs any manifest resource and vs static control plane manifests
sudo kubesec scan /etc/kubernetes/manifests/etcd.yaml
sudo kubesec scan /etc/kubernetes/manifests/kube-apiserver.yaml
#(...)

#Example output...
# [
#   {
#     "object": "Pod/kube-apiserver.kube-system",
#     "valid": true,
#     "fileName": "/etc/kubernetes/manifests/kube-apiserver.yaml",
#     "message": "Failed with a score of -8 points",
#     "score": -8,
#     "scoring": {
#       "critical": [
#         {
#           "id": "HostNetwork",
#           "selector": ".spec .hostNetwork == true",
#           "reason": "Sharing the host's network namespace permits processes in the pod to communicate with processes bound to the host's loopback adapter",
#           "points": -9
#         }
#       ],
#       "passed": [
#         {
#           "id": "RequestsCPU",
#           "selector": "containers[] .resources .requests .cpu",
#           "reason": "Enforcing CPU requests aids a fair balancing of resources across the cluster",
#           "points": 1
#         }
#       ],
#       "advise": [
#         {
#           "id": "ApparmorAny",
#           "selector": ".metadata .annotations .\"container.apparmor.security.beta.kubernetes.io/nginx\"",
#           "reason": "Well defined AppArmor policies may provide greater protection from unknown threats. WARNING: NOT PRODUCTION READY",
#           "points": 3
#         },
