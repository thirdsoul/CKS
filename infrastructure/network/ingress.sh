kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/\controller-v1.8.1/deploy/static/provider/cloud/deploy.yaml
kubectl get deploy -n ingress-nginx
kubectl -n ingress-nginx get pod --field-selector=status.phase=Running
kubectl get svc -n ingress-nginx
kubectl create deployment tester --image nginx:alpine
kubectl get pod
hostname -i
ip add show ens4  #In aws is eth0

kubectl apply -f - <<EOF
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: tester
spec:
  ingressClassName: nginx
  rules:
  - host: example.io
    http:
      paths:
      - pathType: Prefix
        path: "/"
        backend:
          service:
            name: tester
            port:
              number: 80
EOF


kubectl get ing

kubectl get svc -A
#ingress-nginx   ingress-nginx-controller  LoadBalancer   10.100.234.183   <pending>     80:31234/TCP,443:30530/TCP   95m

curl -kv http://10.100.234.183 -H 'Host: example.io'

#or use host and nodeport on all hosts
kubectl get no -o wide
curl -kv http://ip-master:svc-nodeport -H 'Host: example.io'
curl -kv http://ip-worker:svc-nodeport -H 'Host: example.io'


#SECURING THE INGRESS
openssl req -x509 \
-newkey rsa:2048 \
-keyout example.key \
-out example.out \
-days 365 \
-nodes \
-subj "/C=US/ST=Ohio/L=Columbus/O=LFtraining/CN=example.io"

kubectl create secret tls example \
--key="example.key" \
--cert="example.crt"

kubectl apply -f - <<EOF
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: tester
spec:
  ingressClassName: nginx
  tls:
  - hosts:
    - example.io
    secretName: example
  rules:
  - host: example.io
    http:
      paths:
      - pathType: Prefix
        path: "/"
        backend:
          service:
            name: tester
            port:
              number: 80
EOF

curl https://example.io -kv --resolve example.io:443:10.100.234.183
# * Added example.io:443:10.100.234.183 to DNS cache
# * Hostname example.io was found in DNS cache
# *   Trying 10.100.234.183:443...
# * TCP_NODELAY set
# * Connected to example.io (10.100.234.183) port 443 (#0)
# * ALPN, offering h2
# * ALPN, offering http/1.1
# * successfully set certificate verify locations:
# *   CAfile: /etc/ssl/certs/ca-certificates.crt
#   CApath: /etc/ssl/certs
# * TLSv1.3 (OUT), TLS handshake, Client hello (1):
# * TLSv1.3 (IN), TLS handshake, Server hello (2):
# * TLSv1.3 (IN), TLS handshake, Encrypted Extensions (8):
# * TLSv1.3 (IN), TLS handshake, Certificate (11):
# * TLSv1.3 (IN), TLS handshake, CERT verify (15):
# * TLSv1.3 (IN), TLS handshake, Finished (20):
# * TLSv1.3 (OUT), TLS change cipher, Change cipher spec (1):
# * TLSv1.3 (OUT), TLS handshake, Finished (20):
# * SSL connection using TLSv1.3 / TLS_AES_256_GCM_SHA384
# * ALPN, server accepted to use h2
# * Server certificate:
# *  subject: O=Acme Co; CN=Kubernetes Ingress Controller Fake Certificate
# *  start date: Apr 27 11:18:37 2024 GMT
# *  expire date: Apr 27 11:18:37 2025 GMT
# *  issuer: O=Acme Co; CN=Kubernetes Ingress Controller Fake Certificate
# *  SSL certificate verify result: unable to get local issuer certificate (20), continuing anyway.
# * Using HTTP2, server supports multi-use
# * Connection state changed (HTTP/2 confirmed)
# * Copying HTTP/2 data in stream buffer to connection buffer after upgrade: len=0
# * Using Stream ID: 1 (easy handle 0x5583a547f0e0)
# > GET / HTTP/2
# > Host: example.io
# > user-agent: curl/7.68.0
# > accept: */*
# >
# * TLSv1.3 (IN), TLS handshake, Newsession Ticket (4):
# * TLSv1.3 (IN), TLS handshake, Newsession Ticket (4):
# * old SSL session ID is stale, removing
# * Connection state changed (MAX_CONCURRENT_STREAMS == 128)!
# < HTTP/2 200
# < date: Sat, 27 Apr 2024 13:06:43 GMT
# < content-type: text/html
# < content-length: 615
# < last-modified: Tue, 16 Apr 2024 15:47:06 GMT
# < etag: "661e9d7a-267"
# < accept-ranges: bytes
# < strict-transport-security: max-age=15724800; includeSubDomains
# <
# <!DOCTYPE html>
# <html>
# <head>
# <title>Welcome to nginx!</title>

