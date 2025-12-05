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

#####################################################################
#           Installing crun
#####################################################################
# Install Required Dependencies
sudo apt update
sudo apt install -y git build-essential autoconf automake libtool pkg-config libcap-dev libseccomp-dev libyajl-dev libsystemd-dev protobuf-c-compiler libprotobuf-c-dev python3-protobuf

cd ~
# Add WasmEdge repo and key
curl -sSf https://raw.githubusercontent.com/WasmEdge/WasmEdge/master/utils/install.sh | sudo bash -s -- -p /usr/local
# This script will install the latest WasmEdge in /usr/local
# By default, it includes the headers and libraries needed for development

# Clone crun Source Code
git clone https://github.com/containers/crun.git
cd crun
# Build crun with CRIU Support
./autogen.sh
./configure --with-wasmedge --with-criu
make
sudo make install
crun --version

#####################################################################
#           Installing podman
#####################################################################
sudo apt update
sudo apt-get install -y podman
# podman info | grep -A 10 'ociRuntime'
# sudo apt remove --purge podman
# podman info

# - Ubuntu 24.04 comes without neither runc nor crun installed by default.
###################
# podman version 4.9.3
###################
# crun version 1.25.0.0.0.1-993a
# commit: 993ad9d57f4c346d640f5e69d50dd5d182908978
# rundir: /run/user/1000/crun
# spec: 1.0.0
# +SYSTEMD +SELINUX +APPARMOR +CAP +SECCOMP +EBPF +CRIU +WASM:wasmedge +YAJL
###################

# Configure podman to use built crun as the default runtime
sudo tee /etc/containers/containers.conf > /dev/null <<EOF
[engine.runtimes]
crun = [
    "/usr/local/bin/crun"
]
EOF

# sudo cat /etc/containers/containers.conf
# ------------------------------------
sudo podman info | grep -A 10 'ociRuntime'

# 16000 MB static RAM allocation with high mempry weight, 4 VCPU with 100 % reservation, default switch network adapter

# Optional: Installing portainer-ce
# https://docs.portainer.io/start/install-ce/server/docker/linux
# sudo podman volume create portainer_data
# sudo podman run -d -p 8000:8000 -p 9443:9443 --name portainer --restart=always -v /run/podman/podman.sock:/var/run/docker.sock -v portainer_data:/data docker.io/portainer/portainer-ce:lts