#Configure kubeconfig remoteaccess with a specific user that we created in 1.create-user.sh

#First we get our clusterconfiguration
	# • Generate a cluster.conf
kubectl get cm kubeadm-config -n kube-system -o=jsonpath="{.data.ClusterConfiguration}" > /tmp/cluster.conf;

#We modify the information and add information about our cluster API endpoint location.

#   EXAMPLE
# 	apiVersion: kubeadm.k8s.io/v1beta3
# 	kind: ClusterConfiguration
# 	# Will be used as the target "cluster" in the kubeconfig
# 	clusterName: "kubernetes"
# 	# Will be used as the "server" (IP or DNS name) of this cluster in the kubeconfig
# 	controlPlaneEndpoint: "k8sapi.test.com:6443"
# 	# The cluster CA key and certificate will be loaded from this local directory
#   certificatesDir: "/etc/kubernetes/pki"

#We create kubeconfig file for user test-admin in namespace test
sudo kubeadm kubeconfig user --client-name system:serviceaccount:test:test-admin --config /tmp/cluster.conf > /tmp/test-admin.kubeconfig;

#We configure a jumper server or kubectl for this user moving this file. 
scp user@k8smaster:/tmp/test-admin.kubeconfig /tmp/test-admin.kubeconfig
kubectl get pods --config /tmp/test-admin.kubeconfig

#Other option is configuring in host default kubeconfig a new user and a new context.

