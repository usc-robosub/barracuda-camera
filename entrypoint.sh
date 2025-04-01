#!/usr/bin/bash
source /opt/ros/noetic/setup.bash

# Source catkin_ws
cd barracuda-camera/catkin_ws
source devel/setup.bash

# Source ros and catkin_ws in bashrc
echo "source /opt/ros/noetic/setup.bash" >> ~/.bashrc
echo "source /opt/barracuda-description/catkin_ws/devel/setup.bash" >> ~/.bashrc

# Start camera node
roslaunch barracuda_camera barracuda_camera.launch
