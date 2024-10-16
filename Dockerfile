FROM python:3.9-slim AS build

RUN apt-get update && apt-get install -y \
    build-essential cmake git wget unzip pkg-config \
    libjpeg-dev libpng-dev libtiff-dev \
    libavcodec-dev libavformat-dev libswscale-dev \
    libv4l-dev libxvidcore-dev libx264-dev \
    libgtk2.0-dev libatlas-base-dev gfortran \
    python3-dev

WORKDIR /opencv
RUN git clone https://github.com/opencv/opencv.git && \
    git clone https://github.com/opencv/opencv_contrib.git

RUN mkdir -p opencv/build && cd opencv/build && \
    cmake -D CMAKE_BUILD_TYPE=RELEASE \
          -D CMAKE_INSTALL_PREFIX=/usr/local \
          -D OPENCV_EXTRA_MODULES_PATH=/opencv/opencv_contrib/modules \
          -D WITH_TBB=ON \
          -D WITH_V4L=ON \
          -D WITH_QT=ON \
          -D WITH_OPENGL=ON \
          -D BUILD_EXAMPLES=OFF .. && \
    make -j$(nproc) && \
    make install

FROM python:3.9-slim

RUN apt-get update && apt-get install -y \
    libsm6 libxext6 libxrender-dev libglib2.0-0 \
    && apt-get clean

COPY --from=build /usr/local /usr/local

RUN pip install numpy opencv-python-headless

COPY . /face-detection
WORKDIR /face-detection
CMD ["python", "main.py"]
