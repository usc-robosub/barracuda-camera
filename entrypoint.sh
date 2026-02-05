#!/usr/bin/bash
source /opt/ros/humble/setup.bash

# Source ros2_ws
source /opt/barracuda-camera/ros2_ws/install/local_setup.bash

# Start camera node
ros2 launch zed_wrapper zed_camera.launch.py camera_model:=zedm
