#AQUASEC TRACEE
#Needs bind permissions in read only mode to
#/tmp/tracee (Default workspace)
#/lib/modules (Kernel headers)
#/usr/src (Kernel headers)

#Additional capabilities
#privileged

#In docker
docker run --name tracee -it --rm \
  --pid=host --cgroupns=host --privileged \
  -v /etc/os-release:/etc/os-release-host:ro \
  -v /var/run:/var/run:ro \
  aquasec/tracee:latest

#In kubernetes
helm repo add aqua https://aquasecurity.github.io/helm-charts/
helm repo update
helm install tracee aqua/tracee --namespace tracee --create-namespace

kubectl logs --follow --namespace tracee daemonset/tracee

#Test a fileless execution
kubectl run tracee-tester --image=aquasec/tracee-tester -- TRC-105

#Check with tracee
kubectl logs -f ds/tracee -n tracee | grep fileless_execution 