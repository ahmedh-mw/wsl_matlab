#####################################################################
#           Starting MATLAB Container
#####################################################################
LICENSE_FOLDER="/home/ahmedh/licenses"
SHARED_FOLDER="/home/ahmedh/shared"
LICENSE_FILE_NAME="license.dat"
PADV_IMAGE_FULL_NAME="slcicd.azurecr.io/slcheck/padv-matlab:r2024b_apr25_spkg20250626"
DOCKER_REGISTRY_CREDENTIALS="<Docker Registry Credentials>"
# Login to your private container registery
docker login slcicd.azurecr.io -u slcicd -p $DOCKER_REGISTRY_CREDENTIALS

# Pull Down image
docker image pull $PADV_IMAGE_FULL_NAME
# Run matlab with vnc
docker run -it --rm -p 5901:5901 -p 6080:6080 \
    -v $LICENSE_FOLDER:/opt/matlab/R2024b/licenses \
    -v $SHARED_FOLDER:/home/matlab/shared/ \
    -e MLM_LICENSE_FILE=/opt/matlab/R2024b/licenses/$LICENSE_FILE_NAME \
    $PADV_IMAGE_FULL_NAME -vnc

