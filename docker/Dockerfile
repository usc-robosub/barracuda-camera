FROM stereolabs/zed:5.2-devel-jetson-jp6.1.0

ENV DEBIAN_FRONTEND=noninteractive
ENV ROS_DISTRO=humble

WORKDIR /ros2_ws

# COPY barracuda_control /ros2_ws/src/barracuda_control
COPY zed-ros2-wrapper /ros2_ws/src/zed-ros2-wrapper

COPY docker/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

RUN apt-get update \
    && apt-get install -y --no-install-recommends curl software-properties-common gnupg2 lsb-release \
    && curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/ros2.list > /dev/null \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
    ros-humble-ros-base \
    ros-dev-tools \
    python3-rosdep \
    python3-pip \
    python3-colcon-common-extensions \
    git vim wget zstd \
    && rm -rf /var/lib/apt/lists/* \
    && rosdep init

RUN apt-get update \
    && rosdep update --rosdistro humble \
    && rosdep install --from-paths src --ignore-src -y \
    && rm -rf /var/lib/apt/lists/*

RUN /bin/bash -c "source /opt/ros/humble/setup.bash && colcon build --symlink-install"

RUN echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc && \
    echo "source /ros2_ws/install/setup.bash" >> ~/.bashrc \
    && sed -i '1iforce_color_prompt=yes' ~/.bashrc

ENTRYPOINT ["/entrypoint.sh"]

CMD ["bash"]