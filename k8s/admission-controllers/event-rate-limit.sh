#EventRateLimit
kube-apiserver
--enable-admission-plugins EventRateLimit
--admission-control-config-file admission-control-config.yaml


apiVersion: apiserver.config.k8s.io/v1
kind: AdmissionConfiguration
plugins:
  - name: EventRateLimit
    path: eventconfig.yaml

# There are four types of limits that can be specified in the configuration:

# Server: All Event requests (creation or modifications) received by the API server share a single bucket.
# Namespace: Each namespace has a dedicated bucket.
# User: Each user is allocated a bucket.
# SourceAndObject: A bucket is assigned by each combination of source and involved object of the event.

apiVersion: eventratelimit.admission.k8s.io/v1alpha1
kind: Configuration
limits:
  - type: Namespace
    qps: 50     #qps is the number of event queries per second that are allowed for this type of limit.
    burst: 100     #burst is the burst number of event queries that are allowed for this type of limit. 
                #The qps and burst fields are used together to determine if a particular event query is accepted. 
                #The burst determines the maximum size of the allowance granted for a particular bucket. 
                #For example, if the burst is 10 and the qps is 3, then the admission control will accept 10 queries before blocking any queries. 
                #Every second, 3 more queries will be allowed. If some of that allowance is not used, then it will roll over to the next second, 
                #until the maximum allowance of 10 is reached.
    cacheSize: 2000
  - type: User
    qps: 10
    burst: 50