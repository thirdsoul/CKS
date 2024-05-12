strace mkdir -p /tmp/testingsyscalls/
strace -c mkdir -p /tmp/testingsyscalls/ #with stats

#pid running process
pidof kubelet

strace -p $(pidof kubelet)



