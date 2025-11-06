#####################################################################
#           Starting MATLAB Container
#####################################################################
export CI_IMAGE_NAME="matlab_ci"
export CI_IMAGE_TAG="r2024b_oct25_ready"
export IMAGE_FULLNAME="$CI_IMAGE_NAME:$CI_IMAGE_TAG"

sudo podman run -it --rm $IMAGE_FULLNAME /bin/bash
sudo podman run -it --rm $IMAGE_FULLNAME matlab -batch "disp('Hello from MATLAB non-interactive container'); new_system('a');exit;"
time sudo podman run -it --rm $IMAGE_FULLNAME matlab -batch "disp('Hello from MATLAB non-interactive container'); new_system('a');exit;"