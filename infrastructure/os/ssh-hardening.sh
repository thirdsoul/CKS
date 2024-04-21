ssh node01
ssh user@node01
ssh-keygen –t rsa
# Public Key: /home/mark/.ssh/id_rsa.pub
# Private Key: /home/mark/.ssh/id_rsa
ssh-copy-id mark@node01
#After copy id we can ssh without being prompted
ssh node01
#And in node01 we will see the key in
cat /home/mark/.ssh/authorized_keys



#Harden ssh
vi /etc/ssh/sshd_config
# PermitRootLogin no
# PasswordAuthentication no
systemctl restart sshd
