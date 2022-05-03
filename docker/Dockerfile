FROM osrf/ros:noetic-desktop-full

ENV CATKIN_WS=/root/catkin_ws

RUN	apt-get update && apt-get install -y \
	build-essential \
	git \
	libgtk2.0-dev \
	pkg-config \
	libavcodec-dev \
	libavformat-dev \
	libswscale-dev \
	python-dev \
	python-numpy \
	python3-dev \ 
	python3-numpy \
	libtbb2 \
	libtbb-dev \
	libjpeg-dev \
	libpng-dev \
	libtiff-dev \
	libdc1394-22-dev \
	cmake \
	python3-catkin-tools \
	ros-noetic-cv-bridge \
	ros-noetic-image-transport \
	ros-noetic-message-filters \
	nano \
	libgflags-dev \
	libgoogle-glog-dev \
	libatlas-base-dev \
	libeigen3-dev \
	libsuitesparse-dev \
	wget \
	unzip && \
	rm -rf /var/lib/apt/lists/* 

RUN	mkdir -p /opencv_source/ && \
	cd /opencv_source/ && \
	wget -O opencv.zip https://github.com/opencv/opencv/archive/4.2.0.zip && \
	wget -O opencv_contrib.zip https://github.com/opencv/opencv_contrib/archive/4.2.0.zip && \
	unzip opencv.zip && \
	unzip opencv_contrib.zip && \
	ls
RUN	mkdir -p /build && \
	cd /build && \
	cmake -D CMAKE_BUILD_TYPE=RELEASE \
	    -D INSTALL_C_EXAMPLES=OFF \
	    -D INSTALL_PYTHON_EXAMPLES=OFF \
	    -D OPENCV_GENERATE_PKGCONFIG=ON \
	    -D OPENCV_EXTRA_MODULES_PATH="/opencv_source/opencv_contrib-4.2.0/modules" \
	    -D BUILD_EXAMPLES=OFF \
	    -D OPENCV_ENABLE_NONFREE=ON \
	    -D WITH_IPP=OFF \
	    -D -DBUILD_TESTS=OFF \
	    -D BUILD_PERF_TESTS=OFF \
		-D BUILD_opencv_adas=OFF \
		-D BUILD_opencv_bgsegm=OFF \
		-D BUILD_opencv_bioinspired=OFF \
		-D BUILD_opencv_ccalib=OFF \
		-D BUILD_opencv_datasets=ON \
		-D BUILD_opencv_datasettools=OFF \
		-D BUILD_opencv_face=OFF \
		-D BUILD_opencv_latentsvm=OFF \
		-D BUILD_opencv_line_descriptor=OFF \
		-D BUILD_opencv_matlab=OFF \
		-D BUILD_opencv_optflow=ON \
		-D BUILD_opencv_reg=OFF \
		-D BUILD_opencv_saliency=OFF \
		-D BUILD_opencv_surface_matching=OFF \
		-D BUILD_opencv_text=OFF \
		-D BUILD_opencv_tracking=ON \
		-D BUILD_opencv_xobjdetect=OFF \
		-D BUILD_opencv_xphoto=OFF \
		-D BUILD_opencv_stereo=OFF \
		-D BUILD_opencv_hdf=OFF \
		-D BUILD_opencv_cvv=OFF \
		-D BUILD_opencv_fuzzy=OFF \
		-D BUILD_opencv_dnn=OFF \
		-D BUILD_opencv_dnn_objdetect=OFF \
		-D BUILD_opencv_dnn_superres=OFF \
		-D BUILD_opencv_dpm=OFF \
		-D BUILD_opencv_quality=OFF \
		-D BUILD_opencv_rapid=OFF \
		-D BUILD_opencv_rgbd=OFF \
		-D BUILD_opencv_sfm=OFF \
		-D BUILD_opencv_shape=ON \
		-D BUILD_opencv_stitching=OFF \
		-D BUILD_opencv_structured_light=OFF \
		-D BUILD_opencv_alphamat=OFF \
		-D BUILD_opencv_aruco=OFF \
		-D BUILD_opencv_phase_unwrapping=OFF \
		-D BUILD_opencv_photo=OFF \
		-D BUILD_opencv_gapi=OFF \
		-D BUILD_opencv_video=ON \
		-D BUILD_opencv_ml=ONN \
		-D BUILD_opencv_python2=OFF \
		-D WITH_GSTREAMER=OFF \
		-DENABLE_PRECOMPILED_HEADERS=OFF \
	    	/opencv_source/opencv-4.2.0 && \
	    	make -j8 && \
	    	make install && \
	    	rm -r /opencv_source/
	    	
RUN 	mkdir -p /opengv_source/ && \
	cd /opengv_source/ && \
	git clone https://github.com/laurentkneip/opengv && \
	ls && \
	cd opengv/ && \
	mkdir -p build && \
	cd build && \
	cmake .. && \
	make -j8 && \
	make install && \
	rm -r /opengv_source/
	
COPY	./ $CATKIN_WS/src/ov2slam/

WORKDIR $CATKIN_WS/src/ov2slam

RUN sh ./build_thirdparty.sh

RUN rm -r $CATKIN_WS/src/ov2slam/parameters_files/

WORKDIR $CATKIN_WS
ENV TERM xterm
ENV PYTHONIOENCODING UTF-8
RUN catkin config \
      --extend /opt/ros/$ROS_DISTRO \
      --cmake-args \
        -DCMAKE_BUILD_TYPE=Release && \
    catkin build && \
    sed -i '/exec "$@"/i \
           source "/root/catkin_ws/devel/setup.bash"' /ros_entrypoint.sh


      # set up thread number for building
#RUN   if [ "x$(nproc)" = "x1" ] ; then export USE_PROC=1 ; \
#      else export USE_PROC=$(($(nproc)/2)) ; fi && \
##      apt-get update && apt-get install -y \
 #    cmake \
  #    libatlas-base-dev \
   #   libeigen3-dev \
   #   libgoogle-glog-dev \
   ##   libsuitesparse-dev \
    #  python-catkin-tools \
    #  ros-${ROS_DISTRO}-cv-bridge \
    #  ros-${ROS_DISTRO}-image-transport \
    #  ros-${ROS_DISTRO}-message-filters \
    ### rm -rf /var/lib/apt/lists/* && \
      ## Build and install Ceres
      #git clone https://ceres-solver.googlesource.com/ceres-solver && \
      ##git checkout tags/${CERES_VERSION} && \
     # mkdir build && cd build && \
     # c#make .. && \
    #  make -j$(USE_PROC) install && \
   #   rm -rf ../../ceres-solver && \
  #    mkdir -p $CATKIN_WS/src/VINS-Fusion/

# Copy VINS-Fusion
#COPY ./ $CATKIN_WS/src/VINS-Fusion/
# use the following line if you only have this dockerfile
# RUN git clone https://github.com/HKUST-Aerial-Robotics/VINS-Fusion.git

# Build VINS-Fusion
#WORKDIR $CATKIN_WS
#ENV TERM xterm
#ENV PYTHONIOENCODING UTF-8
#RUN catkin config \
#      --extend /opt/ros/$ROS_DISTRO \
#      --cmake-args \
#        -DCMAKE_BUILD_TYPE=Release && \
#    catkin build && \
#    sed -i '/exec "$@"/i \
#           source "/root/catkin_ws/devel/setup.bash"' /ros_entrypoint.sh
