getenforce #check selinux current mode
setenforce [enforcing|permissive|disabled] #set selinux mode
sestatus #display current mode and policy
seinfo #more information about policies.

#DISABLED needs some operations and then reboot
# - Via Configuration file
#Edit the SELinux configuration file (usually /etc/selinux/config? and set SELINUX=disabled, then reboot. 
#This is the default method and should be used to permanently disable SELinux.
# - Via Kernel parameter
# Add selinux=0 to the Kernel parameter list when rebooting.

getenforce
# Enforcing>
sudo setenforce Permissive
getenforce
# Permissive

# SELINUX POLICIES
Default ones are

targeted  #User processes and init processes are not targeted. Network services are tareted.
minimum #Only selected processes are targeted
Multi-Level Security   #All processes are placed in fine-grained security domains with particular policies.

#contexts are labels applied to files, directories, ports, and processes. 
#Those labels are used to describe access rules. There are four SELinux contexts: 
User, Role, Type, and Level.
#Type labels finish in _t (sufix)

ls -Z
ps auZ
chcon -t etc_t somefile
chcon --reference somefile someotherfile

##################################################################################################################
##################################################################################################################
#EXAMPLE

ls -Z
#-rw-rw-r--. dog dog unconfined_u:object_r:user_home_t:s0 somefile

chcon -t etc_t somefile
ls -Z
#-rw-rw-r--. dog dog unconfined_u:object_r:etc_t:s0 somefile

ls -Z
# -rw-rw-r--. dog dog unconfined_u:object_r:etc_t:s0 somefile
# -rw-rw-r--. dog dog unconfined_u:object_r:user_home_t:s0 somefile1

chcon --reference somefile somefile1
ls -Z
# -rw-rw-r--. dog dog unconfined_u:object_r:etc_t:s0 somefile
# -rw-rw-r--. dog dog unconfined_u:object_r:etc_t:s0 somefile1

##################################################################################################################
##################################################################################################################
#Many standard command line commands, such as ls and ps, were extended to support SELinux

ps axZ
# LABEL PID TTY STAT TIME COMMAND
# system_u:system_r:init_t:s0 1 ? Ss 0:04 /usr/lib/systemd/systemd --switched-root ...
# system_u:system_r:kernel_t:s0 2 ? S 0:00 [kthreadd]
# ...
# unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 2305 ? D 0:00 sshd: jimih@pts/0
# unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 2306 pts/0 Ss 0:00 -bash
# ...
# system_u:system_r:httpd_t:s0 7490 ? Ss 0:00 /usr/sbin/httpd -DFOREGROUND
# system_u:system_r:httpd_t:s0 7491 ? S 0:00 /usr/sbin/httpd -DFOREGROUND 1
# ...


ls -Z /home/ /tmp/
# /home/:
# drwx------. jimih jimih unconfined_u:object_r:user_home_dir_t:s0 jimih
# /tmp/:
# -rwx------. root root system_u:object_r:initrc_tmp_t:s0 ks-script-c4ENhg
# drwx------. root root system_u:object_r:tmp_t:s0 systemd-private-0ofSvO
# -rw-------. root root system_u:object_r:initrc_tmp_t:s0 yum.log

# Other tools that were extended to support SELinux include cp, mv, and mkd

##################################################################################################################
##################################################################################################################
#MOVE A FILE CAN GENERATE ISSUES (SELINUX LEVEL OF THE SOURCE DIRECTORY , NOT THE TARGET)
#HERE YOU SEE A FILE, TMPFILE, HAVING CONTEXT ISSUES AFTER BEING MOVED
#WE RESTORE THE SELINUX LEVEL

ls -Z
# -rw-rw-r--. jimih jimih unconfined_u:object_r:user_home_t:s0 homefile
# -rw-rw-r--. jimih jimih unconfined_u:object_r:user_tmp_t:s0 tmpfile

restorecon -Rv /home/jimih
restorecon reset /home/jimih/tmpfile context unconfined_u:object_r:user_tmp_t:s0->unconfined_u:object_r:user_home_t:s0

ls -Z
# -rw-rw-r--. jimih jimih unconfined_u:object_r:user_home_t:s0 homefile
# -rw-rw-r--. jimih jimih unconfined_u:object_r:user_home_t:s0 tmpfile

##################################################################################################################
##################################################################################################################
#SEMANAGE . semanage fcontext only changes the default settings; it does not apply them to existing objects
mkdir /virtualHosts
ls -Z
# ...
# drwxr-xr-x. root root unconfined_u:object_r:default_t:s0 virtualHosts

semanage fcontext -a -t httpd_sys_content_t /virtualHosts
ls -Z
# ...
# drwxr-xr-x. root root unconfined_u:object_r:default_t:s0 virtualHosts

restorecon -RFv /virtualHosts
restorecon reset /virtualHosts context unconfined_u:object_r:default_t:s0->system_u:object_r:httpd_sys_content_t:s0

ls -Z
# drwxr-xr-x. root root system_u:object_r:httpd_sys_content_t:s0 virtualHosts

##################################################################################################################
##################################################################################################################
#SELINUX booleans

# getsebool: to see booleans
# setsebool: to set booleans
# semanage boolean -l: to see persistent boolean settings

setsebool allow_ftpd_anon_write on
getsebool allow_ftpd_anon_write
#   allow_ftpd_anon_write -> on
semanage boolean -l | grep allow_ftpd_anon_write
# allow_ftpd_anon_write -> off

# Note that this boolean will return to off after a reboot.

setsebool -P allow_ftpd_anon_write on  #This way we persist the change, with -P
semanage boolean -l | grep allow_ftpd_anon_write 
# allow_ftpd_anon_write -> on

semanage boolean -l
#List of booleans

##################################################################################################################
##################################################################################################################
#MONITORING SELINUX ACCESS

echo 'File created at /root' > rootfile
mv rootfile /var/www/html/
wget -O - localhost/rootfile
# ....
# HTTP request sent, awaiting response... 403 Forbidden
# 2014-11-21 13:42:04 ERROR 403: Forbidden.

tail /var/log/messages
# Nov 21 13:42:04 rhel7 setroubleshoot: SELinux is preventing /usr/sbin/httpd from getattr access on the file .
# For complete SELinux messages. run sealert -l d51d34f9-91d5-4219-ad1e-5531e61a2dc3
# Nov 21 13:42:04 rhel7 python: SELinux is preventing /usr/sbin/httpd from getattr access on the file .
# .....
# Do allow this access for now by executing:
# # grep httpd /var/log/audit/audit.log | audit2allow -M mypol
# # semodule -i mypol.pp
 
# Additional Information:
# Source Context system_u:system_r:httpd_t:s0
# Target Context unconfined_u:object_r:admin_home_t:s0