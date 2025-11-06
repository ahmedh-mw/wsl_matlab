# Copyright 2025 The MathWorks, Inc.
ARG BASE_IMAGE=matlab_ci:r2024b_oct25

FROM ${BASE_IMAGE}

RUN export DEBIAN_FRONTEND=noninteractive \
    && sudo apt-get update \
    && sudo apt-get install --no-install-recommends --yes \
    python3 3.12 \
    python3-pip \
    git \
    curl \
    && sudo apt-get clean \
    && sudo apt-get autoremove \
    && sudo rm -rf /var/lib/apt/lists/*

RUN sudo python3 -m pip install --break-system-packages /opt/matlab/R2024b/extern/engines/python    
COPY licenses/license.dat /opt/matlab/R2024b/licenses/
COPY checkpoint/matlabSessionInit.m matlabSessionInit.m
COPY checkpoint/py-matlab.py py-matlab.py
COPY checkpoint/py-matlab py-matlab
RUN  sudo chmod +x /home/matlab/py-matlab
ENV PATH="/home/matlab:${PATH}"

ENTRYPOINT []