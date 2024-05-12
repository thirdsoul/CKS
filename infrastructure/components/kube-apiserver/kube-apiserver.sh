# As you may remember, there are three phases every API call goes through as part of the kube-apiserver:

# Authentication
# Authorization
# Admission Control

# 1. Filter network access through edge and interior firewalls

# The localhost port provides a testing port with no TLS and exposes port 8080. 
# API calls via this port bypass the authentication and authorization phases of the API server.

# The secure port defaults to 6443 and will use the first non-localhost network interface. 
# In multi-interface nodes, you can use the --bind-address flag to set the interface. 
# API calls via this port use TLS and go through all three phases of the kube-apiserver.


# Authentication
# - Defaults to x.509, but webhook is popular
# - Returns a 401 error if not valid.
# Authorization
# - Defaults to RBAC for user requests
# - Defaults to Node for cluster requests
# - Returns a 403 error if the request is not authorized
# - Webhook is also popular.
# Admission controllers
# - Several compiled into the container
# - Mutating webhook.


kube-apiserver.yaml
spec:
  containers:
  - command:
    - kube-apiserver
    - --advertise-address=10.128.15.193   #This address is the one used by the entire cluster. 
                                          #If this variable is not set, it will use the bind-address variable. 
                                          #If that is not set, it will use the default interface of the host.
    
    - --allow-privileged=true             #Defaults to false, but in kubeadm defaults to true
    
    - --authorization-mode=Node,RBAC      #Authorization modes available

    - --client-ca-file=/etc/kubernetes/pki/ca.crt  #ca / Provisioned by certificates.k8s.io

    - --enable-admission-plugins=NodeRestriction
    - --disable-admission-plugins=XXX              #enable and disable admission plugins here.

    - --enable-bootstrap-token-auth=true  #If set to true, bootstrapping tokens can be used as bearer token credentials, 
                                          #which allows requests to authenticate against the API server.

    - --etcd-cafile=/etc/kubernetes/pki/etcd/ca.crt   #communication with etcd
    - --etcd-certfile=/etc/kubernetes/pki/apiserver-etcd-client.crt
    - --etcd-keyfile=/etc/kubernetes/pki/apiserver-etcd-client.key
    - --etcd-servers=https://127.0.0.1:2379
    - --kubelet-client-certificate=/etc/kubernetes/pki/apiserver-kubelet-client.crt  #communication with kubelet
    - --kubelet-client-key=/etc/kubernetes/pki/apiserver-kubelet-client.key
    - --kubelet-preferred-address-types=InternalIP,ExternalIP,Hostname
    - --proxy-client-cert-file=/etc/kubernetes/pki/front-proxy-client.crt  #communication with Agregated API server from
                                                                           #kube-apiserver and kube-proxy
    - --proxy-client-key-file=/etc/kubernetes/pki/front-proxy-client.key
    - --requestheader-allowed-names=front-proxy-client
    - --requestheader-client-ca-file=/etc/kubernetes/pki/front-proxy-ca.crt
    - --requestheader-extra-headers-prefix=X-Remote-Extra-
    - --requestheader-group-headers=X-Remote-Group
    - --requestheader-username-headers=X-Remote-User

    - --secure-port=6443    #Port where TLS is accepted
    - --service-account-key-file=/etc/kubernetes/pki/sa.pub
                                                    # File containing PEM-encoded x509 RSA
                                                    # or ECDSA private or public keys, used to verify ServiceAccount tokens.
                                                    # If unspecified, --tls-private-key-file is used. The specified file can 
                                                    # contain multiple keys, and the flag can be specified multiple times with 
                                                    # different files.
    - --service-cluster-ip-range=10.96.0.0/12
    - --tls-cert-file=/etc/kubernetes/pki/apiserver.crt            #TLS server certificates
    - --tls-private-key-file=/etc/kubernetes/pki/apiserver.key



FULL HELP

ubuntu@ip-172-31-38-56:~$ k exec -it kube-apiserver-ip-172-31-38-56 -n kube-system -- kube-apiserver --help
The Kubernetes API server validates and configures data
for the api objects which include pods, services, replicationcontrollers, and
others. The API Server services REST operations and provides the frontend to the
cluster's shared state through which all other components interact.

Usage:
  kube-apiserver [flags]

