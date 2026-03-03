#!/bin/bash
set -e

source /opt/ros/humble/setup.bash
source install/setup.bash

echo "=========================================="
echo " Barracuda Camera Workspace Ready! "
echo "=========================================="

exec "$@"