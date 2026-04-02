FROM barracuda-camera-image:latest

ENV DEBIAN_FRONTEND=noninteractive
ENV ROS_DISTRO=humble
ENV HOME=/home/ros

# Create non-root user with matching host UID/GID
ARG HOST_UID=1000
ARG HOST_GID=1000
RUN set -eux; \
    if ! getent group "${HOST_GID}" >/dev/null; then \
        groupadd -g "${HOST_GID}" ros; \
    fi; \
    if ! getent passwd "${HOST_UID}" >/dev/null; then \
        useradd -m -u "${HOST_UID}" -g "${HOST_GID}" -s /bin/bash ros; \
    fi; \
    mkdir -p "${HOME}"

WORKDIR /ros2_ws

COPY barracuda_camera /ros2_ws/src/barracuda_camera
# COPY zed-ros2-wrapper /ros2_ws/src/zed-ros2-wrapper

COPY docker/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# RUN apt-get update \
#     && apt-get install -y --no-install-recommends curl software-properties-common gnupg2 lsb-release \
#     && curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg \
#     && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/ros2.list > /dev/null \
#     && apt-get update \
#     && apt-get install -y --no-install-recommends \
#     ros-humble-ros-base \
#     ros-dev-tools \
#     python3-rosdep \
#     python3-pip \
#     python3-colcon-common-extensions \
#     git vim wget zstd \
#     && rm -rf /var/lib/apt/lists/* \
#     && rosdep init

# RUN apt-get update \
#     && rosdep update --rosdistro humble \
#     && rosdep install --from-paths src --ignore-src -y --rosdistro $ROS_DISTRO \
#     && rm -rf /var/lib/apt/lists/*

RUN /bin/bash -c "source /opt/ros/humble/setup.bash && colcon build --symlink-install --packages-ignore zed_debug"

RUN chown -R ${HOST_UID}:${HOST_GID} /ros2_ws "${HOME}" && \
    touch "${HOME}/.bashrc" && \
    echo "source /opt/ros/humble/setup.bash" >> "${HOME}/.bashrc" && \
    echo "source /ros2_ws/install/setup.bash" >> "${HOME}/.bashrc" && \
    sed -i '1iforce_color_prompt=yes' "${HOME}/.bashrc"

ENTRYPOINT ["/entrypoint.sh"]

CMD ["bash"]
