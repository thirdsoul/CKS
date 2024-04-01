#Create user able to list namespaces and pods in all the clusters, 
#but have all permissions in test namespace
#ns creation
kubectl create ns test;

#sa creation
kubectl create serviceaccount test-admin -n test;

#role creations
kubectl create clusterrole test-viewer --resource namespaces,pods,deploy --verb list,get;
kubectl create clusterrole test-admin --resource=* --verb=*;

#rolebindings, important to limit admin rights in namespace scope with a simple 
#rolebinding instead of clusterrolebinding
kubectl create clusterrolebinding test-viewer-binding --clusterrole test-viewer --serviceaccount test:test-admin;
kubectl create rolebinding test-admin-binding --clusterrole test-admin --serviceaccount test:test-admin -n test;

#validate permissions
kubectl auth can-i list pods --as system:serviceaccount:test:test-admin -n kube-system;
kubectl auth can-i delete pods --as system:serviceaccount:test:test-admin -n kube-system;
kubectl auth can-i delete pods --as system:serviceaccount:test:test-admin -n test;





