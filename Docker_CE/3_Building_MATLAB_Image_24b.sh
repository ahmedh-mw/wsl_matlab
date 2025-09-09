#####################################################################
#           Building MATLAB Image
#####################################################################
docker buildx build -f dockerfiles/building-on-matlab-docker-image.Dockerfile \
    --build-arg MATLAB_RELEASE=R2024b \
    --build-arg ADDITIONAL_PRODUCTS='Simulink Simulink_Check Simulink_Design_Verifier Simulink_Report_Generator Simulink_Coder Simulink_Compiler Simulink_Test Embedded_Coder Simulink_Coverage Requirements_Toolbox CI/CD_Automation_for_Simulink_Check' \
    -t "slcicd.azurecr.io/slcheck/padv-matlab:r2024b_Aug25" .

docker push "slcicd.azurecr.io/slcheck/padv-matlab:r2024b_Aug25"

