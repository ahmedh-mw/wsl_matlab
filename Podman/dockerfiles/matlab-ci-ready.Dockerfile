# Copyright 2025 The MathWorks, Inc.
ARG BASE_IMAGE=matlab_ci:r2024b_oct25

FROM ${BASE_IMAGE}

COPY imagefiles/ .
RUN sudo chmod +x /home/matlab/matlab-bs*
ENV PATH="/home/matlab:${PATH}"

ENTRYPOINT []