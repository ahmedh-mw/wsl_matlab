export CI_IMAGE_NAME="matlab_ci"
export CI_IMAGE_TAG="r2024b_oct25_ready"
export IMAGE_FULLNAME="$CI_IMAGE_NAME:$CI_IMAGE_TAG"
export CHECKPOINT_IMAGE="matlab_ci_checkpoint_img:v1"
##############################################
#    Create an initial warmed-up container
##############################################
export warm_container_name="container_to_warmup"
export warm_image_name="matlab_ci_warmed_img:v1"
sudo podman run -it --name $warm_container_name $IMAGE_FULLNAME /bin/bash
<<COMMENT_BLOCK
matlab
new_system('a')
COMMENT_BLOCK

sudo podman commit $warm_container_name $warm_image_name
##############################################
#    Create Checkpoint
##############################################
export cp_container_name="container_to_checkpoint"
sudo podman run -it --name $cp_container_name $warm_image_name /bin/bash
<<COMMENT_BLOCK
matlab
matlabSessionInit
COMMENT_BLOCK
sudo podman container checkpoint --create-image $CHECKPOINT_IMAGE $cp_container_name

##############################################
#    Restore Checkpoint
##############################################
sudo podman container restore $CHECKPOINT_IMAGE --name matlab_restored
sudo podman exec -it matlab_restored py-matlab --batch 'sqrt(16)'
sudo podman exec -it matlab_restored py-matlab --batch 'new_system("c")'
sudo podman exec -it matlab_restored /bin/bash


export container_name="matlab_restored1"
time {
    sudo podman container restore $CHECKPOINT_IMAGE --name $container_name
    sudo podman exec -it $container_name py-matlab --batch 'sqrt(16)'
    sudo podman exec -it $container_name py-matlab --batch 'new_system("c")'
}
time {
    sudo podman exec -it $container_name py-matlab --batch 'sqrt(36)'
}

##############################################
#    Cleanup
##############################################
sudo podman image ls

sudo podman rm -f $(sudo podman ps -aq --filter "label!=org.opencontainers.image.title=Portainer")
sudo podman stop -t0 $(sudo podman ps -aq --filter "label!=org.opencontainers.image.title=Portainer")
sudo podman ps -a
sudo podman container prune
sudo podman ps -a