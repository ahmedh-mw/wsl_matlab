#####################################################################
#           Installing Docker CE
#####################################################################
# https://docs.docker.com/engine/install/ubuntu/
# Add Docker's official GPG key for ubuntu:
sudo apt-get update
sudo apt-get install ca-certificates curl -y
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
# Add the repository to Apt sources:
echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
$(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
# Install docker engine
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

sudo tee /etc/docker/daemon.json > /dev/null <<EOF
{"default-ulimits": {"nofile": {"Name": "nofile","Hard": 65536,"Soft": 65536}}}
EOF

sudo systemctl restart docker

# Adjusting the access
sudo chown $USER /var/run/docker.sock
sudo usermod -aG docker $USER
newgrp docker

# Optional: Installing portainer-ce
# https://docs.portainer.io/start/install-ce/server/docker/linux
# docker volume create portainer_data
# docker run -d -p 8000:8000 -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:lts