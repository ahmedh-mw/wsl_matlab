export CI_IMAGE_NAME="matlab_ci"
export CI_IMAGE_TAG="r2024b_oct25_ready"
export IMAGE_FULLNAME="$CI_IMAGE_NAME:$CI_IMAGE_TAG"
export CHECKPOINT_IMAGE="matlab_ci_checkpoint_img:v1"
##############################################
#    Create an initial warmed-up container
##############################################
export warm_container_name="container_to_warmup"
export warm_image_name="matlab_ci_warmed_img:v1"
# sudo apt-get install yq -y
export MLM_LICENSE_TOKEN="$(yq '.settings.secrets.mlm_license_token' ./../env.yml)"

sudo podman run -it --name $warm_container_name -e MLM_LICENSE_TOKEN=$MLM_LICENSE_TOKEN $IMAGE_FULLNAME matlab-batch "matlabSessionLoop();"
sudo podman commit $warm_container_name $warm_image_name

sudo podman image ls

sudo podman stop -t0 $(sudo podman ps -aq --filter "label!=org.opencontainers.image.title=Portainer")
sudo podman rm -f $(sudo podman ps -aq --filter "label!=org.opencontainers.image.title=Portainer")
sudo podman ps -a

cd /tmp
##############################################
#    [1] #-In-Place    #-No configuration
##############################################
export cp_container_name="container_to_checkpoint"
sudo podman run -it --name $cp_container_name -e MLM_LICENSE_TOKEN=$MLM_LICENSE_TOKEN $warm_image_name matlab-batch "matlabSessionLoop();"
time sudo podman container checkpoint $cp_container_name
time sudo podman container restore $cp_container_name

sudo podman exec $cp_container_name matlab-bs -batch "disp('test123');pause(1);disp('test456');"
##############################################
#    [2] #-Export    #-No configuration
##############################################
export cp_container_test2="container_test_export2"
sudo podman run -it --name $cp_container_name -e MLM_LICENSE_TOKEN=$MLM_LICENSE_TOKEN $warm_image_name matlab-batch "matlabSessionLoop();"
time sudo podman container checkpoint --export=dump2.tar $cp_container_name
time sudo podman container restore --import=dump2.tar --name $cp_container_test2

sudo podman exec $cp_container_test2 matlab-bs -batch "disp('test123');pause(1);disp('test456');"
##############################################
#    [3] #-Export  #-compress=none  #-No configuration
##############################################
export cp_container_test3="container_test_export3"
sudo podman run -it --name $cp_container_name -e MLM_LICENSE_TOKEN=$MLM_LICENSE_TOKEN $warm_image_name matlab-batch "matlabSessionLoop();"
time sudo podman container checkpoint --compress=none --export=dump3.tar $cp_container_name
time sudo podman container restore --import=dump3.tar --name $cp_container_test3
time sudo podman container restore --import=dump3.tar --name container_test_export3c

sudo podman container rm -f $cp_container_name
sudo podman container rm -f $cp_container_test3
sudo podman exec $cp_container_test3 matlab-bs -batch "disp('test123');pause(1);disp('test456');"
sudo podman exec $cp_container_test3 matlab-bs -batch "disp(string(sqrt(9)));disp(string(22/44));"
sudo podman ps -a
##############################################
#    [4] #-Export  #-tcp-established  #-No configuration
##############################################
export cp_container_test4="container_test_export4"
sudo podman run -it --name $cp_container_name -e MLM_LICENSE_TOKEN=$MLM_LICENSE_TOKEN $warm_image_name matlab-batch "matlabSessionLoop();"
time sudo podman container checkpoint --tcp-established --export=dump4.tar $cp_container_name
time sudo podman container restore --import=dump4.tar --name $cp_container_test4

sudo podman exec $cp_container_test4 matlab-bs -batch "system('netstat -tnp')"
##############################################
#    [5] #-Export  #-tcp-established #-file-locks  #-No configuration
##############################################
export cp_container_test5="container_test_export5"
sudo podman run -it --name $cp_container_name -e MLM_LICENSE_TOKEN=$MLM_LICENSE_TOKEN $warm_image_name matlab-batch "matlabSessionLoop();"
time sudo podman container checkpoint --file-locks --tcp-established --export=dump5.tar $cp_container_name
time sudo podman container restore --file-locks --import=dump5.tar --name $cp_container_test5

sudo podman exec $cp_container_test5 matlab-bs -batch "disp('test123');pause(1);disp('test456');"

##############################################
#    [6] #-create-image  #-No configuration
##############################################
export cp_container_test6="container_test_export6"
sudo podman run -it --name $cp_container_name -e MLM_LICENSE_TOKEN=$MLM_LICENSE_TOKEN $warm_image_name matlab-batch "matlabSessionLoop();"
time sudo podman container checkpoint --create-image $CHECKPOINT_IMAGE $cp_container_name
time sudo podman container restore $CHECKPOINT_IMAGE --name $cp_container_test6

sudo podman exec $cp_container_test5 matlab-bs -batch "disp('test123');pause(1);disp('test456');"

##############################################
#    [7] #-Export  #-compress=none #-ignore-rootfs #-No configuration
##############################################
export cp_container_test7="container_test_export7"
sudo podman run -it --name $cp_container_name -e MLM_LICENSE_TOKEN=$MLM_LICENSE_TOKEN $warm_image_name matlab-batch "matlabSessionLoop();"
time sudo podman container checkpoint --ignore-rootfs --compress=none --export=dump7.tar $cp_container_name
time sudo podman container restore --ignore-rootfs --import=dump7.tar --name $cp_container_test7

sudo podman exec $cp_container_test7 matlab-bs -batch "disp('test123');pause(1);disp('test456');"
sudo podman exec $cp_container_test7 matlab-bs -batch "disp(string(sqrt(9)));disp(string(22/44));"