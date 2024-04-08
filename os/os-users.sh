id
who
last
# michael :1 :1 Tue May 12 20:00 still logged in
# sarah :1 :1 Tue May 12 12:00 still running
# reboot system boot 5.3.0-758-gen Mon May 11 13:00 - 19:00 (06:00
grep -i ^michael /etc/passwd
#michael:x:1001:1001::/home/michael:/bin/bash
grep -i ^michael /etc/shadow
grep -i ^bob /etc/group
usermod –s /bin/nologin michael
#michael:x:1001:1001::/home/michael:/bin/nologin
grep –i michael /etc/passwd
userdel bob
grep –i bob /etc/passwd
id michael
#uid=1001(michael) gid=1001(michael) groups=1001(michael),1000(admin)
deluser michael admin
# Removing user `michael` from group `admin` ...
# Done.
id michael
#uid=1001(michael) gid=1001(michael) groups=1001(michael)