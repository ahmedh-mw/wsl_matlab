#####################################################################
#           Starting MATLAB Container
#####################################################################
# Run matlab with vnc
docker run -it --rm -p 5901:5901 -p 6080:6080 \
    -v /home/ahmedh/shared:/home/matlab/shared/ \
    "slcicd.azurecr.io/slcheck/padv-matlab:r2024b_Aug25" -vnc

