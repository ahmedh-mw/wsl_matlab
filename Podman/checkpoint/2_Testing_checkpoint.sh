export CI_IMAGE_NAME="matlab_ci"
export CI_IMAGE_TAG="r2024b_oct25_ready"
export IMAGE_FULLNAME="$CI_IMAGE_NAME:$CI_IMAGE_TAG"
export CHECKPOINT_IMAGE="matlab_ci_checkpoint_img:v1"
# sudo apt-get install yq -y
# cd ~/wsl_matlab/Podman
export MLM_LICENSE_TOKEN="$(yq '.settings.secrets.mlm_license_token' ./../env.yml)"
##############################################
#    Clean up previous containers/images
##############################################
sudo podman image ls

sudo podman stop -t0 $(sudo podman ps -aq)
sudo podman rm -f $(sudo podman ps -aq)
sudo podman ps -a

##############################################
#    Creating checkpoint (#-Export  #-compress=none)
##############################################
cd ~
mkdir /tmp/ws_root
# Starting a standard MATLAB container
export cp_container_name="container_to_checkpoint"
time sudo podman run -d \
        --network=none \
        --name $cp_container_name \
        -e MLM_LICENSE_TOKEN=$MLM_LICENSE_TOKEN \
        -v /tmp/ws_root:/tmp/ws_root \
        $IMAGE_FULLNAME matlab-batch "matlabSessionLoop();"
echo "--------------------------------------- Container has been created"
time sudo podman exec $cp_container_name matlab-bs-wait-start
echo "--------------------------------------- MATLAB has been started"
time sudo podman exec $cp_container_name matlab-bs-wait-init
echo "--------------------------------------- MATLAB has been initialized"
time sudo podman exec $cp_container_name matlab-bs-wait-ready
echo "--------------------------------------- Container is ready"
time sudo podman container checkpoint --compress=none --export=checkpoint_dump.tar $cp_container_name
echo "--------------------------------------- Checkpoint has been exported"


##############################################
#    Warmup a dummy container - required for new machines
##############################################
cd ~
export cp_dummy="dummy_container"
time {
        sudo podman run -d \
                --network=none \
                --name $cp_dummy \
                alpine sleep infinity
        time sudo podman container checkpoint --compress=none --export=checkpoint_dump_small.tar $cp_dummy
        sudo podman stop -t0 $(sudo podman ps -aq)
        sudo podman rm -f $(sudo podman ps -aq)
        sudo podman ps -a
        
}
##############################################
#    Restoring checkpoint
##############################################
cd ~
mkdir /tmp/ws_root

export cp_container_test="container_test_export"
# time sudo podman container restore --import=checkpoint_dump.tar --name $cp_container_test
time sudo podman container restore --import=checkpoint_dump_bak.tar --name $cp_container_test
echo "--------------------------------------- Checkpoint has been restored"
sudo podman exec $cp_container_test matlab-bs -batch "disp('test123');pause(1);disp('test456');"
sudo podman exec $cp_container_test matlab-bs -batch "disp('test___1');disp('test___2');"
sudo podman exec $cp_container_test matlab-bs -batch "new_system('b')"
sudo podman exec $cp_container_test matlab-bs -batch "x=14"
sudo podman exec $cp_container_test matlab-bs -batch "x"
sudo podman exec $cp_container_test matlab-bs -batch "sqrt(36)"