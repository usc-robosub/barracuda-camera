FROM stereolabs/zed:4.2-runtime-jetson-jp5.1.2 

RUN sudo apt-get update \
    && sudo apt-get install -y --no-install-recommends curl \
    # Install ROS
    && echo "deb http://packages.ros.org/ros/ubuntu focal main" > /etc/apt/sources.list.d/ros1-latest.list \
    && curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add - \
    && sudo apt update \
    && sudo apt-get install -y --no-install-recommends ros-noetic-ros-base \
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
    && rm -rf /var/lib/apt/lists/*

COPY . /opt/barracuda-camera

# Set working directory
WORKDIR /opt

# Source the workspace on container start
CMD ["/bin/bash", "/opt/barracuda-camera/entrypoint.sh"]
