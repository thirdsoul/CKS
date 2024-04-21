# Configuration parameters are the key and DNS match is required
[ req ]
default_bits       = 2048
distinguished_name = req_distinguished_name
req_extensions     = req_ext
prompt             = no
[ req_distinguished_name ]
countryName                 = IN
stateOrProvinceName         = KAR
localityName                = BGL
organizationName            = ACME INC
commonName                  = check-labels 0.1
[ req_ext ]
subjectAltName = @alt_names
[alt_names]
DNS.1   = admission.admissions.svc

openssl req -x509 -newkey rsa:4096 -nodes \
 -out /etc/kubernets/admission/ca.crt \
 -keyout /etc/kubernets/admission/ca.key \
 -days 365 \
 -config /etc/kubernets/admission/ca.cfg \
 -extensions req_ext


kubectl create secret tls admission-webhook-secret --cert=/etc/kubernets/admission/ca.crt --key=/etc/kubernets/admission/ca.key --namespace=admission

kubectl create namespace admission

kubectl apply -f - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: admission-webhook
  namespace: admissions
  labels:
    app: webhook
spec:
  replicas: 2
  selector:
    matchLabels:
      app: webhook
  template:
    metadata:
      labels:
        app: webhook
    spec:
      containers:
        - name: webhook-container
          image: thirdsoul/webhook-demo
          volumeMounts:
            - mountPath: /etc/ssl
              name: webhook-certificates
              readOnly: true
      volumes:
      - name: webhook-certificates
        secret:
          secretName: admission-webhook-secret
EOF

kubectl expose deployment/admission-webhook --name=admission --namespace=admissions --port=443 --target-port=5000

---
apiVersion: admissionregistration.k8s.io/v1
kind: ValidatingWebhookConfiguration
metadata:
  name: ngaddons-check-labels
  namespace: check-labels
webhooks:
  - name: ngaddons.check-labels.webhook
    failurePolicy: Fail
    sideEffects: None
    admissionReviewVersions: ["v1","v1beta1"]
    namespaceSelector:
      matchLabels:
        ngaddons/validation-webhooks: enabled
    rules:
      - apiGroups: ["apps", ""]
        resources:
          - "deployments"
          - "pods"
        apiVersions:
          - "*"
        operations:
          - CREATE
    clientConfig:
      service:
        name: ${WEBHOOK_SERVICE_NAME} # to be substituted
        namespace: ${WEBHOOK_NAMESPACE} # to be substituted
        path: /validate/
      caBundle: ${CA_BUNDLE} # to be substituted
