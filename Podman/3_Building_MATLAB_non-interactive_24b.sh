#####################################################################
#           Building MATLAB non-interactive Image
#####################################################################

# chmod +x *
export CI_IMAGE_NAME="slcicd.azurecr.io/slcheck/matlab_ci"
export MATLAB_RELEASE="R2024b"
export CI_IMAGE_TAG="r2024b_oct25"
export IMAGE_FULLNAME="$CI_IMAGE_NAME:$CI_IMAGE_TAG"
export PRODUCTS="MATLAB Simulink Simulink_Check Simulink_Design_Verifier Simulink_Report_Generator Simulink_Coder Simulink_Compiler Simulink_Test Embedded_Coder Simulink_Coverage Requirements_Toolbox CI/CD_Automation_for_Simulink_Check"
# cd ~/wsl_matlab/Podman/
sudo podman build -f dockerfiles/non-interactive.Dockerfile \
    --build-arg MATLAB_RELEASE="$MATLAB_RELEASE" \
    --build-arg MATLAB_PRODUCT_LIST="$PRODUCTS" \
    -t "$IMAGE_FULLNAME" .

export CI_IMAGE_TAG="r2024b_oct25_ready"
sudo sed -i 's/\r$//' imagefiles/matlab-bs*
export CI_IMAGE_FULLNAME="$CI_IMAGE_NAME:$CI_IMAGE_TAG"
sudo podman build -f dockerfiles/matlab-ci-ready.Dockerfile \
    --build-arg BASE_IMAGE="$IMAGE_FULLNAME" \
    -t "$CI_IMAGE_FULLNAME" .

# cd ~/wsl_matlab/Podman/
# sudo apt-get install yq -y
# sudo podman login slcicd.azurecr.io -u slcicd -p "$(yq -r '.settings.secrets.docker_registry_credentials' ./../env.yml)"
# sudo podman pull "$CI_IMAGE_FULLNAME"
# sudo podman push "$CI_IMAGE_FULLNAME"