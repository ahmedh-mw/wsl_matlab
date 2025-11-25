# MATLAB Checkpointing Using Podman
This document descript how to prepare your environemnt and exblorer the checkpointing technology using Podman containers and MATLAB.

## 1. Installing Podman
Installing Podman and it's prerequsits using Podman\1_Installing_podman.sh 
1. **Installing criu:** this is the library required to enable checkpoint/restore functionality for Linux
1. **Installing crun:** becuase the built-in crun version installed automatically with Podman package in Ubuntu doesn't support criu, we have to build and install a crun version that supports criu. 
    > - Downloading crun repo
    > - Make sure to configure crun using '--with-criu' flag: ./configure --with-wasmedge --with-criu
    > - Build and install crun
1. Install Podman latest package
1. Configure Podman to use built crun as the default runtime

## 2. Building MATLAB image
Building a standard MATLAB image and adding few helper files using Podman\3_Building_MATLAB_non-interactive_24b.sh
1. Building standard MATLAB image using dockerfiles/non-interactive.Dockerfile
1. Adding checkpointing helper files using dockerfiles/matlab-ci-ready.Dockerfile.

## 4. Creating MATLAB checkpoint
Warming up and checkpointing a standard MATLAB container. (Podman\checkpoint\2_Testing_checkpoint.sh)
1. Starting a standard MATLAB container
    ```bash
    export IMAGE_FULLNAME="CI_IMAGE_NAME:CI_IMAGE_TAG"
    export MLM_LICENSE_TOKEN="********"
    export cp_container_name="CONTAINER_NAME"
    sudo podman run -d --name $cp_container_name \
    &nbsp;&nbsp;&nbsp;&nbsp;-e MLM_LICENSE_TOKEN=$MLM_LICENSE_TOKEN \
    &nbsp;&nbsp;&nbsp;&nbsp;-v <host_path>:<container_path> \
    &nbsp;&nbsp;&nbsp;&nbsp;$IMAGE_FULLNAME matlab-batch "matlabSessionLoop();"
    ```
    > matlabSessionLoop.m helper script is used to start an inter-process communication (IPC) loop"
1. Waiting MATLAB container to finish warming up
    ```bash
    sudo podman exec $cp_container_name matlab-bs-wait
    ```
    > matlab-bs-wait.m helper script is used to wait for all tcp connections within the container to complete.
1. Creating MATLAB checkpoint
    ```bash
    time sudo podman container checkpoint --compress=none --export=checkpoint_dump.tar 
    ```
    > Make sure to store the exported checkpoint tar file checkpoint_dump.tar in a fast IO drive media and avoid mounted paths for performance sake.

## 5. Restoring MATLAB checkpoint
Restoring MATLAB checkpoint and executing commands. (Podman\checkpoint\2_Testing_checkpoint.sh)
1. Restoring MATLAB container
    ```bash
    export cp_container_test="container_test_export"
    time sudo podman container restore --import=checkpoint_dump.tar --name $cp_container_test
    ```
1. Restoring MATLAB container
    ```bash
    sudo podman exec $cp_container_test matlab-bs -batch "new_system('b')"
    sudo podman exec $cp_container_test matlab-bs -batch "sqrt(36)"
    ```
    > matlab-bs.m helper bash script help handling IPC between container exec process and the warmed up MATLAB session process