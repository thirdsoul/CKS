# Creating the Certificate Authority's Certificate and Keys
# Generate a private key for the CA:

openssl genrsa 2048 > ca.key


#Generate the X509 certificate for the CA:
openssl req -new -x509 -days 365000 \
   -key ca.key \
   -out ca.crt

# Creating the Server's Certificate and Keys
# Generate the private key and certificate request:
openssl req -newkey rsa:2048 -days 365000 \
   -keyout server.key \
   -out server.csr


#Generate the X509 certificate for the server:
openssl x509 -req -days 365000 -set_serial 01 \
   -in server.csr \
   -out server.crt \
   -CA ca.crt \
   -CAkey ca.key

# Creating the Client's Certificate and Keys
# Generate the private key and certificate request:
openssl req -newkey rsa:2048 -days 365000 \
   -keyout client.key \
   -out client.csr

# Generate the X509 certificate for the client:
openssl x509 -req -days 365000 -set_serial 01 \
   -in client.csr \
   -out client.crt \
   -CA ca.crt \
   -CAkey ca.key

# Verifying the Certificates
# Verify the server certificate:
openssl verify -CAfile ca.crt \
   ca.crt \
   server.crt

# Verify the client certificate:
openssl verify -CAfile ca.crt \
   ca.crt \
   client.crt

openssl x509 -noout -modulus -in harbor.dominio.net.crt | openssl md5
openssl rsa -noout -modulus -in harbor.dominio.net.key | openssl md5