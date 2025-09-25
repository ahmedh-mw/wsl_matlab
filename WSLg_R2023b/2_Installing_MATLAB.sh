#####################################################################
#           Installing MATLAB dependencies
#####################################################################
# https://github.com/mathworks-ref-arch/container-images/tree/main/matlab-deps
sudo apt-get update
mkdir ~/downloads

wget https://raw.githubusercontent.com/mathworks-ref-arch/container-images/refs/heads/main/matlab-deps/r2023b/ubuntu22.04/base-dependencies.txt -O ~/downloads/base-dependencies.txt
sudo apt-get install --no-install-recommends -y `cat ~/downloads/base-dependencies.txt`

#####################################################################
#           Installing MATLAB
#####################################################################
# https://www.mathworks.com/help/install/ug/get-mpm-os-command-line.html
wget https://www.mathworks.com/mpm/glnxa64/mpm -O ~/downloads/mpm
chmod +x ~/downloads/mpm
sudo chown $USER /opt
cd ~/downloads

./mpm install --release=R2023b --destination /opt/matlab/R2023b --products Simulink Simulink_Coder Simscape Stateflow
sudo ln -s /opt/matlab/R2023b/bin/matlab /usr/local/bin/matlab

# Activate/provide your license 

matlab