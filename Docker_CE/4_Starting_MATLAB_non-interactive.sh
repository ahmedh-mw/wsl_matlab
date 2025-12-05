#####################################################################
#           Starting MATLAB Container
#####################################################################
export PADV_IMAGE="matlab_ci"
export PADV_IMAGE_TAG="r2024b_oct25"
export PADV_IMAGE_NAME="$PADV_IMAGE:$PADV_IMAGE_TAG"
# sudo apt-get update
# sudo apt-get install yq -y
export MLM_LICENSE_TOKEN="$(yq '.settings.secrets.mlm_license_token' ../env.yml)"


docker run -it --rm -e MLM_LICENSE_TOKEN=$MLM_LICENSE_TOKEN $PADV_IMAGE_NAME matlab-batch "disp('Hello from MATLAB non-interactive container'); exit;"
docker run -it --rm -e MLM_LICENSE_TOKEN=$MLM_LICENSE_TOKEN $PADV_IMAGE_NAME matlab-batch "disp('Hello from MATLAB non-interactive container'); system('pkill matlab');"


# Example of capturing output from Docker command from Windows host:
$PADV_IMAGE="matlab_ci"
$PADV_IMAGE_TAG="r2024b_oct25"
$PADV_IMAGE_NAME="${PADV_IMAGE}:${PADV_IMAGE_TAG}"
$MLM_LICENSE_TOKEN="$(yq '.settings.secrets.mlm_license_token' ../env.yml)"
$result = $(wsl -d Ubuntu -e docker run -it --rm -e MLM_LICENSE_TOKEN=$MLM_LICENSE_TOKEN $PADV_IMAGE_NAME matlab-batch "disp('Hello from MATLAB non-interactive container'); exit;");
echo $result;