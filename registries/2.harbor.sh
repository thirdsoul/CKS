helm repo add harbor https://helm.goharbor.io
helm pull harbor/harbor
mkdir harbor
mv harbor-1.14.1.tgz harbor
tar -xvf harbor-1.14.1.tgz .
vi harbor/values.yaml


#create secret with tls created in step 1
#configure a secret
kubectl create ns harbor;

#No sirve porque es la primera instalacion
#helm upgrade -f harborvalues.yaml harborinitial harbor/harbor

helm install -f harborvalues.yaml harborinitial harbor/harbor;

#2024-04-06T17:50:16Z [INFO] [/pkg/config/rest/rest.go:47]: get configuration from url: https://harborinitial-core:443/api/v2.0/internalconfig
# 2024-04-06T17:50:16Z [ERROR] [/pkg/config/rest/rest.go:50]: 
#Failed on load rest config err:Get "https://harborinitial-core:443/api/v2.0/internalconfig": 
#dial tcp xxxx.zzzz.yyyy:443: connect: connection refused, 
#url:https://harborinitial-core:443/api/v2.0/internalconfig
# panic: failed to load configuration, error: failed to load rest config

# goroutine 1 [running]:
# main.main()
#         /harbor/src/jobservice/main.go:44 +0x3ae
helm uninstall harborinitial


helm install -f harborvalues.yaml harbor harbor/harbor;


#create secret for users
k create secret docker-registry dckcredentials --docker-username pepe --docker-password pepa --docker-email pepe:pepa --docker-server test.com
