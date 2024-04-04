#Automatically generas reports
# Vulnerability Scans: Automated vulnerability scanning for Kubernetes workloads, control-plane and node components (api-server, controller-manager, kubelet and etc)
# ConfigAudit Scans: Automated configuration audits for Kubernetes resources with predefined rules 
# or custom Open Policy Agent (OPA) policies.
# Exposed Secret Scans: Automated secret scans which find and detail the location of exposed Secrets within your cluster.
# RBAC scans: Role Based Access Control scans provide detailed information on the access rights of the different resources installed.
# K8s core component infra assessment scan Kubernetes infra core components (etcd,apiserver,scheduler,controller-manager and etc) setting and configuration.
# k8s outdated api validation - a configaudit check will validate if the resource api has been deprecated and planned for removal
# Compliance reports
# NSA, CISA Kubernetes Hardening Guidance v1.1 cybersecurity technical report is produced.
# CIS Kubernetes Benchmark v1.23 cybersecurity technical report is produced.
# Kubernetes pss-baseline, Pod Security Standards
# Kubernetes pss-restricted, Pod Security Standards
# SBOM (Software Bill of Materials genertations) for Kubernetes workloads.


#add aquasecurity helm charts repo
helm repo add aqua https://aquasecurity.github.io/helm-charts/;
helm repo update;

helm install trivy-operator aqua/trivy-operator \
     --namespace trivy-system \
     --create-namespace \
     --version 0.21.4

# NAME: trivy-operator
# NAMESPACE: trivy-system
# STATUS: deployed
# NOTES:
# You have installed Trivy Operator in the trivy-system namespace.
# It is configured to discover Kubernetes workloads and resources in
# all namespace(s).
# Inspect created VulnerabilityReports by:
#     kubectl get vulnerabilityreports --all-namespaces -o wide
# Inspect created ConfigAuditReports by:
#     kubectl get configauditreports --all-namespaces -o wide
# Inspect the work log of trivy-operator by:
#     kubectl logs -n trivy-system deployment/trivy-operator


