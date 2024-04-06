#project url
#https://github.com/aquasecurity/trivy

#Trivy analize security vulnerabilities
# Trivy has scanners that look for security issues, and targets where it can find those issues.

# Targets (what Trivy can scan):
    # Container Image
    # Filesystem
    # Git Repository (remote)
    # Virtual Machine Image
    # Kubernetes
    # AWS
# Scanners (what Trivy can find there):
    # OS packages and software dependencies in use (SBOM)
    # Known vulnerabilities (CVEs)
    # IaC issues and misconfigurations
    # Sensitive information and secrets
    # Software licenses

#As image aquasec/trivy
#binary from https://github.com/aquasecurity/trivy/releases/latest/
mkdir trivy/;
wget https://github.com/aquasecurity/trivy/releases/download/v0.50.1/trivy_0.50.1_Linux-64bit.tar.gz; 
tar -xf trivy_0.50.1_Linux-64bit.tar.gz --directory trivy/
sudo mv trivy/trivy /usr/bin;

#USAGE trivy <target> [--scanners <scanner1,scanner2>] <subject>
#trivy image python:3.4-alpine
#trivy fs --scanners vuln,secret,misconfig myproject
#trivy k8s --report summary cluster

#CHECK CLUSTER
trivy k8s --scaners vuln --report summary cluster;
# Summary Report for kubernetes-admin@kubernetes
# Workload Assessment
# ┌──────────────────────┬──────────────────────────────────────┬─────────────────────┐
# │      Namespace       │               Resource               │   Vulnerabilities   │
# │                      │                                      ├───┬────┬────┬───┬───┤
# │                      │                                      │ C │ H  │ M  │ L │ U │
# ├──────────────────────┼──────────────────────────────────────┼───┼────┼────┼───┼───┤
# │ kubernetes-dashboard │ Deployment/kubernetes-dashboard      │   │   │ 4  │   │   │

# Severities: C=CRITICAL H=HIGH M=MEDIUM L=LOW U=UNKNOWN

# Infra Assessment
# ┌─────────────┬────────────────────────────────────────────────────────────────────────┬────────────────────┐
# │  Namespace  │                                Resource                                │  Vulnerabilities   │
# │             │                                                                        ├───┬───┬───┬────┬───┤
# │             │                                                                        │ C │ H │ M │ L  │ U │
# ├─────────────┼────────────────────────────────────────────────────────────────────────┼───┼───┼───┼────┼───┤
# │             │ Node/ip-172-31-29-63.eu-west-2.compute.internal                        │   │   │ 1 │    │   │
# │             │ Node/server.eu-west-2.compute.internal                        │   │   │ 1 │    │   │

# Severities: C=CRITICAL H=HIGH M=MEDIUM L=LOW U=UNKNOWN


#CHECK IMAGES
#Ouput trivy image in json
trivy image redis --format json --output redis.trivy.json;
#Ouput convert report to csv

trivy image nginx:alpine;
# nginx:alpine (alpine 3.18.6)
# Total: 0 (UNKNOWN: 0, LOW: 0, MEDIUM: 0, HIGH: 0, CRITICAL: 0)
trivy image redis;
# 2024-04-04T20:43:46.889Z        INFO    Detecting gobinary vulnerabilities...
# redis (debian 12.5)
# Total: 407 (UNKNOWN: 49, LOW: 140, MEDIUM: 163, HIGH: 0, CRITICAL: 0)

# ┌────────────────────┬─────────────────────┬──────────┬──────────────┬───────────────────────┬──────────────────┬──────────────────────────────────────────────────────────────┐
# │      Library       │    Vulnerability    │ Severity │    Status    │   Installed Version   │  Fixed Version   │                            Title                             │
# ├────────────────────┼─────────────────────┼──────────┼──────────────┼───────────────────────┼──────────────────┼──────────────────────────────────────────────────────────────┤
# │ apt                │ CVE-2011-3374       │ LOW      │ affected     │ 2.6.1                 │                  │ It was found that apt-key in apt, all versions, do not       │
# │                    │                     │          │              │                       │                  │ correctly...                                                 │
# │                    │                     │          │              │                       │                  │ https://avd.aquasec.com/nvd/cve-2011-3374                    │






