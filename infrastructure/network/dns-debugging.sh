kubectl apply -f https://k8s.io/examples/admin/dns/dnsutils.yaml
kubectl get pods dnsutils
kubectl exec -i -t dnsutils -- nslookup kubernetes.default
kubectl exec -ti dnsutils -- cat /etc/resolv.conf
kubectl exec -i -t dnsutils -- nslookup kubernetes.default
kubectl get pods --namespace=kube-system -l k8s-app=kube-dns
kubectl logs --namespace=kube-system -l k8s-app=kube-dns
kubectl get svc --namespace=kube-system
kubectl get endpoints kube-dns --namespace=kube-system
kubectl -n kube-system edit configmap coredns
#add log
# apiVersion: v1
# kind: ConfigMap
# metadata:
#   name: coredns
#   namespace: kube-system
# data:
#   Corefile: |
#     .:53 {
#         log
#         errors
#         health
#         kubernetes cluster.local in-addr.arpa ip6.arpa {
#           pods insecure
#           upstream
#           fallthrough in-addr.arpa ip6.arpa
#         }
#         prometheus :9153
#         forward . /etc/resolv.conf
#         cache 30
#         loop
#         reload
#         loadbalance
#     }  

kubectl describe clusterrole system:coredns -n kube-system
