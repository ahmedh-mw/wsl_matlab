#####################################################################
#           Starting MATLAB Container
#####################################################################
export CI_IMAGE_NAME="matlab_ci"
export CI_IMAGE_TAG="r2024b_oct25_ready"
export IMAGE_FULLNAME="$CI_IMAGE_NAME:$CI_IMAGE_TAG"

sudo podman run -it --rm $IMAGE_FULLNAME /bin/bash
sudo podman run -it --rm $IMAGE_FULLNAME matlab -batch "disp('Hello from MATLAB non-interactive container'); new_system('a');exit;"
time sudo podman run -it --rm $IMAGE_FULLNAME matlab -batch "disp('Hello from MATLAB non-interactive container'); new_system('a');exit;"


# sudo apt-get update
# sudo apt-get install yq -y
export MLM_LICENSE_TOKEN="$(yq '.settings.secrets.mlm_license_token' ./../env.yml)"
sudo podman run -it --rm -e MLM_LICENSE_TOKEN=$MLM_LICENSE_TOKEN --name test_bs $IMAGE_FULLNAME matlab-batch "run('~/matlabSessionInit.m');"
sudo podman exec test_bs matlab-bs -batch "disp('test123');pause(2);disp('test---');pause(2);disp('test123');"