#check services running
systemctl list-units --type service
systemctl stop apache2
systemctl disable apache2
apt remove apache2