FROM nvidia/opengl:base-ubuntu22.04
ENV DEBIAN_FRONTEND=noninteractive LANG=C.UTF-8

# 1) Enable universe repository
RUN apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository universe && \
    rm -rf /var/lib/apt/lists/*

# 2) Add ROS 2 apt repo
RUN apt-get update && \
    apt-get install -y curl gnupg2 lsb-release && \
    curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key \
      -o /usr/share/keyrings/ros-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] \
      http://packages.ros.org/ros2/ubuntu $(lsb_release -sc) main" \
      > /etc/apt/sources.list.d/ros2.list && \
    rm -rf /var/lib/apt/lists/*

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
      ros-humble-gazebo-ros-pkgs && \
    rm -rf /var/lib/apt/lists/*

# 5) Initialize rosdep
RUN pip3 install -U rosdep && \
    rosdep init && \
    rosdep update

# 6) Source ROS 2 on container startup
RUN echo "source /opt/ros/humble/setup.bash" >> /root/.bashrc

CMD ["/bin/bash"]
