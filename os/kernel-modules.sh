lsmod
# Module Size Used by
# floppy 69417 0
# xt_conntrack 16384 1
# ipt_MASQUERADE 16384 1
# nf_nat_masquerade_ipv4 16384 1 ipt_MASQUERADE
# nf_conntrack_netlink 40960 0
# nfnetlink 16384 2 nf_conntrack_netlink
# xfrm_user 32768 1
# xfrm_algo 16384 1 xfrm_user
# xt_addrtype 16384 2
# iptable_filter 16384 1
# iptable_nat 16384 1
# nf_conntrack_ipv4 16384 3
# nf_defrag_ipv4 16384 1 nf_conntrack_ipv4
# nf_nat_ipv4 16384 1 iptable_nat
# nf_nat 32768 2 nf_nat_masquerade_ipv4,nf_nat_ipv4
# nf_conntrack 131072 7
# bluetooth 544768 43 btrtl,btintel,btbcm,bnep,btusb,rfcom

cat /etc/modprobe.d/blacklist.conf    #blacklisting sctp service
#blacklist sctp

shutdown –r now  #A restart is necessary

lsmod | grep sctp  #Validate sctp is removed