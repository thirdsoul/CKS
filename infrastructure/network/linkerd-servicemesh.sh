#Understanding Service Mesh
#https://buoyant.io/service-mesh-manifesto
#https://medium.com/@martin.hodges/why-do-i-need-a-service-mesh-as-well-as-a-cni-829b492398b7

#deploy Linkerd Edge

wget https://run.linkerd.io/install-edge
vim install-edge #to check versions
chmod 775 install-edge
./install-edge

#Linkerd edge-20.9.2 was successfully installed 🎉


#Add the linkerd CLI to your path with:
export PATH=$PATH:/home/ubuntu/.linkerd2/bin

linkerd check --pre                         # validate that Linkerd can be installed
linkerd install --crds | kubectl apply -f - # install the Linkerd CRDs
linkerd install | kubectl apply -f -        # install the control plane into the 'linkerd' namespace
linkerd check                               # validate everything worked!

#You can also obtain observability features by installing the viz extension:

  linkerd viz install | kubectl apply -f -  # install the viz extension into the 'linkerd-viz' namespace
  linkerd viz check                         # validate the extension works!
  linkerd viz dashboard                     # launch the dashboard

#check api services if they are updated
kubectl get apiservices | egrep linkerd

#INSTALL CONSOLE
kubectl label nodes --all role=ingress-controller
kubectl -n linkerd-viz get pod
kubectl -n linkerd-viz edit deployments.apps web #SET --enforced-host to -enforced-host=
kubectl -n linkerd-viz get pod
linkerd viz dashboard &
kubectl -n linkerd-viz edit svc web
kubectl -n linkerd-viz get svc

kubectl create deployment test --image=nginx --dry-run=client -o yaml
kubectl create deployment test --image=nginx --dry-run=client -o yaml | linkerd inject -
kubectl create deployment test --image=nginx --dry-run=client -o yaml | linkerd inject - | kubectl create -f -


#create dnsutils with linkerd mesh
kubectl create -f https://k8s.io/examples/admin/dns/dnsutils.yaml --dry-run=client -o yaml | linkerd inject - | kubectl create -f -

#And check in the console accessed externally all the goodies

#To uninstall you have to delete all the pods with sidecar and delete the annotation in all the deployments...
linkerd-viz uninstall | kubectl delete -f -
linkerd uninstall | kubectl delete -f -


#More good stuff
#https://linkerd.io/2.15/tasks/configuring-retries/




while true;do echo 'exit' | curl -v telnet://redis:6379; done;



