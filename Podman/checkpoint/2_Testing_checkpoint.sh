##############################################
#    Create an initial warmed-up container
##############################################
# --privileged 
sudo podman run --security-opt seccomp=unconfined -it --name container_to_warm matlab_ci:r2024b_ci_Aug25 /bin/bash
<<COMMENT_BLOCK
matlab
new_system('a')
COMMENT_BLOCK

sudo podman commit container_to_warm matlab_ci_warmed_img:v1
##############################################
#    Create Checkpoint
##############################################
sudo podman run -it --name container_to_checkpoint matlab_ci_warmed_img:v1 /bin/bash
<<COMMENT_BLOCK
matlab
matlabSessionInit
COMMENT_BLOCK
sudo podman container checkpoint --create-image matlab_ci_checkpoint_img:v1 container_to_checkpoint

##############################################
#    Restore Checkpoint
##############################################
sudo podman container restore matlab_ci_checkpoint_img:v1 --name matlab_restored
sudo podman exec -it matlab_restored py-matlab --batch 'sqrt(16)'
sudo podman exec -it matlab_restored py-matlab --batch 'new_system("c")'
sudo podman exec -it matlab_restored /bin/bash


export container_name="matlab_restored1"
time {
    sudo podman container restore matlab_ci_checkpoint_img:v1 --name $container_name
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

sudo podman rm -f $(sudo podman ps -aq)
sudo podman stop --all -t0
sudo podman ps -a
sudo podman container prune
sudo podman ps -a