#####################################################################
#           Building MATLAB Image
#####################################################################
docker buildx build -f dockerfiles/building-on-matlab-docker-image.Dockerfile \
    --build-arg MATLAB_RELEASE=R2023b \
    --build-arg ADDITIONAL_PRODUCTS='Simulink Simulink_Coder Simscape Stateflow' \
    -t "slcicd.azurecr.io/slcheck/padv-matlab:r2023b" .