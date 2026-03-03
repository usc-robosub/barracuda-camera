#!/bin/bash
set -e

source /opt/ros/humble/setup.bash

echo "Building ros2 workspace..."
cd /ros2_ws
colcon build --symlink-install

source /ros2_ws/install/setup.bash

echo "=========================================="
echo " Barracuda Camera Workspace Ready! "
echo "=========================================="

exec "$@"
