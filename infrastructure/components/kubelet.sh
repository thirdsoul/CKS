#kubelet config file
apiVersion: kubelet.config.k8s.io/v1beta1
kind: KubeletConfiguration
authentication:
    anonymous:
        enabled: false
    x509:
        clientCAFile: /path/to/ca.crt
    mode: Webhook
    readOnlyPort: 0


#or service definition
kubelet.service
ExecStart=/usr/local/bin/kubelet \
--client-ca-file=/path/to/ca.crt  #ca.crt of kubernetes cluster (kube-apiserver at the end is a client of kubelet)
--authorization-mode=Webhook #Delegates authentication to kube-apiserver
--readOnlyPort=0 #DISABLE INSECURE PORT FOR UNAUTHENTICATED
--anonymous-auth=false   #DISABLE ANONYMOUS USERS


#In kube-apiserver we have to define client certs to connect with kubelet
kube-apiserver \
 --kubelet-client-certificate=/path/to/kubelet-cert.pem \
 --kubelet-client-key=/path/to/kubelet-key.pem
 --enable-admission-plugins=NodeRestriction
