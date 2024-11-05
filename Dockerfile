FROM ros:noetic-ros-base-focal

RUN sudo apt-get update \
    && sudo apt-get install -y git vim wget zstd \
    && export ARCH=$(uname -m | sed "s/aarch64/arm64/g"); wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/${ARCH}/cuda-keyring_1.1-1_all.deb \
    && sudo dpkg -i cuda-keyring_1.1-1_all.deb \
    && sudo apt-get update \
    && sudo apt-get install --no-install-recommends -y cuda-toolkit-12-1 \
    && wget -qO ZED_SDK.zstd.run https://download.stereolabs.com/zedsdk/4.2/cu12/ubuntu20 \
    && chmod +x ZED_SDK.zstd.run \
    && ./ZED_SDK.zstd.run -- silent skip_cuda \
    && rm ZED_SDK.zstd.run \
    && rm -rf /var/lib/apt/lists/*

COPY . /opt/barracuda-camera

RUN sudo apt-get update \
    && sudo apt-get update \
    && cd /opt/barracuda-camera/catkin_ws \
    && rosdep install --from-paths src --ignore-src -r -y \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /opt

# Source the workspace on container start
CMD ["/bin/bash", "/opt/barracuda-camera/entrypoint.sh"]
