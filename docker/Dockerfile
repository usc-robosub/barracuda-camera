FROM stereolabs/zed:5.2-devel-jetson-jp6.1.0

WORKDIR /ros2_ws

# COPY barracuda_control /ros2_ws/src/barracuda_control
COPY zed-ros2-wrapper /ros2_ws/src/zed-ros2-wrapper

COPY docker/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

RUN sudo apt-get update \
    && sudo apt-get install -y --no-install-recommends curl \
    # Install ROS
    && export ROS_APT_SOURCE_VERSION=$(curl -s https://api.github.com/repos/ros-infrastructure/ros-apt-source/releases/latest | grep -F "tag_name" | awk -F\" '{print $4}') \
    && curl -L -o /tmp/ros2-apt-source.deb "https://github.com/ros-infrastructure/ros-apt-source/releases/download/${ROS_APT_SOURCE_VERSION}/ros2-apt-source_${ROS_APT_SOURCE_VERSION}.$(. /etc/os-release && echo ${UBUNTU_CODENAME:-${VERSION_CODENAME}})_all.deb" \
    && sudo dpkg -i /tmp/ros2-apt-source.deb \
    # Install dependencies for building ROS packages
    && sudo apt-get install -y --no-install-recommends git vim wget zstd \
    && rm -rf /var/lib/apt/lists/* \
    && rosdep init

RUN rosdep update && \
    apt-get update && \
    apt-get install -y python3-pip && \
    rosdep install --from-paths src --ignore-src -y

RUN /bin/bash -c "source /opt/ros/humble/setup.bash && colcon build --symlink-install"

RUN echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc && \
    echo "source /ros2_ws/install/setup.bash" >> ~/.bashrc \
    && sed -i '1iforce_color_prompt=yes' ~/.bashrc

ENTRYPOINT ["/entrypoint.sh"]

CMD ["bash"]