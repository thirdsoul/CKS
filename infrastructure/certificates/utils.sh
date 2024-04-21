#check if a certificate and a key match, both need to answer the same output
openssl x509 -noout -modulus -in harbor.dominio.net.crt | openssl md5
openssl rsa -noout -modulus -in harbor.dominio.net.key | openssl md5

openssl s_client --connect xxx.zzzzz.yyy:443


#Access from proxy in jumper
kubectl proxy
http://localhost:8001/api/v1/namespaces/harbor/services/https:dominio-harbor-portal:/proxy/account/sign-in?redirect_url=%2Fharbor%2Fprojects


#check socket for cri
cat /etc/crictl.yaml
# runtime-endpoint: "unix:///var/run/containerd/containerd.sock"
# image-endpoint: ""
# timeout: 0
# debug: false
# pull-image-on-create: false
# disable-pull-on-run: false

#create CA
openssl genrsa -out rootCAKey.pem 2048
openssl req -x509 -sha256 -new -nodes -key rootCAKey.pem -days 3650 -out rootCACert.pem


#create client certificate
openssl genrsa -out client.key 4096;
openssl req -sha512 -new -subj "/CN=harbor.dominio.net" -key client.key -out client.csr;
openssl x509 -req -sha512 -days 365 -extfile v3.ext -CA ca.crt -CAkey ca.key -in client.csr -out client.crt;

#get server certificate
openssl s_client -showcerts -connect harbor.dominio.net:30003 < /dev/null | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p'

#install nginx
sudo yum install nginx

#configure reverse proxy
# server {
#     listen 443 ssl;
#     server_name harbor.dominio.net;

#     # SSL certificate paths
#     ssl_certificate /home/ec2-user/data/certs/harbor.dominio.net.pem;
#     ssl_certificate_key /home/ec2-user/data/certs/harbor.dominio.net.key;

#     # Add HSTS header for security
#     add_header Strict-Transport-Security "max-age=31536000" always;

#     location / {
#         # Set headers for reverse proxy
#         proxy_set_header X-Real-IP $remote_addr;
#         proxy_set_header X-Forwarded-Host $host;
#         proxy_set_header X-Forwarded-Port $server_port;

#         # Reverse proxy to backend server (replace with your IP and port)
#         proxy_pass https://xxx.zzz.yyy:443;
#         proxy_buffering off;  # Disable buffering for real-time applications
#     }
# }
sudo systemctl daemon-reload
sudo systemctl restart nginx
