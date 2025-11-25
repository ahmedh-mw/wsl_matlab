# MATLAB Checkpointing Using Podman
This document describes how to prepare your environment and explore checkpointing using Podman containers and MATLAB.

## 1. Installing Podman
Install Podman and its prerequisites using `Podman/1_Installing_podman.sh`.
- **Installing CRIU:** CRIU is required to enable checkpoint/restore functionality on Linux.
- **Installing crun:** The crun version that ships with some distributions may not include CRIU support. Build and install crun configured with CRIU support (use `--with-criu` when running `./configure`).
- Install the Podman package.
- Configure Podman to use the CRIU-enabled `crun` as the default runtime for reliable checkpoint/restore.

## 2. Building MATLAB image
Build a standard MATLAB image and add helper files using `Podman/3_Building_MATLAB_non-interactive_24b.sh`.
- Build the standard MATLAB image using `dockerfiles/non-interactive.Dockerfile`.
- Add checkpointing helper files using `dockerfiles/matlab-ci-ready.Dockerfile`.

## 4. Creating MATLAB checkpoint
Warming up and checkpointing a standard MATLAB container. See `Podman/checkpoint/2_Testing_checkpoint.sh`.
1. Starting a standard MATLAB container
    ```bash
    export IMAGE_FULLNAME="CI_IMAGE_NAME:CI_IMAGE_TAG"
    export MLM_LICENSE_TOKEN="********"
    export cp_container_name="CONTAINER_NAME"
    sudo podman run -d --name $cp_container_name \
        -e MLM_LICENSE_TOKEN=$MLM_LICENSE_TOKEN \
        -v <host_path>:<container_path> \
        $IMAGE_FULLNAME matlab-batch "matlabSessionLoop();"
    ```
    > matlabSessionLoop.m helper script is used to start an inter-process communication (IPC) loop"
1. Waiting for the MATLAB container to finish warming up
    ```bash
    sudo podman exec $cp_container_name matlab-bs-wait
    ```
    > matlab-bs-wait.m helper script is used to wait for all tcp connections within the container to complete.
1. Creating a MATLAB checkpoint
    ```bash
    time sudo podman container checkpoint --compress=none --export=checkpoint_dump.tar
    ```
    > Store the exported checkpoint tar file (`checkpoint_dump.tar`) on fast local storage (avoid slow or network-mounted paths) for best performance.

## 5. Restoring MATLAB checkpoint
Restoring a MATLAB checkpoint and executing commands. See `Podman/checkpoint/2_Testing_checkpoint.sh`.
1. Restore the MATLAB container
    ```bash
    export cp_container_test="container_test_export"
    time sudo podman container restore --import=checkpoint_dump.tar --name $cp_container_test
    ```
1. Run commands inside the restored container
    ```bash
    sudo podman exec $cp_container_test matlab-bs -batch "new_system('b')"
    sudo podman exec $cp_container_test matlab-bs -batch "sqrt(36)"
    ```
    > The `matlab-bs` helper script facilitates IPC between a `podman exec` process and the warmed MATLAB session inside the container.

## Configuring Podman runtimes (runc vs crun)
For checkpoint/restore with CRIU, `crun` built with `--with-criu` is the recommended runtime. `runc` may not reliably support all CRIU features on all distributions.

If you want to keep or set `runc` as the default runtime, you can create a non-interactive `containers.conf` with both runtimes available and choose the default. Example system-wide configuration:

```toml
[engine]
default_runtime = "runc" # change to "crun" to prefer crun for CRIU checkpoint/restore

[engine.runtimes]
# Paths to try for runc
runc = ["/usr/sbin/runc", "/usr/bin/runc"]
# Paths to try for crun (useful if you built crun into /usr/local/bin)
crun = ["/usr/local/bin/crun", "/usr/bin/crun"]
```

Non-interactive command to install `runc` and write a `containers.conf` example (run as root or with `sudo`):

```bash
sudo apt update
sudo apt install -y runc
sudo mkdir -p /etc/containers
sudo tee /etc/containers/containers.conf > /dev/null <<'EOF'
[engine]
default_runtime = "runc"

[engine.runtimes]
runc = ["/usr/sbin/runc", "/usr/bin/runc"]
crun = ["/usr/local/bin/crun", "/usr/bin/crun"]
EOF

# Verify Podman picks up the runtimes
podman info --format json | jq '.host.ociRuntime' || podman info | grep -A 10 'ociRuntime'

# Quick runtime tests
sudo podman run --rm --runtime runc alpine sh -c 'echo "hello from runc"'
sudo podman run --rm --runtime crun alpine sh -c 'echo "hello from crun"'
```

Notes:
- Use `command -v runc` or `command -v crun` to confirm the exact binary paths on your system and adjust `containers.conf` accordingly.
- For rootless Podman, place a similar file at `~/.config/containers/containers.conf` to affect only the current user.
- For reliable CRIU-based checkpoint/restore workflows prefer `crun` built with CRIU support.

If you'd like, I can also update `Podman/1_Installing_podman.sh` to install `runc` and replace the `nano` step with an idempotent `tee` snippet so the script runs non-interactively.