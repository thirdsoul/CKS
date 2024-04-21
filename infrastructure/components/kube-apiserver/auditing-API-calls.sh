kube-apiserver.yaml
spec:
  containers:
  - command:
    - kube-apiserver
    - --audit-policy-file=/etc/kubernetes/simple-policy.yaml
    - --audit-log-path=/var/log/audit.log
    - --audit-log-maxbackup=2
    - --audit-log-maxage=7
    - --audit-log-maxsize=200

    # Auditing is enabled by editing the kube-apiserver yaml file and adding new parameters to be passed. 
    # Depending on what is being logged, the files may quickly grow to be quite large. 
    # Plan on using log rotation and keeping some number of previous logs and discarding the rest.

--audit-policy-file #Audit configuration file location inside kube-apiserver container
--audit-log-path #Audit logs location inside kube-apiserver container (wise to have a mount file)
--audit-log-maxbackup #Maximum number of log files to retain
--audit-log-maxage #How many days logs are retained
--audit-log-maxsize #Rotation size