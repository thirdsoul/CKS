sudo apt install nginx
# [sudo] password for michael:

grep -i ^root /etc/passwd
# root:x:0:0:root:/root:/usr/sbin/nologin

cat /etc/sudoers
# User privilege specification
# root ALL=(ALL:ALL) ALL
# # Members of the admin group may gain root privileges
# %admin ALL=(ALL) ALL
# # Allow members of group sudo to execute any command
# %sudo ALL=(ALL:ALL) ALL
# # Allow Bob to run any command
# mark ALL=(ALL:ALL) ALL
# # Allow Sarah to reboot the system
# sarah localhost=/usr/bin/shutdown -r now
# # See sudoers(5) for more information on "#include" 
# directives:
# #includedir /etc/sudoers.d

# 1 User or Group bob, %sudo (group)   -> primera entrada, users o grupos, grupos con %
# 2 Hosts localhost, ALL(default)  -> host o ALL
# 3 User ALL(default) 
# 4 Command /bin/ls, ALL(unrestricted)

# TO CONFIGURE IT USE VISUDO, NOT A NORMAL TEXT EDITOR
visudo