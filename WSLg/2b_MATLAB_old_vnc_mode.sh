#####################################################################
#           Installing WSLg
#####################################################################
wsl --list --online
wsl --install -d Ubuntu-24.04
wsl -d Ubuntu-24.04
sudo apt update && sudo apt upgrade -y

# For older WSL versions
# sudo mount -o remount,rw /tmp/.X11-unix
# Adding it to the .bashrc file
# echo `sudo mount -o remount,rw /tmp/.X11-unix` >> ~/.bashrc
# sudo apt install x11-apps -y
# xclock

#####################################################################
#           Enable VNC GUI Login
#####################################################################
sudo apt update
sudo apt install xfce4 xfce4-goodies dbus-x11 -y
# sudo apt-get install tasksel -y
# sudo tasksel

sudo apt install tigervnc-standalone-server -y
vncpasswd
# wsl --shutdown
vncserver -localhost no :1
