########################################
#    Installing criu
########################################
sudo add-apt-repository ppa:criu/ppa -y
sudo apt install criu -y
sudo apt update
cd /usr/sbin
sudo setcap cap_checkpoint_restore+eip criu
sudo criu check
# Should see: "Looks good."

##################
# Version: 4.1.1
##################

########################################
#    Set Options
########################################
sudo mkdir /etc/criu/
sudo nano /etc/criu/runc.conf             # <==== should use this one
# ------------------------------------
tcp-established
skip-in-flight
link-remap
ghost-limit 10000000
file-locks
external mnt[]:s
tcp-close true
enable-external-masters
skip-file-rwx-check
# ------------------------------------