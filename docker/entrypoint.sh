#!/bin/bash
set -e

source /opt/ros/humble/setup.bash

# echo "Building ros2 workspace..."
# cd /ros2_ws
# colcon build --symlink-install

source /ros2_ws/install/setup.bash

echo "=========================================="
echo " Barracuda Camera Workspace Ready! "
echo "=========================================="

if [ -z "${NO_LAUNCH}" ]; then
    exec ros2 launch barracuda_camera camera.launch.py
else
    exec "$@"
fi
