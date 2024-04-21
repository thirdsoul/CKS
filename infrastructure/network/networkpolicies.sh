#SETUP
kubectl create ns moon;
kubectl create ns earth;

kubectl run web --image=nginx --labels=app=web --port 80 -n moon;
kubectl expose pod web --type=ClusterIP --port=80 -n moon;
kubectl run api --image=nginx --labels=app=api --port 80 -n moon;
kubectl expose pod api --type=ClusterIP --port=80 -n moon;
kubectl run db --image=nginx --labels=app=db --port 80 -n moon;
kubectl expose pod db --type=ClusterIP --port=80 -n moon;

kubectl run web --image=nginx --labels=app=web --port 80 -n earth;
kubectl expose pod web --type=ClusterIP --port=80 -n earth;

#TEST CONNECTIVITIES (CREATE TEST CONNECTIVITY SHELL SCRIPT)
#FROM WEB.MOON
echo "From web.moon to web.earth $(kubectl exec -it web -n moon -- curl web.earth -i | head -n1)";
echo "From web.moon to api.moon $(kubectl exec -it web -n moon -- curl api.moon -i | head -n1)";
echo "From web.moon to db.moon $(kubectl exec -it web -n moon -- curl db.moon -i | head -n1)";

#FROM API.MOON
echo "From api.moon to web.earth $(kubectl exec -it web -n moon -- curl web.earth -i | head -n1)";
echo "From api.moon to web.moon $(kubectl exec -it web -n moon -- curl web.moon -i | head -n1)";
echo "From api.moon to db.moon $(kubectl exec -it web -n moon -- curl db.moon -i | head -n1)";

#FROM DB.MOON
echo "From db.moon to web.earth $(kubectl exec -it web -n moon -- curl web.earth -i | head -n1)";
echo "From db.moon to web.moon $(kubectl exec -it web -n moon -- curl web.moon -i | head -n1)";
echo "From db.moon to api.moon $(kubectl exec -it web -n moon -- curl api.moon -i | head -n1)";

#FROM WEB.EARTH
echo "From web.earth to web.moon $(kubectl exec -it web -n earth -- curl web.moon -i | head -n1)";
echo "From web.earth to api.moon $(kubectl exec -it web -n earth -- curl api.moon -i | head -n1)";
echo "From web.earth to db.moon $(kubectl exec -it web -n earth -- curl db.moon -i | head -n1)";

#All actions must be applied to moon namespace.
#FIRST EXERCISE
#Enable pod isolation: drop all connections between pods.
k apply -f - <<EOF
kind: NetworkPolicy
apiVersion: networking.k8s.io/v1
metadata:
  name: drop-all-connections
  namespace: moon
spec:
  podSelector: {}
  policyTypes: 
  - Ingress
  - Egress
EOF
 
#Allow all traffic between pods in moon namespace
k apply -f - <<EOF
kind: NetworkPolicy
apiVersion: networking.k8s.io/v1
metadata:
  name: allow-all-connections
  namespace: moon
spec:
  ingress:
  - {}
  egress:
  - {}
  podSelector: {}
  policyTypes: 
  - Ingress
  - Egress
EOF

#Improve pod isolation from 1. , by adding egress traffic to DNS for all pods ONLY to DNS port 53.
k apply -f - <<EOF
kind: NetworkPolicy
apiVersion: networking.k8s.io/v1
metadata:
  name: allow-only-egress-dns
  namespace: moon
spec:
  egress:
  - ports:
    - protocol: TCP
      port: 53
    - protocol: UDP
      port: 53
  podSelector: {}
  policyTypes: 
  - Egress
EOF

#web pod: enable ingress for everyone and egress to api pod only.
k apply -f - <<EOF
kind: NetworkPolicy
apiVersion: networking.k8s.io/v1
metadata:
  name: allow-only-egress-api
  namespace: moon
spec:
  ingress:
  - {}
  egress:
  - to:
    - podSelector:
        matchLabels:
          app: api
  podSelector:
    matchLabels:
      app: web
  policyTypes: 
  - Egress
  - Ingress
EOF

#api pod: enable ingress from web pod and egress to db pod.
k apply -f - <<EOF
kind: NetworkPolicy
apiVersion: networking.k8s.io/v1
metadata:
  name: allow-api
  namespace: moon
spec:
  ingress:
  - from:
    - podSelector:
        matchLabels:
          app: web
  egress:
  - to:
    - podSelector:
        matchLabels:
          app: db
  podSelector:
    matchLabels:
      app: api
  policyTypes: 
  - Egress
  - Ingress
EOF

#db pod: ingress from api pod only.
k apply -f - <<EOF
kind: NetworkPolicy
apiVersion: networking.k8s.io/v1
metadata:
  name: allow-db
  namespace: moon
spec:
  ingress:
  - from:
    - podSelector:
        matchLabels:
          app: api
  podSelector:
    matchLabels:
      app: db
  policyTypes: 
  - Egress
  - Ingress
EOF

#Add ingress port filtering for port 80, for web / api / db pods.
k apply -f - <<EOF
kind: NetworkPolicy
apiVersion: networking.k8s.io/v1
metadata:
  name: allow-db
  namespace: moon
spec:
  ingress:
  - ports:
    - protocol: TCP
      port: 80
    - protocol: UDP
      port: 80
    from:
    - podSelector:
        matchExpressions:
        -  key: app
           operator: In
           values:
           - db
           - api
           - web
  podSelector: {}
  policyTypes: 
  - Ingress
EOF

#web pod must have ingress and egress internet access (use external services to work properly), 
#but must deny egress access to any pod inside of the k8s cluster, except api pod (which already done previously) in the same namespace.
k apply -f - <<EOF
kind: NetworkPolicy
apiVersion: networking.k8s.io/v1
metadata:
  name: allow-db
  namespace: moon
spec:
  egress:
  - to:
    - podSelector:
        matchLabels:
          app: db
    - ipBlock:
        cidr: 0.0.0.0/0
        except:
            - 10.0.0.0/8
            - 192.168.0.0/16
            - 172.16.0.0/20
  ingress:
  - {}
  podSelector: 
    matchLabels: 
      app: web
  policyTypes: 
  - Ingress
  - Egress
EOF
