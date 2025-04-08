# Use ubuntu22.04 as base image
FROM ubuntu:22.04

# Disenable dialogic process
ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8

# install repository managers
RUN apt-get update && apt-get install -y \
    software-properties-common && \
    rm -rf /var/lib/apt/lists/*

# enable universe repository
RUN add-apt-repository universe

# install curl, gnupg2, lsb-release
RUN apt-get update && apt-get install -y \
    curl \
    gnupg2 \
    lsb-release && \
    rm -rf /var/lib/apt/lists/*

# install python3-pip
RUN apt-get update && apt-get install -y python3-pip && \
    rm -rf /var/lib/apt/lists/* && \
    pip3 install -U rosdep

# get the key for apt repository for ros2
RUN curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key \
    -o /usr/share/keyrings/ros-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(lsb_release -sc) main" \
    > /etc/apt/sources.list.d/ros2.list

# install ROS2
RUN apt-get update && apt-get upgrade -y && \
    apt-get update && apt-get install -y ros-humble-desktop

# install colcon
RUN apt-get update && apt-get install -y python3-colcon-common-extensions && \
    rm -rf /var/lib/apt/lists/

# load setup.bash
RUN echo "source /opt/ros/humble/setup.bash" >> /root/.bashrc

# initialize rosdep
RUN rosdep init && rosdep update

CMD ["/bin/bash"]
