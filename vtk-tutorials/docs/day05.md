# Day05 VTK库下载，编译，引用案例

通过调用VTK库将立方体转为obj文件并保存

### 1、源码目录树

```C++
.
hello05
├── CMakeLists.txt  //工程入口
├── auto_build_linux.sh
├── build
│   ├── PostProcess
│   └── box.obj
├── cmake
│   ├── Dependencies.cmake
│   ├── External
│   │   ├── gflags.cmake
│   │   └── glog.cmake
│   └── Modules
│       ├── FindGFlags.cmake
│       ├── FindGlog.cmake
│       └── FindVTK.cmake
├── main.cpp    //主函数
├── third_party  //GFlags和Glog库
│   ├── GFlags
│   │   ├── GFlags-install
│   │   └── GFlags-prefix
│   └── Glog
│       ├── Glog-install
│       └── Glog-prefix
└── vtk                     //VTK库
    ├── VTK-8.2.0.tar.gz
    └── vtk_auto_install_ubuntu.sh
```

### 2、main.cpp

通过调用VTK库将立方体转为obj文件并保存

```C++
#include <iostream>
#include <string>
#include <glog/logging.h>
#include <gflags/gflags.h>
#include <vtkCubeSource.h>
#include <vtkPolyData.h>
#include <vtkSmartPointer.h>
#include <vtkPolyDataMapper.h>
#include <vtkActor.h>
#include <vtkCamera.h>
#include <vtkRenderWindow.h>
#include <vtkRenderer.h>
#include <vtkRenderWindowInteractor.h>
#include <vtkOBJExporter.h>

int vtk_cube()
{

  LOG(INFO) << "Create vtkCubeSource!";
  vtkNew<vtkCubeSource> cube;

  // mapper
  vtkNew<vtkPolyDataMapper> cubeMapper;
  cubeMapper->SetInputConnection(cube->GetOutputPort());

  // actor
  vtkNew<vtkActor> cubeActor;
  cubeActor->SetMapper(cubeMapper);

  // camera
  vtkNew<vtkCamera> camera;
  camera->SetPosition(1, 1, 1);   // 设置相机位置
  camera->SetFocalPoint(0, 0, 0); // 设置相机焦点

  // renderer
  vtkNew<vtkRenderer> renderer;
  renderer->AddActor(cubeActor);
  renderer->SetActiveCamera(camera);
  renderer->ResetCamera();

  // RenderWindow
  vtkNew<vtkRenderWindow> renWin;
  renWin->OffScreenRenderingOn();  //离线渲染
  renWin->AddRenderer(renderer);
  renWin->SetSize(600, 600); // 设置window大小

  // // RenderWindowInteractor
  // vtkNew<vtkRenderWindowInteractor> iren;
  // iren->SetRenderWindow(renWin);

  // 数据交互
  renWin->Render();
  // iren->Start();

  // 导出文件
  LOG(INFO) << "Create vtkOBJExporter and export Cube to obj file!";
  vtkSmartPointer<vtkOBJExporter> porter = vtkSmartPointer<vtkOBJExporter>::New();
  porter->SetFilePrefix("box");
  porter->SetInput(renWin);
  porter->Write();
  return 0;
}
```

### 3、CMakeLists.txt

