#CONFIGURE SSL
mkdir -p data/certs;
cd data/certs;

#generate self CA
openssl genrsa -out ca.key 4096;

#generate CA certificate
openssl req -x509 -new -nodes -sha512 -days 3650 \
 -subj "/CN=harbor.dominio.net" \
 -key ca.key \
 -out ca.crt;

#generate private key for domain
openssl genrsa -out harbor.dominio.net.key 4096;

#generate CSR
openssl req -sha512 -new \
    -subj "/CN=harbor.dominio.net" \
    -key harbor.dominio.net.key \
    -out harbor.dominio.net.csr;

#generate v3 x509 ext file
cat > v3.ext <<-EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth
subjectAltName = @alt_names

[alt_names]
DNS.1=harbor.dominio.net
DNS.2=harbor.dominio
DNS.3=harbor
EOF

#approve and generate certificate
openssl x509 -req -sha512 -days 3650 \
    -extfile v3.ext \
    -CA ca.crt -CAkey ca.key -CAcreateserial \
    -in harbor.dominio.net.csr \
    -out harbor.dominio.net.crt;


