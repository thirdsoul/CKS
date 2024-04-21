apt list --installed
apt list --installed | grep python2.7
apt remove nginx -y

#check services running
systemctl list-units --type service
systemctl stop apache2
systemctl disable apache2
apt remove apache2