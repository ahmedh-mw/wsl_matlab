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
export cp_image_name="container_to_checkpoint_img:v1"
sudo podman run -it --name $cp_container_name $warm_image_name /bin/bash
<<COMMENT_BLOCK
matlab
matlabSessionInit
COMMENT_BLOCK

sudo podman container checkpoint --keep $cp_container_name
sudo podman commit $cp_container_name $cp_image_name
# --log-level=debug



export cid=$(sudo podman container inspect --format '{{.Id}}' $cp_container_name)
# sudo ls /tmp/$cp_image_name
# sudo rm -rf /tmp/$cp_image_name
sudo ls /tmp/containers
time sudo cp -r /var/lib/containers/storage/overlay-containers/$cid /tmp/containers/cp4
# sudo ls /tmp/containers/$cid
# sudo du -sh /var/lib/containers/storage/overlay-containers/$cid/userdata
# sudo ls /var/lib/containers/storage/overlay-containers/$cid/userdata/config.json
# sudo cat /var/lib/containers/storage/overlay-containers/$cid/userdata/config.json


sudo podman container run -it --name test_cp $cp_image_name /bin/bash
export cid=$(sudo podman container inspect --format '{{.Id}}' test_cp)
sudo podman container checkpoint --keep test_cp
time sudo rm -rf /var/lib/containers/storage/overlay-containers/$cid/userdata/
time sudo cp -r /tmp/containers/cp3/userdata /var/lib/containers/storage/overlay-containers/$cid


time sudo podman container restore --keep --print-stats test_cp
sudo podman exec -it $cp_container_name py-matlab --batch 'sqrt(16)'
sudo podman stop $cp_container_name


sudo podman ps -a






#xxx sudo podman container checkpoint --keep --create-image $cp_container_name
# sudo podman container checkpoint --keep --create-image $CHECKPOINT_IMAGE $warm_container_name
# --tcp-established --file-locks
# --tcp-established --file-locks
# --log-level=debug 
sudo podman container checkpoint --keep $cp_container_name

sudo podman container restore  --keep --print-stats $cp_container_name
sudo podman container attach $cp_container_name
sudo podman exec -it $cp_container_name py-matlab --batch 'sqrt(16)'
sudo podman exec -it $cp_container_name py-matlab --batch 'new_system("f")'

sudo podman ps -a | grep $cp_container_name
sudo podman container rm -f $cp_container_name


sudo podman container run --name $cp_container_name $cp_image_name echo "Started"
export cid=$(sudo podman container inspect --format '{{.Id}}' $cp_container_name)
# echo $cid
sudo ls /var/lib/containers/storage/overlay-containers/$cid/userdata/
time sudo rm -rf /var/lib/containers/storage/overlay-containers/$cid/userdata/
time sudo cp -r /tmp/containers/cp1/userdata /var/lib/containers/storage/overlay-containers/$cid


time sudo podman container start $cp_container_name
time sudo podman container restore --log-level=debug --keep --print-stats $cp_container_name


# sudo mkdir -p /var/lib/containers/storage/overlay-containers/$cid/userdata
# sudo rm -rf /var/lib/containers/storage/overlay-containers/$cid/userdata







sudo ls /var/lib/containers/storage/overlay-containers/$cid/userdata/checkpoint



sudo podman container restore --log-level=debug --keep --print-stats --name $cp_container_name --checkpoint-name $CHECKPOINT_IMAGE
sudo podman container stop $cp_container_name


sudo podman exec -it $cp_container_name py-matlab --batch 'new_system("c")'
sudo podman exec -it $cp_container_name py-matlab --batch '12*12'
##############################################
#    Restore Checkpoint
##############################################
sudo podman container restore $CHECKPOINT_IMAGE --keep --print-stats --name matlab_restored
sudo podman exec -it matlab_restored py-matlab --batch 'sqrt(16)'
sudo podman exec -it matlab_restored py-matlab --batch 'new_system("c")'
sudo podman exec -it matlab_restored /bin/bash


# sudo podman exec -it $warm_container_name py-matlab --batch 'new_system("c")'

export container_name="matlab_restored1"
time {
    sudo podman container restore $CHECKPOINT_IMAGE --name $container_name
    sudo podman exec -it $container_name py-matlab --batch 'sqrt(16)'
    sudo podman exec -it $container_name py-matlab --batch 'new_system("c")'
}
time {
    sudo podman exec -it $container_name py-matlab --batch 'sqrt(36)'
}



podman container rm -f $cp_container_name
podman container restore --name $cp_container_name --checkpoint-name <checkpoint-name>
##############################################
#    Cleanup
##############################################
sudo podman image ls

sudo podman stop -t0 $(sudo podman ps -aq --filter "label!=org.opencontainers.image.title=Portainer")
sudo podman rm -f $(sudo podman ps -aq --filter "label!=org.opencontainers.image.title=Portainer")
sudo podman ps -a
sudo podman container prune
sudo podman ps -a