apt-get update
apt-get install ufw
systemctl enable ufw
systemctl start ufw


ufw status  #It with show as non active

#SETUP FIREWALL RULES
ufw default allow outgoing   #All outgoing allow
ufw default deny incoming    #All incoming allow


ufw allow from 172.16.238.5 to any port 22 proto tcp   #Allow incoming from IP to port 22
ufw allow from 172.16.238.5 to any port 80 proto tcp   #Allow incoming from IP to port 80

ufw allow from 172.16.100.0/28 to any port 80 proto tcp  #CIDR

ufw deny 8080 #Deny a port

#ENABLE FIREWALL
ufw enable
ufw status  #It will show as active, and all the rules are listed

ufw delete 5 #You can delete a rule using its index (1...n)


