kube-apiserver
--encryption-provider-config=/etc/kubernetes/enc/enc.yaml

#check it is really encrypted (PREVIOUS SECRETS are not encrypted only the new ones)
kubectl -n kube-system exec -it etcd-cp -- sh -c "ETCDCTL_API=3 ETCDCTL_CACERT=/etc/kubernetes/pki/etcd/ca.crt \
ETCDCTL_CERT=/etc/kubernetes/pki/etcd/server.crt \ETCDCTL_KEY=/etc/kubernetes/pki/etcd/server.key etcdctl \
--endpoints=https://127.0.0.1:2379 get /registry/secrets/default/first"

#You can recreate the secrets...
kubectl get secrets --all-namespaces -o json | kubectl replace -f -

# ---
# apiVersion: apiserver.config.k8s.io/v1
# kind: EncryptionConfiguration
# resources:
#   - resources:
#       - secrets
#       - configmaps
#       - pandas.awesome.bears.example
#     providers:
#       - aescbc:
#           keys:
#             - name: key1
#               # See the following text for more details about the secret value
#               secret: <BASE 64 ENCODED SECRET>
#       - identity: {} # this fallback allows reading unencrypted secrets;
#                      # for example, during initial migration


#Mount the EncryptionConfiguration file in static manifest
#     - name: enc                           # add this line
#       mountPath: /etc/kubernetes/enc      # add this line
#       readOnly: true                      # add this line
#   volumes:
#   - name: enc                             # add this line
#     hostPath:                             # add this line
#       path: /etc/kubernetes/enc           # add this line
#       type: DirectoryOrCreate             # add this line

