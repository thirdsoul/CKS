#aquasec-kubebench

kubectl apply -f https://raw.githubusercontent.com/aquasecurity/kube-bench/main/job.yaml;

kubectl get pods;
kubectl logs kube-bench-4fhw9;
# [INFO] 4 Worker Node Security Configuration
# [INFO] 4.1 Worker Node Configuration Files
# [FAIL] 4.1.1 Ensure that the kubelet service file permissions are set to 600 or more restrictive (Automated)
# [PASS] 4.1.2 Ensure that the kubelet service file ownership is set to root:root (Automated)
# [WARN] 4.1.3 If proxy kubeconfig file exists ensure permissions are set to 600 or more restrictive (Manual)
# [WARN] 4.1.4 If proxy kubeconfig file exists ensure ownership is set to root:root (Manual)
# [PASS] 4.1.5 Ensure that the --kubeconfig kubelet.conf file permissions are set to 600 or more restrictive (Automated)
# [PASS] 4.1.6 Ensure that the --kubeconfig kubelet.conf file ownership is set to root:root (Automated)
# [WARN] 4.1.7 Ensure that the certificate authorities file permissions are set to 600 or more restrictive (Manual)
# [PASS] 4.1.8 Ensure that the client certificate authorities file ownership is set to root:root (Manual)
# [FAIL] 4.1.9 If the kubelet config.yaml configuration file is being used validate permissions set to 600 or more restrictive (Automated)
# [PASS] 4.1.10 If the kubelet config.yaml configuration file is being used validate file ownership is set to root:root (Automated)
# [INFO] 4.2 Kubelet
# [PASS] 4.2.1 Ensure that the --anonymous-auth argument is set to false (Automated)
# [PASS] 4.2.2 Ensure that the --authorization-mode argument is not set to AlwaysAllow (Automated)
# [PASS] 4.2.3 Ensure that the --client-ca-file argument is set as appropriate (Automated)
# [PASS] 4.2.4 Verify that the --read-only-port argument is set to 0 (Manual)
# [PASS] 4.2.5 Ensure that the --streaming-connection-idle-timeout argument is not set to 0 (Manual)
# [PASS] 4.2.6 Ensure that the --make-iptables-util-chains argument is set to true (Automated)
# [PASS] 4.2.7 Ensure that the --hostname-override argument is not set (Manual)
# [PASS] 4.2.8 Ensure that the eventRecordQPS argument is set to a level which ensures appropriate event capture (Manual)
# [WARN] 4.2.9 Ensure that the --tls-cert-file and --tls-private-key-file arguments are set as appropriate (Manual)
# [PASS] 4.2.10 Ensure that the --rotate-certificates argument is not set to false (Automated)
# [PASS] 4.2.11 Verify that the RotateKubeletServerCertificate argument is set to true (Manual)
# [WARN] 4.2.12 Ensure that the Kubelet only makes use of Strong Cryptographic Ciphers (Manual)
# [WARN] 4.2.13 Ensure that a limit is set on pod PIDs (Manual)

# == Remediations node ==
# 4.1.1 Run the below command (based on the file location on your system) on the each worker node.
# For example, chmod 600 /lib/systemd/system/kubelet.service

# 4.1.3 Run the below command (based on the file location on your system) on the each worker node.
# For example,
# chmod 600 /etc/kubernetes/proxy.conf

# 4.1.4 Run the below command (based on the file location on your system) on the each worker node.
# For example, chown root:root /etc/kubernetes/proxy.conf

# 4.1.7 Run the following command to modify the file permissions of the
# --client-ca-file chmod 600 <filename>

# 4.1.9 Run the following command (using the config file location identified in the Audit step)
# chmod 600 /var/lib/kubelet/config.yaml


