curl -LO https://dl.k8s.io/release/v1.29.2/bin/linux/amd64/kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"

echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check
#Output should be
#kubectl: OK
#if it fails
# kubectl: FAILED
# sha256sum: WARNING: 1 computed checksum did NOT match




