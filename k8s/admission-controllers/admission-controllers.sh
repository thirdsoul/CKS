#AdmissionControllers
# - AlwaysPullImages
# - DefaultStorageClass
# - EventRateLimit
# - NamespaceExists
# - NamespaceAutoProvision
# ...

kube-apiserver
    --enable-admission-plugins=NodeRestriction,NamespaceAutoProvision
    --disable-admission-plugins=DefaultStorageClass
#   --enable-admission-plugins 
    #strings admission plugins that should be enabled in addition to 
                             #default enabled ones 
    NamespaceLifecycle, 
    LimitRanger, 
    ServiceAccount,  #Mutating and Validating. Important to enable. This admission controller implements automation for serviceAccounts.
    TaintNodesByCondition, 
    Priority, 
    DefaultTolerationSeconds, 
    DefaultStorageClass, 
    StorageObjectInUseProtection, 
    PersistentVolumeClaimResize, #This admission controller prevents resizing of all claims by default unless a claim's StorageClass explicitly enables resizing by setting allowVolumeExpansion to true
    RuntimeClass,   #Mutating and Validating. For Pods that have a RuntimeClass configured and selected in their .spec, 
                    #this admission controller sets .spec.overhead in the Pod based on the value defined in the corresponding RuntimeClass
    CertificateApproval, 
    CertificateSigning, 
    CertificateSubjectRestriction, 
    DefaultIngressClass, 
    MutatingAdmissionWebhook, 
    ValidatingAdmissionWebhook, 
    ResourceQuota. #Validating. ensure that it does not violate any of the constraints enumerated in the ResourceQuota object in a Namespace
                   # If you are using ResourceQuota objects in your Kubernetes deployment, you MUST use this admission controller

                            #To enable
    AlwaysAdmit,  #deprecated - same behaviour that not specified
    AlwaysDeny,   #deprecated - rejects all request, no meaning
    AlwaysPullImages,   #Mutating and Validating. imagePullPolicy: Always
    CertificateApproval,   #Validating. observes requests to approve CertificateSigningRequest resources
    CertificateSigning,    #Validating. observes updates to the status.certificate field of CertificateSigningRequest 
    CertificateSubjectRestriction, #Validating rejects any CertificateSigningRequest that specifies a 'group' (or 'organization attribute') of system:masters
    DefaultIngressClass,  #Mutating. automatically adds a default ingress class in new Ingress.
    DefaultStorageClass,   #Mutating. adds a default storage class in new PersistentVolumeClaim.
    DefaultTolerationSeconds,   #Mutating. sets the default forgiveness toleration for pods to tolerate the taints notready:NoExecute and unreachable:NoExecute
    DenyEscalatingExec,  
    DenyExecOnPrivileged, 
    EventRateLimit,   #Validating. Mitigate the problem when API server gets flooded by requests to store new Events
    ExtendedResourceToleration, #Mutating. When you have nodes with specific taints of resources, automatically add tolerations to pods requesting those resources.
    ImagePolicyWebhook,  #Validating. allows a backend webhook to make admission decisions
    LimitPodHardAntiAffinityTopology, #Validating. controller denies any pod that defines AntiAffinity topology key
    LimitRanger, #Mutating and Validating. ensure Request that it does not violate any of the constraints enumerated in the LimitRange object in a Namespace
                 #If you are using LimitRange objects in your Kubernetes deployment, you MUST use this admission controller to enforce those constraints. 
                 #LimitRanger can also be used to apply default resource requests to Pods that don't specify any; 
    MutatingAdmissionWebhook, 
    NamespaceAutoProvision,   #Mutating. It creates a namespace if it cannot be found
    NamespaceExists,     #Validating. If the namespace referenced from a request doesn't exist, the request is rejected
    NamespaceLifecycle,  #Validating.  This admission controller enforces that a Namespace that is undergoing termination cannot have new objects created in it, 
                         #and ensures that requests in a non-existent Namespace are rejected. 
                         #This admission controller also prevents deletion of three system reserved namespaces default, kube-system, kube-public.
                         #A Namespace deletion kicks off a sequence of operations that remove all objects (pods, services, etc.) in that namespace. 
                         #In order to enforce integrity of that process, WE STRONGLY RECOMMEND RUNNING THIS ADMISSION CONTROLLER
    NodeRestriction,   #Validating. Ensure kubelet works with minimal rights of modification in node and pods to do its work.
                        # limits the Node and Pod objects a kubelet can modify. In order to be limited by this admission controller, 
                        # kubelets must use credentials in the system:nodes group, with a username in the form system:node:<nodeName>. 
                        # Such kubelets will only be allowed to modify (not deleting) their own Node API object
    TaintNodesByCondition, 
    ValidatingAdmissionWebhook,
    PodSecurity  #Validating. checks new Pods before they are admitted, determines if it should be admitted 
                #based on the requested security context and the restrictions on permitted 
                #Pod Security Standards



