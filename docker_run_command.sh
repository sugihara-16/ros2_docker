#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# Script to launch the ROS2 Humble Docker container with GPU and X11 GUI support
# -----------------------------------------------------------------------------

# Exit on any error
set -e

# 1) Allow root in container to connect to the host X server
xhost +local:root

# 2) Launch the container
docker run -it --rm \
  --gpus all \
  -e DISPLAY=$DISPLAY \
  -e XAUTHORITY=/root/.Xauthority \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v $HOME/.Xauthority:/root/.Xauthority:ro \
  -v $HOME/ros2:/ros2 \
  --network host \
  ros2_humble:latest "$@"
