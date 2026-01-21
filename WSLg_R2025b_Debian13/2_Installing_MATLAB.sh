#####################################################################
#           Installing MATLAB dependencies
#####################################################################
# https://github.com/mathworks-ref-arch/container-images/tree/main/matlab-deps
sudo apt-get update
mkdir ~/downloads

sudo apt install wget
wget https://raw.githubusercontent.com/mathworks-ref-arch/container-images/refs/heads/main/matlab-deps/r2025b/ubuntu24.04/base-dependencies.txt -O ~/downloads/base-dependencies.txt
sed -i '/libuhd4.6.0-dpdk/d' ~/downloads/base-dependencies.txt
sudo apt-get install --no-install-recommends -y `cat ~/downloads/base-dependencies.txt`

#####################################################################
#           Installing MATLAB
#####################################################################
# https://www.mathworks.com/help/install/ug/get-mpm-os-command-line.html
wget https://www.mathworks.com/mpm/glnxa64/mpm -O ~/downloads/mpm
chmod +x ~/downloads/mpm
sudo chown $USER /opt
cd ~/downloads

# ./mpm install --release=R2025b --destination /opt/matlab/R2025b --products Simulink Simulink_Coder
./mpm install --release=R2025b --destination /opt/matlab/R2025b --products Simulink Simulink_Check Simulink_Design_Verifier Simulink_Report_Generator Simulink_Coder Simulink_Compiler Simulink_Test Embedded_Coder Simulink_Coverage Requirements_Toolbox CI/CD_Automation_for_Simulink_Check
sudo ln -s /opt/matlab/R2025b/bin/matlab /usr/local/bin/matlab

wget -q 'https://raw.githubusercontent.com/mathworks-ref-arch/matlab-dockerfile/main/alternates/non-interactive/install/install-matlab-batch.sh' \
    && sudo bash ./install-matlab-batch.sh \
    && rm ./install-matlab-batch.sh

# export MLM_LICENSE_TOKEN=""
# Activate/provide your license 

# sudo apt install python3 -y
# sudo apt install git gettext -y