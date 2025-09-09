#####################################################################
#           Installing MATLAB dependencies
#####################################################################
# https://github.com/mathworks-ref-arch/container-images/tree/main/matlab-deps
sudo apt-get update
mkdir ~/downloads

wget https://raw.githubusercontent.com/mathworks-ref-arch/container-images/refs/heads/main/matlab-deps/r2024b/ubuntu24.04/base-dependencies.txt -O ~/downloads/base-dependencies.txt
sudo apt-get install --no-install-recommends -y `cat ~/downloads/base-dependencies.txt`
sudo ln -s /lib64/ld-linux-x86-64.so.2 /lib64/ld-lsb-x86-64.so.3

#####################################################################
#           Installing MATLAB
#####################################################################
# https://www.mathworks.com/help/install/ug/get-mpm-os-command-line.html
wget https://www.mathworks.com/mpm/glnxa64/mpm -O ~/downloads/mpm
chmod +x ~/downloads/mpm
sudo chown $USER /opt
cd ~/downloads

./mpm install --release=R2024b --destination /opt/matlab/R2024b --products Simulink Simulink_Coder Simscape Stateflow
sudo ln -s /opt/matlab/R2024b/bin/matlab /usr/local/bin/matlab
# Activate/provide your license 

