# IPTABLES
# Adds the source IP address to the list. Drops ssh connection packets after 10 per minute.
iptables -A INPUT -i eth0 -p tcp --dport 22 -m state --state NEW -m recent --set
iptables -A INPUT -i eth0 -p tcp --dport 22 -m state --state NEW -m recent --seconds 60 --hitcount 10 -j DROP

# FIREWALL
# Applies to the default zone. Limits ssh connections to 10 per minute
firewall-cmd --permanent --add-rich-rule='rule service name=ssh limit value=10/m accept'


#OR ADMISSION CONTROLLER - EVENTRATELIMITS - CHECK ADMISSIONCONTROLLERS