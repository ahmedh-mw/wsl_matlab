#####################################################################
#           Installing runc
#####################################################################
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
sudo apt-get install -y docker-ce


#####################################################################
#           Installing podman
#####################################################################
sudo apt update
sudo apt-get install -y podman
# sudo apt remove --purge podman
# podman info

# - Ubuntu 24.04 comes without neither runc nor crun installed by default.
# - Installing Podman alone, wil linstall crun as a dependency and will configure Podman to use crun as the default runtime.
###################
# podman version 4.9.3
###################
# crun version 1.14.1
# commit: de537a7965bfbe9992e2cfae0baeb56a08128171
# rundir: /run/user/1000/crun
# spec: 1.0.0
# +SYSTEMD +SELINUX +APPARMOR +CAP +SECCOMP +EBPF +WASM:wasmedge +YAJL
###################


# - Installing runc will install version 1.3.0 of runc.
# - Installing Podman after or with runc will configure Podman to use runc as the default runtime.
###################
# runc version 1.3.0-0ubuntu2~24.04.1
# spec: 1.2.1
# go: go1.23.1
# libseccomp: 2.5.5
###################

# 16000 MB static RAM allocation with high mempry weight, 4 VCPU with 100 % reservation, default switch network adapter

# Optional: Installing portainer-ce
# https://docs.portainer.io/start/install-ce/server/docker/linux
# sudo podman volume create portainer_data
# sudo podman run -d -p 8000:8000 -p 9443:9443 --name portainer --restart=always -v /run/podman/podman.sock:/var/run/docker.sock -v portainer_data:/data docker.io/portainer/portainer-ce:lts