```C
cmake_minimum_required(VERSION 2.8...3.28)
set(CMAKE_ROOT_PATH ${CMAKE_SOURCE_DIR}/cmake)
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_ROOT_PATH}/Modules")
set(CMAKE_EXTERNAL_PATH ${CMAKE_ROOT_PATH}/External)

PROJECT(PostProcess VERSION "0.1.0" LANGUAGES CXX)

# CMAKE_BUILD_TYPE
if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE "Release" CACHE STRING
      "Choose the type of build, options are: Debug Release RelWithDebInfo MinSizeRel"
      FORCE)
endif()
MESSAGE(STATUS "CMAKE_BUILD_TYPE: ${CMAKE_BUILD_TYPE}")

# SET THIRD_PARTY_PATH
set(PROJECT_ROOT ${CMAKE_SOURCE_DIR})
set(THIRD_PARTY_PATH "${PROJECT_ROOT}/third_party" CACHE STRING
  "A path setting third party libraries download & build directories.")

# These lists are later turned into target properties on main library target
set(PProcess_LINKER_LIBS "")
set(PProcess_INCLUDE_DIRS "")
set(External_Project_Dependencies "")

#set(EXECUTABLE_OUTPUT_PATH  ${PROJECT_SOURCE_DIR})
add_executable(${PROJECT_NAME})

# DOWLAND BUILD INSTALL THIRD_PARTY_PATH
include(${CMAKE_ROOT_PATH}/dependencies.cmake)

list(APPEND SOURCES 
    ${PROJECT_ROOT}/main.cpp
)

target_sources(${PROJECT_NAME} 
                PUBLIC ${SOURCES}
                )

include_directories(${PROJECT_NAME} 
                PUBLIC
                ${PProcess_INCLUDE_DIRS})

target_link_libraries(${PROJECT_NAME} 
                PUBLIC 
                ${PProcess_LINKER_LIBS}
                ${CMAKE_THREAD_LIBS_INIT})                
```

### 4、Dependencies.cmake

```C
set(CompileCPUMax_MakeCommand make -j8)
message(${CompileCPUMax_MakeCommand})

# ---[ Threads
find_package(Threads REQUIRED)
list(APPEND PProcess_LINKER_LIBS PUBLIC pthread)

# ---[ Google-GFlags
set(GFlags_DirName "GFlags")
include(${CMAKE_EXTERNAL_PATH}/gflags.cmake)
list(APPEND PProcess_INCLUDE_DIRS PUBLIC ${GFLAGS_INCLUDE_DIRS})
list(APPEND PProcess_LINKER_LIBS PUBLIC ${GFLAGS_LIBRARIES})

# ---[ Google-Glog
set(Glog_DirName "Glog")
include(${CMAKE_EXTERNAL_PATH}/glog.cmake)
list(APPEND PProcess_INCLUDE_DIRS PUBLIC ${GLOG_INCLUDE_DIRS})
list(APPEND PProcess_LINKER_LIBS PUBLIC ${GLOG_LIBRARIES})

# ---[VTK
set(VTK_DIR "/opt/thirdpart/vtk/lib/cmake/vtk-8.2")
find_package(VTK REQUIRED)
include(${VTK_USE_FILE})
list(APPEND PProcess_INCLUDE_DIRS ${VTK_INCLUDE_DIRS})
list(APPEND PProcess_LINKER_LIBS ${VTK_LIBRARIES})

message(STATUS "VTK_FOUND: ${VTK_FOUND}")
message(STATUS "VTK_INCLUDE_DIRS: ${VTK_INCLUDE_DIRS}")
message(STATUS "VTK_LIBRARY_DIRS: ${VTK_LIBRARY_DIRS}")
message(STATUS "VTK_LIBRARY_DIRS: ${VTK_LIBRARY_DIRS}")
message(STATUS "VTK_USE_FILE: ${VTK_USE_FILE}")
message(STATUS "VTK_LIBRARIES: ${VTK_LIBRARIES}")
```

### 5、auto_build_linux.sh

```bash
#!/bin/bash

rm -rf build 

#rm -rf third_party

mkdir build && cd build

cmake -DCMAKE_BUILD_TYPE=Release ..

cmake --build .

./PostProcess
```

### 6、下载、编译、安装VTK库

```bash
$ cd vtk 
$ chmod 755  vtk_auto_install_ubuntu.sh
$ ./vtk_auto_install_ubuntu.sh

=====================vtk_auto_install_ubuntu.sh=====================
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
```

### 7、编译、运行、测试服务

```bash
./auto_build_linux.sh 即可

二进制文件在build/PostProcess 
```