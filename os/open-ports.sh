systemctl status ssh
netstat -an | grep –w LISTEN
cat /etc/services | grep –w 53
# domain 53/tcp # Domain Name Server
# domain 53/udp

# check documentation for required kubernets ports.
# https://kubernetes.io/docs/reference/networking/ports-and-protocols/

#check if a port is open
nc 127.0.0.1 6443 -v