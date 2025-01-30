FROM ros:noetic-ros-base-focal

RUN sudo apt-get update \
    # Install dependencies for building ROS packages
    && sudo apt-get install -y --no-install-recommends git vim wget zstd \
        ros-noetic-robot-state-publisher \
        ros-noetic-tf2-ros \
        ros-noetic-tf2-geometry-msgs \
        ros-noetic-image-transport \
        ros-noetic-diagnostic-updater \
        ros-noetic-xacro \
        ros-noetic-urdf \
        ros-noetic-image-transport-plugins \
    # Install ZED SDK 4.2
    && if [ $(uname -m) = "x86_64" ]; then \
            wget -qO ZED_SDK.zstd.run https://download.stereolabs.com/zedsdk/4.2/cu12/ubuntu20; \
        else \
            # Jetson needs to use a different ZED SDK version
            # This may need to be changed based on the Jetpack version
            wget -qO ZED_SDK.zstd.run https://download.stereolabs.com/zedsdk/4.2/l4t35.4/jetsons; \
        fi \
    && chmod +x ZED_SDK.zstd.run \
    # Skip checking for CUDA because CUDA libraries are mounted to the container
    && ./ZED_SDK.zstd.run -- silent runtime_only skip_cuda \
    && rm ZED_SDK.zstd.run \
    && rm -rf /var/lib/apt/lists/*

COPY . /opt/barracuda-camera

# Set working directory
WORKDIR /opt

# Source the workspace on container start
CMD ["/bin/bash", "/opt/barracuda-camera/entrypoint.sh"]
