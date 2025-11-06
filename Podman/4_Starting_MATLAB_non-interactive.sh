#####################################################################
#           Starting MATLAB Container
#####################################################################
export PADV_IMAGE="matlab_ci"
export PADV_IMAGE_TAG="r2024b_oct25"
export PADV_IMAGE_NAME="$PADV_IMAGE:$PADV_IMAGE_TAG"
# sudo apt-get update
# sudo apt-get install yq -y
export MLM_LICENSE_TOKEN="$(yq '.settings.secrets.mlm_license_token' env.yml)"

sudo podman run -it --rm padv-matlab:r2024b_ci_Aug25 /bin/bash
sudo podman run -it --rm matlab_ci:r2024b_ci_Aug25 matlab -batch "disp('Hello from MATLAB non-interactive container'); new_system('a');exit;"
time sudo podman run -it --rm matlab_ci:r2024b_ci_Aug25 matlab -batch "disp('Hello from MATLAB non-interactive container'); new_system('a');exit;"