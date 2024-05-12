#https://docs.cilium.io/en/stable/operations/troubleshooting/
#https://docs.cilium.io/en/stable/operations/system_requirements/

#Troubleshooting cilium
kubectl -n kube-system get pods -l k8s-app=cilium -o wide

#detailed status in each node, k8s-cilium-exec.sh
curl -sLO https://raw.githubusercontent.com/cilium/cilium/main/contrib/k8s/k8s-cilium-exec.sh
chmod +x ./k8s-cilium-exec.sh
./k8s-cilium-exec.sh cilium-dbg status
./k8s-cilium-exec.sh cilium-dbg status --verbose


kubectl logs -n kube-system -l k8s-app=cilium


#Observing flows
#check if Hubble is enabled
./k8s-cilium-exec.sh cilium-dbg status | egrep Hubble

#check events from pod dnsutils in the last 3 minutes
kubectl exec cilium-8hrl9 -n kube-system -- hubble observe --since 3m --pod default/dnsutils
kubectl exec cilium-9hsdd -n kube-system -- hubble observe --since 3m --pod default/dnsutils

# ubuntu@ip-172-31-38-56:~$ kubectl exec cilium-9hsdd -n kube-system -- hubble observe --since 3m --pod default/dnsutils
# Defaulted container "cilium-agent" out of: cilium-agent, config (init), mount-cgroup (init), apply-sysctl-overwrites (init), mount-bpf-fs (init), clean-cilium-state (init), install-cni-binaries (init)
# Apr 27 12:12:36.125: default/dnsutils (ID:3150) -> kube-system/coredns-76f75df574-h92g8 (ID:46755) to-overlay FORWARDED (ICMPv4 EchoRequest)
# Apr 27 12:12:42.248: default/dnsutils (ID:3150) -> kube-system/coredns-76f75df574-h92g8 (ID:46755) to-overlay FORWARDED (ICMPv4 EchoRequest)
# Apr 27 12:12:48.392: default/dnsutils (ID:3150) -> kube-system/coredns-76f75df574-h92g8 (ID:46755) to-overlay FORWARDED (ICMPv4 EchoRequest)

#ICMP was not allowed in security groups!!!!

kubectl exec -ti dnsutils -- nslookup ingress-nginx-controller.ingress-nginx.svc
kubectl exec cilium-9hsdd -n kube-system -- hubble observe --since 3m --pod default/dnsutils

# Defaulted container "cilium-agent" out of: cilium-agent, config (init), mount-cgroup (init), apply-sysctl-overwrites (init), mount-bpf-fs (init), clean-cilium-state (init), install-cni-binaries (init)
# Apr 27 12:16:31.119: default/dnsutils (ID:3150) -> kube-system/coredns-76f75df574-h92g8 (ID:46755) to-overlay FORWARDED (ICMPv4 EchoRequest)
# Apr 27 12:17:46.666: default/dnsutils:36360 (ID:3150) -> kube-system/coredns-76f75df574-4r2mp:53 (ID:46755) to-overlay FORWARDED (UDP)
# Apr 27 12:17:56.667: default/dnsutils:36360 (ID:3150) -> kube-system/coredns-76f75df574-4r2mp:53 (ID:46755) to-overlay FORWARDED (UDP)

#CONNECTIVITY TEST
kubectl create ns cilium-test
kubectl apply --namespace=cilium-test -f https://raw.githubusercontent.com/cilium/cilium/1.15.4/examples/kubernetes/connectivity-check/connectivity-check.yaml

