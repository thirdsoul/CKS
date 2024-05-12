openssl genrsa -out 60099.internal.users.key 2048
openssl req -new -key 60099.internal.users.key -out 60099.internal.users.csr -subj "/CN=60099@internal.users"

#manual way
sudo openssl x509 -req -in 60099.internal.users.csr -set_serial 01 -out 60099.internal.users.crt -CA /etc/kubernetes/pki/ca.crt -CAkey /etc/kubernetes/pki/ca.key

#automatic way

CSR=$(cat 60099.internal.users.csr | base64 -w 0)  #Otra manera de hacer el comando cat 60099.internal.users.csr | base64 | tr -d "\n"

cat <<EOF | kubectl apply -f -
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: "60099"
spec:
  request: $CSR
  signerName: kubernetes.io/kube-apiserver-client
  expirationSeconds: 86400  # one day
  usages:
  - client auth
EOF
kubectl certificates approve request-60099

#download cert of automatic way
k get certificatesigningrequests request-60099 -o jsonpath='{.status.certificate}' | base64 --decode > 60099.internal.users.kube.crt

#Add it to kube config
kubectl config set-credentials --client-certificate 60099.internal.users.kube.crt --client-key 60099.internal.users.key --embed-certs true
kubectl config set-context 600999 --cluster kubernetes --user 600999
kubectl config use-context 600999

#Call through curl (It is going to return 403 because we have not set RBAC authz)
curl https://172.31.38.56:6443/api/v1/pods --cert 60099.internal.users.crt --key 60099.internal.users.key --cacert /etc/kubernetes/pki/ca.crt -H "Host: kubernetes"
