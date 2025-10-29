########################################
#    Run containers
########################################
export PADV_IMAGE="matlab_ci"
export PADV_IMAGE_TAG="r2024b_oct25"
export PADV_IMAGE_NAME="$PADV_IMAGE:$PADV_IMAGE_TAG"
export MLM_LICENSE_TOKEN="$(yq '.settings.secrets.mlm_license_token' env.yml)"


docker run --init -it --name matlab_demo -e MLM_LICENSE_TOKEN=$MLM_LICENSE_TOKEN $PADV_IMAGE_NAME /bin/bash
# matlab-batch "disp('Hello from MATLAB non-interactive container'); exit;"