kubectl get pods -n cilium-test
# NAME                                                   READY   STATUS    RESTARTS   AGE
# echo-a-84b5975d67-pfpfj                                1/1     Running   0          38s
# echo-b-57dfc876d5-8hz8x                                1/1     Running   0          38s
# echo-b-host-ddf4976b9-mddmp                            1/1     Running   0          38s
# host-to-b-multi-node-clusterip-8d4798f9f-ft6qw         0/1     Running   0          38s
# host-to-b-multi-node-headless-54cb7b755f-gjk7z         0/1     Running   0          37s
# pod-to-a-68d9b9d5d-xt8s7                               0/1     Running   0          38s
# pod-to-a-allowed-cnp-85b8f754bd-ppdpv                  0/1     Running   0          38s
# pod-to-a-denied-cnp-5fdd4cdc58-cbtbc                   1/1     Running   0          38s
# pod-to-b-intra-node-nodeport-7b474496cf-94vp6          0/1     Running   0          37s
# pod-to-b-multi-node-clusterip-7fc54b47df-kg97m         0/1     Running   0          38s
# pod-to-b-multi-node-headless-78555bf49f-k7vkc          0/1     Running   0          38s
# pod-to-b-multi-node-nodeport-7d77d546bc-lfdxl          0/1     Running   0          37s
# pod-to-external-1111-656bc7c4d4-wr9mt                  1/1     Running   0          38s
# pod-to-external-fqdn-allow-google-cnp-f6df4f66-fdqsk   0/1     Running   0          38s


#Information about test failures can be determined by describing a failed test pod
kubectl describe pod pod-to-b-intra-node-hostport
#   Warning  Unhealthy  2m5s                kubelet            Readiness probe failed: curl: (7) Failed to connect to echo-b port 8080 after 1 ms: Connection refused
#   Warning  Unhealthy  3m12s (x3 over 3m32s)  kubelet            Liveness probe failed: curl: (6) Could not resolve host: echo-b-headless
#   Liveness:       exec [curl -sS --fail --connect-timeout 5 -o /dev/null echo-a:8080/public] delay=0s timeout=7s period=10s #success=1 #failure=3
#   Warning  Unhealthy  5m37s                  kubelet            Readiness probe failed: curl: (7) Failed to connect to echo-b port 8080 after 0 ms: Connection refused

kubectl rollout restart deploy/host-to-b-multi-node-clusterip -n cilium-test


#CHECK CONNECTIVITY CLUSTER HEALTH STATUS
kubectl exec -n kube-system -i -t cilium-8hrl9 -- cilium-health status  #from both nodes, worker and master
# Probe time:   2024-04-27T12:35:22Z
# Nodes:
#   kubernetes/ip-172-31-45-174 (localhost):
#     Host connectivity to 172.31.45.174:
#       ICMP to stack:   OK, RTT=372.402µs
#       HTTP to agent:   OK, RTT=187.331µs
#     Endpoint connectivity to 10.0.1.128:
#       ICMP to stack:   OK, RTT=379.392µs
#       HTTP to agent:   OK, RTT=383.188µs
#   kubernetes/ip-172-31-38-56:
#     Host connectivity to 172.31.38.56:
#       ICMP to stack:   OK, RTT=788.957µs
#       HTTP to agent:   Get "http://172.31.38.56:4240/hello": context deadline exceeded (Client.Timeout exceeded while awaiting headers)
#     Endpoint connectivity to 10.0.0.13:
#       ICMP to stack:   Connection timed out
#       HTTP to agent:   Get "http://10.0.0.13:4240/hello": context deadline exceeded (Client.Timeout exceeded while awaiting headers)

# Probe time:   2024-04-27T12:35:27Z
# Nodes:
#   kubernetes/ip-172-31-38-56 (localhost):
#     Host connectivity to 172.31.38.56:
#       ICMP to stack:   OK, RTT=366.708µs
#       HTTP to agent:   OK, RTT=268.083µs
#     Endpoint connectivity to 10.0.0.13:
#       ICMP to stack:   OK, RTT=333.683µs
#       HTTP to agent:   OK, RTT=296.276µs
#   kubernetes/ip-172-31-45-174:
#     Host connectivity to 172.31.45.174:
#       ICMP to stack:   OK, RTT=792.235µs
#       HTTP to agent:   Get "http://172.31.45.174:4240/hello": context deadline exceeded (Client.Timeout exceeded while awaiting headers)
#     Endpoint connectivity to 10.0.1.128:
#       ICMP to stack:   Connection timed out


#OPEN CILIUM SECURITY GROUPS and FIREWALLS!!!!
#https://docs.cilium.io/en/stable/operations/system_requirements/

kubectl exec -ti dnsutils -- nslookup ingress-nginx-controller.ingress-nginx.svc
# Server:         10.96.0.10
# Address:        10.96.0.10#53

# Name:   ingress-nginx-controller.ingress-nginx.svc.cluster.local
# Address: xxxx





















