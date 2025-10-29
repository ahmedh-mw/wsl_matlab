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

########################################
#    Enabling Docker Experimental Features
########################################
sudo nano /etc/docker/daemon.json
{
"experimental": true
}
sudo systemctl restart docker