Generic flags:

      --advertise-address ip
                The IP address on which to advertise the apiserver to members of the cluster. This address must be reachable by the rest of the cluster. If blank, the --bind-address
                will be used. If --bind-address is unspecified, the host's default interface will be used.
      --cloud-provider-gce-l7lb-src-cidrs cidrs
                CIDRs opened in GCE firewall for L7 LB traffic proxy & health checks (default 130.211.0.0/22,35.191.0.0/16)
      --cors-allowed-origins strings
                List of allowed origins for CORS, comma separated. An allowed origin can be a regular expression to support subdomain matching. If this list is empty CORS will not be
                enabled. Please ensure each expression matches the entire hostname by anchoring to the start with '^' or including the '//' prefix, and by anchoring to the end with '$'
                or including the ':' port separator suffix. Examples of valid expressions are '//example\.com(:|$)' and '^https://example\.com(:|$)'
      --default-not-ready-toleration-seconds int
                Indicates the tolerationSeconds of the toleration for notReady:NoExecute that is added by default to every pod that does not already have such a toleration. (default 300)
      --default-unreachable-toleration-seconds int
                Indicates the tolerationSeconds of the toleration for unreachable:NoExecute that is added by default to every pod that does not already have such a toleration. (default 300)
      --external-hostname string
                The hostname to use when generating externalized URLs for this master (e.g. Swagger API Docs or OpenID Discovery).
      --feature-gates mapStringBool
                A set of key=value pairs that describe feature gates for alpha/experimental features. Options are:
                APIResponseCompression=true|false (BETA - default=true)
                APIServerIdentity=true|false (BETA - default=true)
                APIServerTracing=true|false (BETA - default=true)
                AdmissionWebhookMatchConditions=true|false (BETA - default=true)
                AggregatedDiscoveryEndpoint=true|false (BETA - default=true)
                AllAlpha=true|false (ALPHA - default=false)
                AllBeta=true|false (BETA - default=false)
                AnyVolumeDataSource=true|false (BETA - default=true)
                AppArmor=true|false (BETA - default=true)
                CPUManagerPolicyAlphaOptions=true|false (ALPHA - default=false)
                CPUManagerPolicyBetaOptions=true|false (BETA - default=true)
                CPUManagerPolicyOptions=true|false (BETA - default=true)
                CRDValidationRatcheting=true|false (ALPHA - default=false)
                CSIMigrationPortworx=true|false (BETA - default=false)
                CSIVolumeHealth=true|false (ALPHA - default=false)
                CloudControllerManagerWebhook=true|false (ALPHA - default=false)
                CloudDualStackNodeIPs=true|false (BETA - default=true)
                ClusterTrustBundle=true|false (ALPHA - default=false)
                ClusterTrustBundleProjection=true|false (ALPHA - default=false)
                ComponentSLIs=true|false (BETA - default=true)
                ConsistentListFromCache=true|false (ALPHA - default=false)
                ContainerCheckpoint=true|false (ALPHA - default=false)
                ContextualLogging=true|false (ALPHA - default=false)
                CronJobsScheduledAnnotation=true|false (BETA - default=true)
                CrossNamespaceVolumeDataSource=true|false (ALPHA - default=false)
                CustomCPUCFSQuotaPeriod=true|false (ALPHA - default=false)
                DevicePluginCDIDevices=true|false (BETA - default=true)
                DisableCloudProviders=true|false (BETA - default=true)
                DisableKubeletCloudCredentialProviders=true|false (BETA - default=true)
                DisableNodeKubeProxyVersion=true|false (ALPHA - default=false)
                DynamicResourceAllocation=true|false (ALPHA - default=false)
                ElasticIndexedJob=true|false (BETA - default=true)
                EventedPLEG=true|false (ALPHA - default=false)
                GracefulNodeShutdown=true|false (BETA - default=true)
                GracefulNodeShutdownBasedOnPodPriority=true|false (BETA - default=true)
                HPAContainerMetrics=true|false (BETA - default=true)
                HPAScaleToZero=true|false (ALPHA - default=false)
                HonorPVReclaimPolicy=true|false (ALPHA - default=false)
                ImageMaximumGCAge=true|false (ALPHA - default=false)
                InPlacePodVerticalScaling=true|false (ALPHA - default=false)
                InTreePluginAWSUnregister=true|false (ALPHA - default=false)
                InTreePluginAzureDiskUnregister=true|false (ALPHA - default=false)
                InTreePluginAzureFileUnregister=true|false (ALPHA - default=false)
                InTreePluginGCEUnregister=true|false (ALPHA - default=false)
                InTreePluginOpenStackUnregister=true|false (ALPHA - default=false)
                InTreePluginPortworxUnregister=true|false (ALPHA - default=false)
                InTreePluginvSphereUnregister=true|false (ALPHA - default=false)
                JobBackoffLimitPerIndex=true|false (BETA - default=true)
                JobPodFailurePolicy=true|false (BETA - default=true)
                JobPodReplacementPolicy=true|false (BETA - default=true)
                KubeProxyDrainingTerminatingNodes=true|false (ALPHA - default=false)
                KubeletCgroupDriverFromCRI=true|false (ALPHA - default=false)
                KubeletInUserNamespace=true|false (ALPHA - default=false)
                KubeletPodResourcesDynamicResources=true|false (ALPHA - default=false)
                KubeletPodResourcesGet=true|false (ALPHA - default=false)
                KubeletSeparateDiskGC=true|false (ALPHA - default=false)
                KubeletTracing=true|false (BETA - default=true)
                LegacyServiceAccountTokenCleanUp=true|false (BETA - default=true)
                LoadBalancerIPMode=true|false (ALPHA - default=false)
                LocalStorageCapacityIsolationFSQuotaMonitoring=true|false (ALPHA - default=false)
                LogarithmicScaleDown=true|false (BETA - default=true)
                LoggingAlphaOptions=true|false (ALPHA - default=false)
                LoggingBetaOptions=true|false (BETA - default=true)
                MatchLabelKeysInPodAffinity=true|false (ALPHA - default=false)
                MatchLabelKeysInPodTopologySpread=true|false (BETA - default=true)
                MaxUnavailableStatefulSet=true|false (ALPHA - default=false)
                MemoryManager=true|false (BETA - default=true)
                MemoryQoS=true|false (ALPHA - default=false)
                MinDomainsInPodTopologySpread=true|false (BETA - default=true)
                MultiCIDRServiceAllocator=true|false (ALPHA - default=false)
                NFTablesProxyMode=true|false (ALPHA - default=false)
                NewVolumeManagerReconstruction=true|false (BETA - default=true)
                NodeInclusionPolicyInPodTopologySpread=true|false (BETA - default=true)
                NodeLogQuery=true|false (ALPHA - default=false)
                NodeSwap=true|false (BETA - default=false)
                OpenAPIEnums=true|false (BETA - default=true)
                PDBUnhealthyPodEvictionPolicy=true|false (BETA - default=true)
                PersistentVolumeLastPhaseTransitionTime=true|false (BETA - default=true)
                PodAndContainerStatsFromCRI=true|false (ALPHA - default=false)
                PodDeletionCost=true|false (BETA - default=true)
                PodDisruptionConditions=true|false (BETA - default=true)
                PodHostIPs=true|false (BETA - default=true)
                PodIndexLabel=true|false (BETA - default=true)
                PodLifecycleSleepAction=true|false (ALPHA - default=false)
                PodReadyToStartContainersCondition=true|false (BETA - default=true)
                PodSchedulingReadiness=true|false (BETA - default=true)
                ProcMountType=true|false (ALPHA - default=false)
                QOSReserved=true|false (ALPHA - default=false)
                RecoverVolumeExpansionFailure=true|false (ALPHA - default=false)
                RotateKubeletServerCertificate=true|false (BETA - default=true)
                RuntimeClassInImageCriApi=true|false (ALPHA - default=false)
                SELinuxMountReadWriteOncePod=true|false (BETA - default=true)
                SchedulerQueueingHints=true|false (BETA - default=false)
                SecurityContextDeny=true|false (ALPHA - default=false)
                SeparateCacheWatchRPC=true|false (BETA - default=true)
                SeparateTaintEvictionController=true|false (BETA - default=true)
                ServiceAccountTokenJTI=true|false (ALPHA - default=false)
                ServiceAccountTokenNodeBinding=true|false (ALPHA - default=false)
                ServiceAccountTokenNodeBindingValidation=true|false (ALPHA - default=false)
                ServiceAccountTokenPodNodeInfo=true|false (ALPHA - default=false)
                SidecarContainers=true|false (BETA - default=true)
                SizeMemoryBackedVolumes=true|false (BETA - default=true)
                StableLoadBalancerNodeSet=true|false (BETA - default=true)
                StatefulSetAutoDeletePVC=true|false (BETA - default=true)
                StatefulSetStartOrdinal=true|false (BETA - default=true)
                StorageVersionAPI=true|false (ALPHA - default=false)
                StorageVersionHash=true|false (BETA - default=true)
                StructuredAuthenticationConfiguration=true|false (ALPHA - default=false)
                StructuredAuthorizationConfiguration=true|false (ALPHA - default=false)
                TopologyAwareHints=true|false (BETA - default=true)
                TopologyManagerPolicyAlphaOptions=true|false (ALPHA - default=false)
                TopologyManagerPolicyBetaOptions=true|false (BETA - default=true)
                TopologyManagerPolicyOptions=true|false (BETA - default=true)
                TranslateStreamCloseWebsocketRequests=true|false (ALPHA - default=false)
                UnauthenticatedHTTP2DOSMitigation=true|false (BETA - default=true)
                UnknownVersionInteroperabilityProxy=true|false (ALPHA - default=false)
                UserNamespacesPodSecurityStandards=true|false (ALPHA - default=false)
                UserNamespacesSupport=true|false (ALPHA - default=false)
                ValidatingAdmissionPolicy=true|false (BETA - default=false)
                VolumeAttributesClass=true|false (ALPHA - default=false)
                VolumeCapacityPriority=true|false (ALPHA - default=false)
                WatchList=true|false (ALPHA - default=false)
                WinDSR=true|false (ALPHA - default=false)
                WinOverlay=true|false (BETA - default=true)
                WindowsHostNetwork=true|false (ALPHA - default=true)
                ZeroLimitedNominalConcurrencyShares=true|false (BETA - default=false)
      --goaway-chance float
                To prevent HTTP/2 clients from getting stuck on a single apiserver, randomly close a connection (GOAWAY). The client's other in-flight requests won't be affected, and
                the client will reconnect, likely landing on a different apiserver after going through the load balancer again. This argument sets the fraction of requests that will be
                sent a GOAWAY. Clusters with single apiservers, or which don't use a load balancer, should NOT enable this. Min is 0 (off), Max is .02 (1/50 requests); .001 (1/1000) is
                a recommended starting point.
      --livez-grace-period duration
                This option represents the maximum amount of time it should take for apiserver to complete its startup sequence and become live. From apiserver's start time to when
                this amount of time has elapsed, /livez will assume that unfinished post-start hooks will complete successfully and therefore return true.
      --max-mutating-requests-inflight int
                This and --max-requests-inflight are summed to determine the server's total concurrency limit (which must be positive) if --enable-priority-and-fairness is true.
                Otherwise, this flag limits the maximum number of mutating requests in flight, or a zero value disables the limit completely. (default 200)
      --max-requests-inflight int
                This and --max-mutating-requests-inflight are summed to determine the server's total concurrency limit (which must be positive) if --enable-priority-and-fairness is
                true. Otherwise, this flag limits the maximum number of non-mutating requests in flight, or a zero value disables the limit completely. (default 400)
      --min-request-timeout int
                An optional field indicating the minimum number of seconds a handler must keep a request open before timing it out. Currently only honored by the watch request handler,
                which picks a randomized value above this number as the connection timeout, to spread out load. (default 1800)
      --request-timeout duration
                An optional field indicating the duration a handler must keep a request open before timing it out. This is the default request timeout for requests but may be
                overridden by flags such as --min-request-timeout for specific types of requests. (default 1m0s)
      --shutdown-delay-duration duration
                Time to delay the termination. During that time the server keeps serving requests normally. The endpoints /healthz and /livez will return success, but /readyz
                immediately returns failure. Graceful termination starts after this delay has elapsed. This can be used to allow load balancer to stop sending traffic to this server.
      --shutdown-send-retry-after
                If true the HTTP Server will continue listening until all non long running request(s) in flight have been drained, during this window all incoming requests will be
                rejected with a status code 429 and a 'Retry-After' response header, in addition 'Connection: close' response header is set in order to tear down the TCP connection
                when idle.
      --shutdown-watch-termination-grace-period duration
                This option, if set, represents the maximum amount of grace period the apiserver will wait for active watch request(s) to drain during the graceful server shutdown window.
      --strict-transport-security-directives strings
                List of directives for HSTS, comma separated. If this list is empty, then HSTS directives will not be added. Example: 'max-age=31536000,includeSubDomains,preload'

