#Checking expiration for kubernetes control plane certificates
sudo kubeadm certs check-expiration;

#This was a mess!
# CERTIFICATE                EXPIRES                  RESIDUAL TIME   CERTIFICATE AUTHORITY   EXTERNALLY MANAGED
# admin.conf                 Apr 01, 2024 14:33 UTC   <invalid>       ca                      no
# apiserver                  Jan 12, 2025 13:55 UTC   284d            ca                      no
# apiserver-etcd-client      Apr 01, 2024 14:33 UTC   <invalid>       etcd-ca                 no
# apiserver-kubelet-client   Apr 01, 2024 14:33 UTC   <invalid>       ca                      no
# controller-manager.conf    Apr 01, 2024 14:33 UTC   <invalid>       ca                      no
# etcd-healthcheck-client    Apr 01, 2024 14:33 UTC   <invalid>       etcd-ca                 no
# etcd-peer                  Apr 01, 2024 14:33 UTC   <invalid>       etcd-ca                 no
# etcd-server                Apr 01, 2024 14:33 UTC   <invalid>       etcd-ca                 no
# front-proxy-client         Apr 01, 2024 14:33 UTC   <invalid>       front-proxy-ca          no
# scheduler.conf             Apr 01, 2024 14:33 UTC   <invalid>       ca                      no

# CERTIFICATE AUTHORITY   EXPIRES                  RESIDUAL TIME   EXTERNALLY MANAGED
# ca                      Mar 30, 2033 14:33 UTC   8y              no
# etcd-ca                 Mar 30, 2033 14:33 UTC   8y              no
# front-proxy-ca          Mar 30, 2033 14:33 UTC   8y              no


#Renew all control plane certificates in the cluster
sudo kubeadm certs renew all;
#Message after renew 
#Done renewing certificates. You must restart the kube-apiserver, kube-controller-manager, 
#kube-scheduler and etcd, so that they can use the new certificates.

#Restart the processes
#Documentation states to move the manifests in kubeadm cluster to tmp location
mkdir /tmp/manifests/; sudo mv /etc/kubernetes/manifests/* /tmp/manifests/;

sudo mv /tmp/manifests/* /etc/kubernetes/manifests/;

#Now they restarted but our kube config fails.sudo 
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config;
sudo chown $(id -u):$(id -g) $HOME/.kube/config;

