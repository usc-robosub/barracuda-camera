FROM ros:noetic-ros-base-focal

RUN sudo apt-get update \
    && sudo apt-get install -y wget zstd \
    && export ARCH=$(uname -m | sed "s/aarch64/arm64/g"); wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/${ARCH}/cuda-keyring_1.1-1_all.deb \
    && sudo dpkg -i cuda-keyring_1.1-1_all.deb \
    && sudo apt-get update \
    && sudo apt-get install -y --no-install-recommends nvidia-cuda-toolkit \
    && wget -qO ZED_SDK.zstd.run https://download.stereolabs.com/zedsdk/4.2/cu12/ubuntu20 \
    && chmod +x ZED_SDK.zstd.run \
    && ./ZED_SDK.zstd.run -- silent skip_cuda runtime_only \
    && rm -rf /var/lib/apt/lists/*

COPY . /opt/barracuda-camera

# Set working directory
WORKDIR /opt

# Source the workspace on container start
CMD ["/bin/bash", "/opt/barracuda-camera/entrypoint.sh"]
