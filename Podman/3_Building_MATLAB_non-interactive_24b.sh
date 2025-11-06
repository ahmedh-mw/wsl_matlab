#####################################################################
#           Building MATLAB non-interactive Image
#####################################################################

# chmod +x *
export PADV_IMAGE="matlab_ci"
export MATLAB_RELEASE="R2024b"
export PADV_IMAGE_TAG="r2024b_oct25"
export PADV_IMAGE_NAME="$PADV_IMAGE:$PADV_IMAGE_TAG"
export PRODUCTS="MATLAB Simulink Simulink_Check Simulink_Design_Verifier Simulink_Report_Generator Simulink_Coder Simulink_Compiler Simulink_Test Embedded_Coder Simulink_Coverage Requirements_Toolbox CI/CD_Automation_for_Simulink_Check"

sudo podman build -f dockerfiles/non-interactive.Dockerfile \
    --build-arg MATLAB_RELEASE="$MATLAB_RELEASE" \
    --build-arg MATLAB_PRODUCT_LIST="$PRODUCTS" \
    -t "$PADV_IMAGE_NAME" .

sudo podman build -f dockerfiles/matlab-ci-ready.Dockerfile -t "matlab_ci:r2024b_ci_Aug25" .