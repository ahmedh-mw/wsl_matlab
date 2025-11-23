export CI_IMAGE_NAME="matlab_ci"
export CI_IMAGE_TAG="r2024b_oct25_ready"
export IMAGE_FULLNAME="$CI_IMAGE_NAME:$CI_IMAGE_TAG"
export CHECKPOINT_IMAGE="matlab_ci_checkpoint_img:v1"
export MLM_LICENSE_TOKEN="$(yq '.settings.secrets.mlm_license_token' ./../env.yml)"
##############################################
#    Clean up previous containers/images
##############################################
sudo podman image ls

sudo podman stop -t0 $(sudo podman ps -aq --filter "label!=org.opencontainers.image.title=Portainer")
sudo podman rm -f $(sudo podman ps -aq --filter "label!=org.opencontainers.image.title=Portainer")
sudo podman ps -a

# sudo podman container rm -f $cp_container_test
cd /tmp
##############################################
#    #-Export  #-compress=none
##############################################
export cp_container_name="container_to_checkpoint"
export cp_container_test="container_test_export"

sudo podman run -d --name $cp_container_name -e MLM_LICENSE_TOKEN=$MLM_LICENSE_TOKEN $IMAGE_FULLNAME matlab-batch "matlabSessionLoop();"
sudo podman exec $cp_container_name matlab-bs-wait

time sudo podman container checkpoint --compress=none --export=checkpoint_dump.tar $cp_container_name

time sudo podman container restore --import=checkpoint_dump.tar --name $cp_container_test
sudo podman exec $cp_container_test matlab-bs -batch "disp('test123');pause(1);disp('test456');"
sudo podman exec $cp_container_test matlab-bs -batch "disp('test___1');disp('test___2');"
sudo podman exec $cp_container_test matlab-bs -batch "new_system('b')"
sudo podman exec $cp_container_test matlab-bs -batch "x=14"
sudo podman exec $cp_container_test matlab-bs -batch "x"