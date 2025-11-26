#!/bin/bash

# 使用sudo ./vtk_auto_install.sh 安装vtk

export DEBIAN_FRONTEND=noninteractive
sudo apt update
sudo apt install wget wget unzip  -y
sudo apt install build-essential cmake cmake-curses-gui mesa-common-dev mesa-utils freeglut3-dev ninja-build -y
# 安装openGL相关
sudo apt-get install build-essential libgl1-mesa-dev -y
sudo apt-get install libglew-dev libsdl2-dev libsdl2-image-dev libglm-dev libfreetype6-dev -y
sudo apt-get install libglfw3-dev libglfw3 -y
sudo apt-get install libgl1-mesa-dev -y
sudo apt-get install libglu1-mesa-dev -y
sudo apt-get install freeglut3-dev -y
sudo apt install libosmesa6-dev -y

#fix *** No rule to make target '/usr/local/lib/libOSMesa.so.8', needed by 'bin/vtkProbeOpenGLVersion'.  Stop.
#ln -s /usr/lib64/libOSMesa.so.8.0.0 /lib64/libOSMesa.so
# ldconfig -p | grep libOSMesa.so.8
# ln -s /usr/lib64/libOSMesa.so.8.0.0 /lib64/libOSMesa.so

wget http://10.0.1.66:4000/devtools/src/VTK-8.2.0.tar.gz
tar zxvf VTK-8.2.0.tar.gz
cd VTK-8.2.0
mkdir build_linux
cd build_linux || true
cmake -DBUILD_SHARED_LIBS:BOOL=FALSE \
      -DVTK_USE_X:BOOL=FALSE \
      -DOSMESA_INCLUDE_DIR:PATH=/usr/include \
			-DOSMESA_LIBRARY=/lib/x86_64-linux-gnu/libOSMesa.so.8 \
      -DVTK_OPENGL_HAS_OSMESA:BOOL=TRUE \
      -DVTK_DEFAULT_RENDER_WINDOW_OFFSCREEN:BOOL=TRUE \
      -DCMAKE_INSTALL_PREFIX=/opt/thirdpart/vtk \
      -DVTK_FORBID_DOWNLOADS:BOOL=TRUE \
      -DVTK_MODULE_ENABLE_VTK_hdf5:STRING="NO" \
      -DBUILD_TYPE=Release .. 
sudo cmake --build . --target install --parallel 8
echo "VTK-8.2.0 INSTALL SUCCESS"