FROM nvidia/opengl:base-ubuntu22.04
ENV DEBIAN_FRONTEND=noninteractive LANG=C.UTF-8

# 1) Enable universe repository
RUN apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository universe && \
    rm -rf /var/lib/apt/lists/*

# 2) Setup ROS 2 apt source via ros2-apt-source
RUN apt-get update && \
    apt-get install -y curl ca-certificates && \
    export ROS_APT_SOURCE_VERSION=$(curl -s https://api.github.com/repos/ros-infrastructure/ros-apt-source/releases/latest | grep -F "tag_name" | awk -F\" '{print $4}') && \
    curl -L -o /tmp/ros2-apt-source.deb "https://github.com/ros-infrastructure/ros-apt-source/releases/download/${ROS_APT_SOURCE_VERSION}/ros2-apt-source_${ROS_APT_SOURCE_VERSION}.$(. /etc/os-release && echo ${UBUNTU_CODENAME:-${VERSION_CODENAME}})_all.deb" && \
    dpkg -i /tmp/ros2-apt-source.deb && \
    rm -rf /var/lib/apt/lists/* /tmp/ros2-apt-source.deb

# 3) Install colcon, vcstool, and other base tools
RUN apt-get update && \
    apt-get install -y \
      python3-pip \
      python3-colcon-common-extensions \
      python3-vcstool \
      git \
      x11-apps && \
    rm -rf /var/lib/apt/lists/*

# 4) Install ROS 2 Desktop (RViz + Gazebo)
RUN apt-get update && \
    apt-get install -y \
      ros-humble-desktop \
      ros-humble-gazebo-ros-pkgs \
      ros-humble-ros-gz-sim \
      ros-humble-ros-gz-bridge && \
    rm -rf /var/lib/apt/lists/*

# 5) Initialize rosdep
RUN pip3 install -U rosdep && \
    rosdep init && \
    rosdep update

# 6) Source ROS 2 on container startup
RUN echo "source /opt/ros/humble/setup.bash" >> /root/.bashrc

CMD ["/bin/bash"]
