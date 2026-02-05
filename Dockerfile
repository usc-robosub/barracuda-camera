FROM stereolabs/zed:5.1-runtime-jetson-jp6.1.0

RUN sudo apt-get update \
    && sudo apt-get install -y --no-install-recommends curl \
    # Install ROS
    && export ROS_APT_SOURCE_VERSION=$(curl -s https://api.github.com/repos/ros-infrastructure/ros-apt-source/releases/latest | grep -F "tag_name" | awk -F\" '{print $4}') \
    && curl -L -o /tmp/ros2-apt-source.deb "https://github.com/ros-infrastructure/ros-apt-source/releases/download/${ROS_APT_SOURCE_VERSION}/ros2-apt-source_${ROS_APT_SOURCE_VERSION}.$(. /etc/os-release && echo ${UBUNTU_CODENAME:-${VERSION_CODENAME}})_all.deb" \
    && sudo dpkg -i /tmp/ros2-apt-source.deb \
    # Install dependencies for building ROS packages
    && sudo apt-get install -y --no-install-recommends git vim wget zstd \
    && rm -rf /var/lib/apt/lists/*

COPY . /opt/barracuda-camera

# Set working directory
WORKDIR /opt

# Build ROS packages
RUN . /opt/ros/humble/setup.sh \
    && cd /opt/barracuda-camera/ros2_ws \
    && sudo apt update \
    && sudo rosdep init \
    && rosdep update \
    && rosdep install --from-paths src --ignore-src -r -y \
    && colcon build --symlink-install --cmake-args=-DCMAKE_BUILD_TYPE=Release \
    && rm -rf /var/lib/apt/lists/*

# Source the workspace on container start
CMD ["/bin/bash", "/opt/barracuda-camera/entrypoint.sh"]
