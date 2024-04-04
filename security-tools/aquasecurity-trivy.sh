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
# │ kubernetes-dashboard │ Deployment/dashboard-metrics-scraper │ 1 │ 5  │ 3  │   │   │
# │ kubernetes-dashboard │ Deployment/kubernetes-dashboard      │   │ 6  │ 4  │   │   │
# │ kube-flannel         │ DaemonSet/kube-flannel-ds            │ 6 │ 28 │ 62 │ 6 │   │
# └──────────────────────┴──────────────────────────────────────┴───┴────┴────┴───┴───┘
# Severities: C=CRITICAL H=HIGH M=MEDIUM L=LOW U=UNKNOWN

# Infra Assessment
# ┌─────────────┬────────────────────────────────────────────────────────────────────────┬────────────────────┐
# │  Namespace  │                                Resource                                │  Vulnerabilities   │
# │             │                                                                        ├───┬───┬───┬────┬───┤
# │             │                                                                        │ C │ H │ M │ L  │ U │
# ├─────────────┼────────────────────────────────────────────────────────────────────────┼───┼───┼───┼────┼───┤
# │ kube-system │ Deployment/coredns                                                     │   │ 3 │ 5 │    │   │
# │ kube-system │ Deployment/aws-load-balancer-controller                                │   │ 5 │ 3 │    │   │
# │ kube-system │ DaemonSet/kube-proxy                                                   │   │ 4 │ 5 │ 16 │   │
# │ kube-system │ Pod/etcd-ip-172-31-26-79.eu-west-2.compute.internal                    │   │   │ 4 │    │   │
# │ kube-system │ Pod/kube-apiserver-ip-172-31-26-79.eu-west-2.compute.internal          │   │ 3 │ 1 │    │   │
# │ kube-system │ Pod/kube-scheduler-ip-172-31-26-79.eu-west-2.compute.internal          │   │ 3 │ 1 │    │   │
# │ kube-system │ Pod/kube-controller-manager-ip-172-31-26-79.eu-west-2.compute.internal │   │ 4 │ 1 │    │   │
# │             │ Node/ip-172-31-29-63.eu-west-2.compute.internal                        │   │   │ 1 │    │   │
# │             │ Node/ip-172-31-26-79.eu-west-2.compute.internal                        │   │   │ 1 │    │   │
# │             │ Node/ip-172-31-27-231.eu-west-2.compute.internal                       │   │ 2 │ 1 │ 1  │   │
# └─────────────┴────────────────────────────────────────────────────────────────────────┴───┴───┴───┴────┴───┘
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
# Total: 407 (UNKNOWN: 49, LOW: 140, MEDIUM: 163, HIGH: 54, CRITICAL: 1)

# ┌────────────────────┬─────────────────────┬──────────┬──────────────┬───────────────────────┬──────────────────┬──────────────────────────────────────────────────────────────┐
# │      Library       │    Vulnerability    │ Severity │    Status    │   Installed Version   │  Fixed Version   │                            Title                             │
# ├────────────────────┼─────────────────────┼──────────┼──────────────┼───────────────────────┼──────────────────┼──────────────────────────────────────────────────────────────┤
# │ apt                │ CVE-2011-3374       │ LOW      │ affected     │ 2.6.1                 │                  │ It was found that apt-key in apt, all versions, do not       │
# │                    │                     │          │              │                       │                  │ correctly...                                                 │
# │                    │                     │          │              │                       │                  │ https://avd.aquasec.com/nvd/cve-2011-3374                    │
# ├────────────────────┼─────────────────────┤          │              ├───────────────────────┼──────────────────┼──────────────────────────────────────────────────────────────┤
# │ bash               │ TEMP-0841856-B18BAF │          │              │ 5.2.15-2+b2           │                  │ [Privilege escalation possible to other user than root]      │
# │                    │                     │          │              │                       │                  │ https://security-tracker.debian.org/tracker/TEMP-0841856-B1- │
# │                    │                     │          │              │                       │                  │ 8BAF                                                         │
# ├────────────────────┼─────────────────────┼──────────┼──────────────┼───────────────────────┼──────────────────┼──────────────────────────────────────────────────────────────┤
# │ bsdutils           │ CVE-2024-28085      │ HIGH     │ fixed        │ 1:2.38.1-5+b1         │ 2.38.1-5+deb12u1 │ util-linux: CVE-2024-28085: wall: escape sequence injection  │
# │                    │                     │          │              │                       │                  │ https://avd.aquasec.com/nvd/cve-2024-28085                   │
# │                    ├─────────────────────┼──────────┼──────────────┤                       ├──────────────────┼──────────────────────────────────────────────────────────────┤
# │                    │ CVE-2022-0563       │ LOW      │ affected     │                       │                  │ util-linux: partial disclosure of arbitrary files in chfn    │
# │                    │                     │          │              │                       │                  │ and chsh when compiled...                                    │
# │                    │                     │          │              │                       │                  │ https://avd.aquasec.com/nvd/cve-2022-0563                    │
# ├────────────────────┼─────────────────────┤          ├──────────────┼───────────────────────┼──────────────────┼──────────────────────────────────────────────────────────────┤
# │ coreutils          │ CVE-2016-2781       │          │ will_not_fix │ 9.1-1                 │                  │ coreutils: Non-privileged session can escape to the parent   │
# │                    │                     │          │              │                       │                  │ session in chroot                                            │
# │                    │                     │          │              │                       │                  │ https://avd.aquasec.com/nvd/cve-2016-2781                    │








