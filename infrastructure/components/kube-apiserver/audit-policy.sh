# API calls ->

# Events when an API call is received
# >RequestReceived -> >ResponseStarted -> >ResponseComplete  
# >Panic in case of failure

# Events compared against rules in order. First rule matched set audit level for event. 

# Audit Levels
# >None
# >Metadata
# >Request
# >RequestResponse

apiVersion: audit.k8s.io/v1
kind: Policy
rules:
- level: Metadata
  resources:
  - group: ""
    resources: ["pods/log", "pods/status"]
- level: Metadata
  omitStages:
  - "RequestReceived" 

# While there could be a single rule affecting all events, there also could be many rules in a policy file. 
# In the example above, metadata of events concerning log and status information of pods would be sent to the backend.

# The second rule would match all other events and send all information, 
# but would not send RequestReceived to the backend. As a result, watch events would not appear in the log.