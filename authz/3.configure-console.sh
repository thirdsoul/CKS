#Lets configure the console access for this user.
#In kubernetes-dashboard documentation it is stated how to install the console and configure dashboard admin user
# kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml
# https://github.com/kubernetes/dashboard/blob/master/docs/user/access-control/creating-sample-user.md
#This is how to configure access for our test-admin user with privileged access in namespace test


# To execute console from client and not having to open it publicly, you can proxy the requests.
kubectl proxy &
# And then dashboard will be available in 
#http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/.

# Console provides 2 authentication modes:
# Token that you get through TokenAPI , but this token is limited
kubectl create token test-admin -n test;

# Kubeconfig file
# In our previous file, 2.configure-remote-access.sh we declare how to specify a kubeconfig.
# Lets add a non-rotating token for the service account
# In order to do that we need to create a service account token Secret (use type and annotations correctly) for
# the service account test-admin
kubectl apply -f - <<EOF
apiVersion: v1
type: kubernetes.io/service-account-token
kind: Secret
metadata:
  annotations:
    kubernetes.io/service-account.name: test-admin
  name: test-admin-token
  namespace: test
EOF

#Then get the token information of this secret.
k get secret test-admin-token -n test -o jsonpath='{.data.token}';

#And copy and paste in /tmp/test-admin.kubeconfig in client in section users.token


