#Finding kernel vulnerabilities
git clone https://github.com/jondonas/linux-exploit-suggester-2.git
./linux-exploit-suggester-2.pl


# LINUX SECURITY MODULES
#     AppArmor: To restrict capabilities of an application.
#     SELinux: Implements MAC (Mandatory Access Control)
#     Smack (Simplified Mandatory Access Control Kernel)
#     TOMOYO: MAC implementation and system analysis.

# Seccomp
# Secure computing mode (seccomp) is a mechanism which restricts access to system calls by processes. 
# The idea is to reduce the attack surface of the kernel by preventing applications 
# from entering system calls they do not need. The system call API is a wide gateway to the kernel, 
# and as with all code, there have and are likely to be bugs present somewhere.
# The original seccomp code, also known as mode 1, provided access to only four system calls: 
# read(), write(), exit(), and sigreturn(). 
# These are the minimum required for a useful application, 
# and this was intended to be used to run untrusted code on otherwise idle systems.


#BLOCKING DYNAMIC MODULE LOADING

# System administrators can use a one-way method to block module loading after the 
# system has booted and all modules have been loaded. This mechanism consists 
# in writing "1" to kernel.modules_disabled. 
# This requires root or CAP_SYS_MODULE capabilities. No other module-related operations 
# will be allowed from that point on.
echo "1" > kernel.modules_disabled
#A reboot is required in order to get the kernel back to its default kernel.modules_disabled setting.


#ADAPTATIVE STACK LAYOUT RANDOMIZATION

# Avoid use known addresses of memory regions.
# This is set with kernel.randomize_va_space sysctl:
# 0: Disabled
# 1: Randomized stack, VDSO (Virtual Dynamic Shared Object), shared memory addresses
# 2: Randomized stack, VDSO, shared memory and data addresses.

#NO EXECUTE. 
#Protection of memory regions that should not contain executables.
# Look for the nx flag in /proc/cpuinfo. It may be enabled/disabled in BIOS.


# EXECSHIELD
# The ExecShield feature provides protection against stack, buffer or function pointer overflows, 
# and against other types of exploits that rely on overwriting data structures and/or putting code 
# into those structures. The patch also makes it harder to pass in and execute the 
# so-called shell-code of exploits. The patch works transparently, i.e. no application recompilation is necessary.
echo 0 > /proc/sys/kernel/exec-shield
💡

# Vt-d Virtualization
# look for vmx or svm in /proc/cpuinfo.


# Trusted Executed Technology (TXT)
# TXT is used to isolate the memory used by guest virtual machines. 
# A guest VM could have a malicious kernel that tried to access memory owned 
# by a host or another guest. TXT is an efficient, hardware-based method for preventing this from happening.


# Integrity Management
# The kernel’s integrity management subsystem may be used to maintain the integrity 
# of files on the system. The Integrity Measurement Architecture 
# (IMA) component performs runtime integrity measurements 
# of files using cryptographic hashes, comparing them with a list of valid hashes
    # Look for CONFIG_IMA in /boot/config*
    # Boot with ima_tcb and ima=on kernel parameters.

# Integrity Management with dm-verity
#     Check for CONFIG_DM_VERITY under /boot/config*.