Etcd flags:

      --delete-collection-workers int
                Number of workers spawned for DeleteCollection call. These are used to speed up namespace cleanup. (default 1)
      --enable-garbage-collector
                Enables the generic garbage collector. MUST be synced with the corresponding flag of the kube-controller-manager. (default true)
      --encryption-provider-config string
                The file containing configuration for encryption providers to be used for storing secrets in etcd
      --encryption-provider-config-automatic-reload
                Determines if the file set by --encryption-provider-config should be automatically reloaded if the disk contents change. Setting this to true disables the ability to
                uniquely identify distinct KMS plugins via the API server healthz endpoints.
      --etcd-cafile string
                SSL Certificate Authority file used to secure etcd communication.
      --etcd-certfile string
                SSL certification file used to secure etcd communication.
      --etcd-compaction-interval duration
                The interval of compaction requests. If 0, the compaction request from apiserver is disabled. (default 5m0s)
      --etcd-count-metric-poll-period duration
                Frequency of polling etcd for number of resources per type. 0 disables the metric collection. (default 1m0s)
      --etcd-db-metric-poll-interval duration
                The interval of requests to poll etcd and update metric. 0 disables the metric collection (default 30s)
      --etcd-healthcheck-timeout duration
                The timeout to use when checking etcd health. (default 2s)
      --etcd-keyfile string
                SSL key file used to secure etcd communication.
      --etcd-prefix string
                The prefix to prepend to all resource paths in etcd. (default "/registry")
      --etcd-readycheck-timeout duration
                The timeout to use when checking etcd readiness (default 2s)
      --etcd-servers strings
                List of etcd servers to connect with (scheme://ip:port), comma separated.
      --etcd-servers-overrides strings
                Per-resource etcd servers overrides, comma separated. The individual override format: group/resource#servers, where servers are URLs, semicolon separated. Note that
                this applies only to resources compiled into this server binary.
      --lease-reuse-duration-seconds int
                The time in seconds that each lease is reused. A lower value could avoid large number of objects reusing the same lease. Notice that a too small value may cause
                performance problems at storage layer. (default 60)
      --storage-backend string
                The storage backend for persistence. Options: 'etcd3' (default).
      --storage-media-type string
                The media type to use to store objects in storage. Some resources or storage backends may only support a specific media type and will ignore this setting. Supported
                media types: [application/json, application/yaml, application/vnd.kubernetes.protobuf] (default "application/vnd.kubernetes.protobuf")
      --watch-cache
                Enable watch caching in the apiserver (default true)
      --watch-cache-sizes strings
                Watch cache size settings for some resources (pods, nodes, etc.), comma separated. The individual setting format: resource[.group]#size, where resource is lowercase
                plural (no version), group is omitted for resources of apiVersion v1 (the legacy core API) and included for others, and size is a number. This option is only meaningful
                for resources built into the apiserver, not ones defined by CRDs or aggregated from external servers, and is only consulted if the watch-cache is enabled. The only
                meaningful size setting to supply here is zero, which means to disable watch caching for the associated resource; all non-zero values are equivalent and mean to not
                disable watch caching for that resource

Secure serving flags:

      --bind-address ip
                The IP address on which to listen for the --secure-port port. The associated interface(s) must be reachable by the rest of the cluster, and by CLI/web clients. If blank
                or an unspecified address (0.0.0.0 or ::), all interfaces and IP address families will be used. (default 0.0.0.0)
      --cert-dir string
                The directory where the TLS certs are located. If --tls-cert-file and --tls-private-key-file are provided, this flag will be ignored. (default "/var/run/kubernetes")
      --http2-max-streams-per-connection int
                The limit that the server gives to clients for the maximum number of streams in an HTTP/2 connection. Zero means to use golang's default.
      --permit-address-sharing
                If true, SO_REUSEADDR will be used when binding the port. This allows binding to wildcard IPs like 0.0.0.0 and specific IPs in parallel, and it avoids waiting for the
                kernel to release sockets in TIME_WAIT state. [default=false]
      --permit-port-sharing
                If true, SO_REUSEPORT will be used when binding the port, which allows more than one instance to bind on the same address and port. [default=false]
      --secure-port int
                The port on which to serve HTTPS with authentication and authorization. It cannot be switched off with 0. (default 6443)
      --tls-cert-file string
                File containing the default x509 Certificate for HTTPS. (CA cert, if any, concatenated after server cert). If HTTPS serving is enabled, and --tls-cert-file and
                --tls-private-key-file are not provided, a self-signed certificate and key are generated for the public address and saved to the directory specified by --cert-dir.
      --tls-cipher-suites strings
                Comma-separated list of cipher suites for the server. If omitted, the default Go cipher suites will be used.
                Preferred values: TLS_AES_128_GCM_SHA256, TLS_AES_256_GCM_SHA384, TLS_CHACHA20_POLY1305_SHA256, TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA,
                TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256, TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA, TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384, TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305,
                TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305_SHA256, TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA, TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256, TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA,
                TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384, TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305, TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256, TLS_RSA_WITH_AES_128_CBC_SHA,
                TLS_RSA_WITH_AES_128_GCM_SHA256, TLS_RSA_WITH_AES_256_CBC_SHA, TLS_RSA_WITH_AES_256_GCM_SHA384.
                Insecure values: TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256, TLS_ECDHE_ECDSA_WITH_RC4_128_SHA, TLS_ECDHE_RSA_WITH_3DES_EDE_CBC_SHA, TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256,
                TLS_ECDHE_RSA_WITH_RC4_128_SHA, TLS_RSA_WITH_3DES_EDE_CBC_SHA, TLS_RSA_WITH_AES_128_CBC_SHA256, TLS_RSA_WITH_RC4_128_SHA.
      --tls-min-version string
                Minimum TLS version supported. Possible values: VersionTLS10, VersionTLS11, VersionTLS12, VersionTLS13
      --tls-private-key-file string
                File containing the default x509 private key matching --tls-cert-file.
      --tls-sni-cert-key namedCertKey
                A pair of x509 certificate and private key file paths, optionally suffixed with a list of domain patterns which are fully qualified domain names, possibly with prefixed
                wildcard segments. The domain patterns also allow IP addresses, but IPs should only be used if the apiserver has visibility to the IP address requested by a client. If
                no domain patterns are provided, the names of the certificate are extracted. Non-wildcard matches trump over wildcard matches, explicit domain patterns trump over
                extracted names. For multiple key/certificate pairs, use the --tls-sni-cert-key multiple times. Examples: "example.crt,example.key" or
                "foo.crt,foo.key:*.foo.com,foo.com". (default [])

Auditing flags:

      --audit-log-batch-buffer-size int
                The size of the buffer to store events before batching and writing. Only used in batch mode. (default 10000)
      --audit-log-batch-max-size int
                The maximum size of a batch. Only used in batch mode. (default 1)
      --audit-log-batch-max-wait duration
                The amount of time to wait before force writing the batch that hadn't reached the max size. Only used in batch mode.
      --audit-log-batch-throttle-burst int
                Maximum number of requests sent at the same moment if ThrottleQPS was not utilized before. Only used in batch mode.
      --audit-log-batch-throttle-enable
                Whether batching throttling is enabled. Only used in batch mode.
      --audit-log-batch-throttle-qps float32
                Maximum average number of batches per second. Only used in batch mode.
      --audit-log-compress
                If set, the rotated log files will be compressed using gzip.
      --audit-log-format string
                Format of saved audits. "legacy" indicates 1-line text format for each event. "json" indicates structured json format. Known formats are legacy,json. (default "json")
      --audit-log-maxage int
                The maximum number of days to retain old audit log files based on the timestamp encoded in their filename.
      --audit-log-maxbackup int
                The maximum number of old audit log files to retain. Setting a value of 0 will mean there's no restriction on the number of files.
      --audit-log-maxsize int
                The maximum size in megabytes of the audit log file before it gets rotated.
      --audit-log-mode string
                Strategy for sending audit events. Blocking indicates sending events should block server responses. Batch causes the backend to buffer and write events asynchronously.
                Known modes are batch,blocking,blocking-strict. (default "blocking")
      --audit-log-path string
                If set, all requests coming to the apiserver will be logged to this file.  '-' means standard out.
      --audit-log-truncate-enabled
                Whether event and batch truncating is enabled.
      --audit-log-truncate-max-batch-size int
                Maximum size of the batch sent to the underlying backend. Actual serialized size can be several hundreds of bytes greater. If a batch exceeds this limit, it is split
                into several batches of smaller size. (default 10485760)
      --audit-log-truncate-max-event-size int
                Maximum size of the audit event sent to the underlying backend. If the size of an event is greater than this number, first request and response are removed, and if this
                doesn't reduce the size enough, event is discarded. (default 102400)
      --audit-log-version string
                API group and version used for serializing audit events written to log. (default "audit.k8s.io/v1")
      --audit-policy-file string
                Path to the file that defines the audit policy configuration.
      --audit-webhook-batch-buffer-size int
                The size of the buffer to store events before batching and writing. Only used in batch mode. (default 10000)
      --audit-webhook-batch-max-size int
                The maximum size of a batch. Only used in batch mode. (default 400)
      --audit-webhook-batch-max-wait duration
                The amount of time to wait before force writing the batch that hadn't reached the max size. Only used in batch mode. (default 30s)
      --audit-webhook-batch-throttle-burst int
                Maximum number of requests sent at the same moment if ThrottleQPS was not utilized before. Only used in batch mode. (default 15)
      --audit-webhook-batch-throttle-enable
                Whether batching throttling is enabled. Only used in batch mode. (default true)
      --audit-webhook-batch-throttle-qps float32
                Maximum average number of batches per second. Only used in batch mode. (default 10)
      --audit-webhook-config-file string
                Path to a kubeconfig formatted file that defines the audit webhook configuration.
      --audit-webhook-initial-backoff duration
                The amount of time to wait before retrying the first failed request. (default 10s)
      --audit-webhook-mode string
                Strategy for sending audit events. Blocking indicates sending events should block server responses. Batch causes the backend to buffer and write events asynchronously.
                Known modes are batch,blocking,blocking-strict. (default "batch")
      --audit-webhook-truncate-enabled
                Whether event and batch truncating is enabled.
      --audit-webhook-truncate-max-batch-size int
                Maximum size of the batch sent to the underlying backend. Actual serialized size can be several hundreds of bytes greater. If a batch exceeds this limit, it is split
                into several batches of smaller size. (default 10485760)
      --audit-webhook-truncate-max-event-size int
                Maximum size of the audit event sent to the underlying backend. If the size of an event is greater than this number, first request and response are removed, and if this
                doesn't reduce the size enough, event is discarded. (default 102400)
      --audit-webhook-version string
                API group and version used for serializing audit events written to webhook. (default "audit.k8s.io/v1")

Features flags:

      --contention-profiling
                Enable block profiling, if profiling is enabled
      --debug-socket-path string
                Use an unprotected (no authn/authz) unix-domain socket for profiling with the given path
      --enable-priority-and-fairness
                If true, replace the max-in-flight handler with an enhanced one that queues and dispatches with priority and fairness (default true)
      --profiling
                Enable profiling via web interface host:port/debug/pprof/ (default true)

Authentication flags:

      --anonymous-auth
                Enables anonymous requests to the secure port of the API server. Requests that are not rejected by another authentication method are treated as anonymous requests.
                Anonymous requests have a username of system:anonymous, and a group name of system:unauthenticated. (default true)
      --api-audiences strings
                Identifiers of the API. The service account token authenticator will validate that tokens used against the API are bound to at least one of these audiences. If the
                --service-account-issuer flag is configured and this flag is not, this field defaults to a single element list containing the issuer URL.
      --authentication-config string
                File with Authentication Configuration to configure the JWT Token authenticator. Note: This feature is in Alpha since
                v1.29.--feature-gate=StructuredAuthenticationConfiguration=true needs to be set for enabling this feature.This feature is mutually exclusive with the oidc-* flags.
      --authentication-token-webhook-cache-ttl duration
                The duration to cache responses from the webhook token authenticator. (default 2m0s)
      --authentication-token-webhook-config-file string
                File with webhook configuration for token authentication in kubeconfig format. The API server will query the remote service to determine authentication for bearer tokens.
      --authentication-token-webhook-version string
                The API version of the authentication.k8s.io TokenReview to send to and expect from the webhook. (default "v1beta1")
      --client-ca-file string
                If set, any request presenting a client certificate signed by one of the authorities in the client-ca-file is authenticated with an identity corresponding to the
                CommonName of the client certificate.
      --enable-bootstrap-token-auth
                Enable to allow secrets of type 'bootstrap.kubernetes.io/token' in the 'kube-system' namespace to be used for TLS bootstrapping authentication.
      --oidc-ca-file string
                If set, the OpenID server's certificate will be verified by one of the authorities in the oidc-ca-file, otherwise the host's root CA set will be used.
      --oidc-client-id string
                The client ID for the OpenID Connect client, must be set if oidc-issuer-url is set.
      --oidc-groups-claim string
                If provided, the name of a custom OpenID Connect claim for specifying user groups. The claim value is expected to be a string or array of strings. This flag is
                experimental, please see the authentication documentation for further details.
      --oidc-groups-prefix string
                If provided, all groups will be prefixed with this value to prevent conflicts with other authentication strategies.
      --oidc-issuer-url string
                The URL of the OpenID issuer, only HTTPS scheme will be accepted. If set, it will be used to verify the OIDC JSON Web Token (JWT).
      --oidc-required-claim mapStringString
                A key=value pair that describes a required claim in the ID Token. If set, the claim is verified to be present in the ID Token with a matching value. Repeat this flag to
                specify multiple claims.
      --oidc-signing-algs strings
                Comma-separated list of allowed JOSE asymmetric signing algorithms. JWTs with a supported 'alg' header values are: RS256, RS384, RS512, ES256, ES384, ES512, PS256,
                PS384, PS512. Values are defined by RFC 7518 https://tools.ietf.org/html/rfc7518#section-3.1. (default [RS256])
      --oidc-username-claim string
                The OpenID claim to use as the user name. Note that claims other than the default ('sub') is not guaranteed to be unique and immutable. This flag is experimental,
                please see the authentication documentation for further details. (default "sub")
      --oidc-username-prefix string
                If provided, all usernames will be prefixed with this value. If not provided, username claims other than 'email' are prefixed by the issuer URL to avoid clashes. To
                skip any prefixing, provide the value '-'.
      --requestheader-allowed-names strings
                List of client certificate common names to allow to provide usernames in headers specified by --requestheader-username-headers. If empty, any client certificate
                validated by the authorities in --requestheader-client-ca-file is allowed.
      --requestheader-client-ca-file string
                Root certificate bundle to use to verify client certificates on incoming requests before trusting usernames in headers specified by --requestheader-username-headers.
                WARNING: generally do not depend on authorization being already done for incoming requests.
      --requestheader-extra-headers-prefix strings
                List of request header prefixes to inspect. X-Remote-Extra- is suggested.
      --requestheader-group-headers strings
                List of request headers to inspect for groups. X-Remote-Group is suggested.
      --requestheader-username-headers strings
                List of request headers to inspect for usernames. X-Remote-User is common.
      --service-account-extend-token-expiration
                Turns on projected service account expiration extension during token generation, which helps safe transition from legacy token to bound service account token feature.
                If this flag is enabled, admission injected tokens would be extended up to 1 year to prevent unexpected failure during transition, ignoring value of
                service-account-max-token-expiration. (default true)
      --service-account-issuer stringArray
                Identifier of the service account token issuer. The issuer will assert this identifier in "iss" claim of issued tokens. This value is a string or URI. If this option is
                not a valid URI per the OpenID Discovery 1.0 spec, the ServiceAccountIssuerDiscovery feature will remain disabled, even if the feature gate is set to true. It is highly
                recommended that this value comply with the OpenID spec: https://openid.net/specs/openid-connect-discovery-1_0.html. In practice, this means that service-account-issuer
                must be an https URL. It is also highly recommended that this URL be capable of serving OpenID discovery documents at
                {service-account-issuer}/.well-known/openid-configuration. When this flag is specified multiple times, the first is used to generate tokens and all are used to
                determine which issuers are accepted.
      --service-account-jwks-uri string
                Overrides the URI for the JSON Web Key Set in the discovery doc served at /.well-known/openid-configuration. This flag is useful if the discovery docand key set are
                served to relying parties from a URL other than the API server's external (as auto-detected or overridden with external-hostname).
      --service-account-key-file stringArray
                File containing PEM-encoded x509 RSA or ECDSA private or public keys, used to verify ServiceAccount tokens. The specified file can contain multiple keys, and the flag
                can be specified multiple times with different files. If unspecified, --tls-private-key-file is used. Must be specified when --service-account-signing-key-file is provided
      --service-account-lookup
                If true, validate ServiceAccount tokens exist in etcd as part of authentication. (default true)
      --service-account-max-token-expiration duration
                The maximum validity duration of a token created by the service account token issuer. If an otherwise valid TokenRequest with a validity duration larger than this value
                is requested, a token will be issued with a validity duration of this value.
      --token-auth-file string
                If set, the file that will be used to secure the secure port of the API server via token authentication.

Authorization flags:

      --authorization-config string
                File with Authorization Configuration to configure the authorizer chain.Note: This feature is in Alpha since
                v1.29.--feature-gate=StructuredAuthorizationConfiguration=true feature flag needs to be set to true for enabling the functionality.This feature is mutually exclusive
                with the other --authorization-mode and --authorization-webhook-* flags.
      --authorization-mode strings
                Ordered list of plug-ins to do authorization on secure port. Defaults to AlwaysAllow if --authorization-config is not used. Comma-delimited list of:
                AlwaysAllow,AlwaysDeny,ABAC,Webhook,RBAC,Node.
      --authorization-policy-file string
                File with authorization policy in json line by line format, used with --authorization-mode=ABAC, on the secure port.
      --authorization-webhook-cache-authorized-ttl duration
                The duration to cache 'authorized' responses from the webhook authorizer. (default 5m0s)
      --authorization-webhook-cache-unauthorized-ttl duration
                The duration to cache 'unauthorized' responses from the webhook authorizer. (default 30s)
      --authorization-webhook-config-file string
                File with webhook configuration in kubeconfig format, used with --authorization-mode=Webhook. The API server will query the remote service to determine access on the
                API server's secure port.
      --authorization-webhook-version string
                The API version of the authorization.k8s.io SubjectAccessReview to send to and expect from the webhook. (default "v1beta1")

API enablement flags:

      --runtime-config mapStringString
                A set of key=value pairs that enable or disable built-in APIs. Supported options are:
                v1=true|false for the core API group
                <group>/<version>=true|false for a specific API group and version (e.g. apps/v1=true)
                api/all=true|false controls all API versions
                api/ga=true|false controls all API versions of the form v[0-9]+
                api/beta=true|false controls all API versions of the form v[0-9]+beta[0-9]+
                api/alpha=true|false controls all API versions of the form v[0-9]+alpha[0-9]+
                api/legacy is deprecated, and will be removed in a future version

Egress selector flags:

      --egress-selector-config-file string
                File with apiserver egress selector configuration.

Admission flags:

      --admission-control strings
                Admission is divided into two phases. In the first phase, only mutating admission plugins run. In the second phase, only validating admission plugins run. The names in
                the below list may represent a validating plugin, a mutating plugin, or both. The order of plugins in which they are passed to this flag does not matter.
                Comma-delimited list of: AlwaysAdmit, AlwaysDeny, AlwaysPullImages, CertificateApproval, CertificateSigning, CertificateSubjectRestriction, ClusterTrustBundleAttest,
                DefaultIngressClass, DefaultStorageClass, DefaultTolerationSeconds, DenyServiceExternalIPs, EventRateLimit, ExtendedResourceToleration, ImagePolicyWebhook,
                LimitPodHardAntiAffinityTopology, LimitRanger, MutatingAdmissionWebhook, NamespaceAutoProvision, NamespaceExists, NamespaceLifecycle, NodeRestriction,
                OwnerReferencesPermissionEnforcement, PersistentVolumeClaimResize, PersistentVolumeLabel, PodNodeSelector, PodSecurity, PodTolerationRestriction, Priority,
                ResourceQuota, RuntimeClass, SecurityContextDeny, ServiceAccount, StorageObjectInUseProtection, TaintNodesByCondition, ValidatingAdmissionPolicy,
                ValidatingAdmissionWebhook. (DEPRECATED: Use --enable-admission-plugins or --disable-admission-plugins instead. Will be removed in a future version.)
      --admission-control-config-file string
                File with admission control configuration.
      --disable-admission-plugins strings
                admission plugins that should be disabled although they are in the default enabled plugins list (NamespaceLifecycle, LimitRanger, ServiceAccount, TaintNodesByCondition,
                PodSecurity, Priority, DefaultTolerationSeconds, DefaultStorageClass, StorageObjectInUseProtection, PersistentVolumeClaimResize, RuntimeClass, CertificateApproval,
                CertificateSigning, ClusterTrustBundleAttest, CertificateSubjectRestriction, DefaultIngressClass, MutatingAdmissionWebhook, ValidatingAdmissionPolicy,
                ValidatingAdmissionWebhook, ResourceQuota). Comma-delimited list of admission plugins: AlwaysAdmit, AlwaysDeny, AlwaysPullImages, CertificateApproval,
                CertificateSigning, CertificateSubjectRestriction, ClusterTrustBundleAttest, DefaultIngressClass, DefaultStorageClass, DefaultTolerationSeconds, DenyServiceExternalIPs,
                EventRateLimit, ExtendedResourceToleration, ImagePolicyWebhook, LimitPodHardAntiAffinityTopology, LimitRanger, MutatingAdmissionWebhook, NamespaceAutoProvision,
                NamespaceExists, NamespaceLifecycle, NodeRestriction, OwnerReferencesPermissionEnforcement, PersistentVolumeClaimResize, PersistentVolumeLabel, PodNodeSelector,
                PodSecurity, PodTolerationRestriction, Priority, ResourceQuota, RuntimeClass, SecurityContextDeny, ServiceAccount, StorageObjectInUseProtection, TaintNodesByCondition,
                ValidatingAdmissionPolicy, ValidatingAdmissionWebhook. The order of plugins in this flag does not matter.
      --enable-admission-plugins strings
                admission plugins that should be enabled in addition to default enabled ones (NamespaceLifecycle, LimitRanger, ServiceAccount, TaintNodesByCondition, PodSecurity,
                Priority, DefaultTolerationSeconds, DefaultStorageClass, StorageObjectInUseProtection, PersistentVolumeClaimResize, RuntimeClass, CertificateApproval,
                CertificateSigning, ClusterTrustBundleAttest, CertificateSubjectRestriction, DefaultIngressClass, MutatingAdmissionWebhook, ValidatingAdmissionPolicy,
                ValidatingAdmissionWebhook, ResourceQuota). Comma-delimited list of admission plugins: AlwaysAdmit, AlwaysDeny, AlwaysPullImages, CertificateApproval,
                CertificateSigning, CertificateSubjectRestriction, ClusterTrustBundleAttest, DefaultIngressClass, DefaultStorageClass, DefaultTolerationSeconds, DenyServiceExternalIPs,
                EventRateLimit, ExtendedResourceToleration, ImagePolicyWebhook, LimitPodHardAntiAffinityTopology, LimitRanger, MutatingAdmissionWebhook, NamespaceAutoProvision,
                NamespaceExists, NamespaceLifecycle, NodeRestriction, OwnerReferencesPermissionEnforcement, PersistentVolumeClaimResize, PersistentVolumeLabel, PodNodeSelector,
                PodSecurity, PodTolerationRestriction, Priority, ResourceQuota, RuntimeClass, SecurityContextDeny, ServiceAccount, StorageObjectInUseProtection, TaintNodesByCondition,
                ValidatingAdmissionPolicy, ValidatingAdmissionWebhook. The order of plugins in this flag does not matter.

Metrics flags:

      --allow-metric-labels stringToString
                The map from metric-label to value allow-list of this label. The key's format is <MetricName>,<LabelName>. The value's format is <allowed_value>,<allowed_value>...e.g.
                metric1,label1='v1,v2,v3', metric1,label2='v1,v2,v3' metric2,label1='v1,v2,v3'. (default [])
      --allow-metric-labels-manifest string
                The path to the manifest file that contains the allow-list mapping. The format of the file is the same as the flag --allow-metric-labels. Note that the flag
                --allow-metric-labels will override the manifest file.
      --disabled-metrics strings
                This flag provides an escape hatch for misbehaving metrics. You must provide the fully qualified metric name in order to disable it. Disclaimer: disabling metrics is
                higher in precedence than showing hidden metrics.
      --show-hidden-metrics-for-version string
                The previous version for which you want to show hidden metrics. Only the previous minor version is meaningful, other values will not be allowed. The format is
                <major>.<minor>, e.g.: '1.16'. The purpose of this format is make sure you have the opportunity to notice if the next release hides additional metrics, rather than
                being surprised when they are permanently removed in the release after that.

Logs flags:

      --log-flush-frequency duration
                Maximum number of seconds between log flushes (default 5s)
      --log-json-info-buffer-size quantity
                [Alpha] In JSON format with split output streams, the info messages can be buffered for a while to increase performance. The default value of zero bytes disables
                buffering. The size can be specified as number of bytes (512), multiples of 1000 (1K), multiples of 1024 (2Ki), or powers of those (3M, 4G, 5Mi, 6Gi). Enable the
                LoggingAlphaOptions feature gate to use this.
      --log-json-split-stream
                [Alpha] In JSON format, write error messages to stderr and info messages to stdout. The default is to write a single stream to stdout. Enable the LoggingAlphaOptions
                feature gate to use this.
      --logging-format string
                Sets the log format. Permitted formats: "json" (gated by LoggingBetaOptions), "text". (default "text")
  -v, --v Level
                number for the log level verbosity
      --vmodule pattern=N,...
                comma-separated list of pattern=N settings for file-filtered logging (only works for text log format)

Traces flags:

      --tracing-config-file string
                File with apiserver tracing configuration.

Misc flags:

      --aggregator-reject-forwarding-redirect
                Aggregator reject forwarding redirect response back to client. (default true)
      --allow-privileged
                If true, allow privileged containers. [default=false]
      --enable-aggregator-routing
                Turns on aggregator routing requests to endpoints IP rather than cluster IP.
      --endpoint-reconciler-type string
                Use an endpoint reconciler (master-count, lease, none) master-count is deprecated, and will be removed in a future version. (default "lease")
      --event-ttl duration
                Amount of time to retain events. (default 1h0m0s)
      --kubelet-certificate-authority string
                Path to a cert file for the certificate authority.
      --kubelet-client-certificate string
                Path to a client cert file for TLS.
      --kubelet-client-key string
                Path to a client key file for TLS.
      --kubelet-preferred-address-types strings
                List of the preferred NodeAddressTypes to use for kubelet connections. (default [Hostname,InternalDNS,InternalIP,ExternalDNS,ExternalIP])
      --kubelet-timeout duration
                Timeout for kubelet operations. (default 5s)
      --kubernetes-service-node-port int
                If non-zero, the Kubernetes master service (which apiserver creates/maintains) will be of type NodePort, using this as the value of the port. If zero, the Kubernetes
                master service will be of type ClusterIP.
      --max-connection-bytes-per-sec int
                If non-zero, throttle each user connection to this number of bytes/sec. Currently only applies to long-running requests.
      --peer-advertise-ip string
                If set and the UnknownVersionInteroperabilityProxy feature gate is enabled, this IP will be used by peer kube-apiservers to proxy requests to this kube-apiserver when
                the request cannot be handled by the peer due to version skew between the kube-apiservers. This flag is only used in clusters configured with multiple kube-apiservers
                for high availability.
      --peer-advertise-port string
                If set and the UnknownVersionInteroperabilityProxy feature gate is enabled, this port will be used by peer kube-apiservers to proxy requests to this kube-apiserver when
                the request cannot be handled by the peer due to version skew between the kube-apiservers. This flag is only used in clusters configured with multiple kube-apiservers
                for high availability.
      --peer-ca-file string
                If set and the UnknownVersionInteroperabilityProxy feature gate is enabled, this file will be used to verify serving certificates of peer kube-apiservers. This flag is
                only used in clusters configured with multiple kube-apiservers for high availability.
      --proxy-client-cert-file string
                Client certificate used to prove the identity of the aggregator or kube-apiserver when it must call out during a request. This includes proxying requests to a user
                api-server and calling out to webhook admission plugins. It is expected that this cert includes a signature from the CA in the --requestheader-client-ca-file flag. That
                CA is published in the 'extension-apiserver-authentication' configmap in the kube-system namespace. Components receiving calls from kube-aggregator should use that CA
                to perform their half of the mutual TLS verification.
      --proxy-client-key-file string
                Private key for the client certificate used to prove the identity of the aggregator or kube-apiserver when it must call out during a request. This includes proxying
                requests to a user api-server and calling out to webhook admission plugins.
      --service-account-signing-key-file string
                Path to the file that contains the current private key of the service account token issuer. The issuer will sign issued ID tokens with this private key.
      --service-cluster-ip-range string
                A CIDR notation IP range from which to assign service cluster IPs. This must not overlap with any IP ranges assigned to nodes or pods. Max of two dual-stack CIDRs is
                allowed.
      --service-node-port-range portRange
                A port range to reserve for services with NodePort visibility.  This must not overlap with the ephemeral port range on nodes.  Example: '30000-32767'. Inclusive at both
                ends of the range. (default 30000-32767)

