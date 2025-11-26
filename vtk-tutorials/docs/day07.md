# Day07 VTK库全自动引用案例

通过调用VTK库将立方体转为obj文件并保存

### 1、源码目录树

```C++
hello07
├── CMakeLists.txt  //工程入口
├── auto_build_linux.sh
├── build
│   └── box.obj
├── cmake
│   ├── Dependencies.cmake
│   ├── External
│   │   └── VTK.cmake
│   └── Modules
│       └── FindLocalVTK.cmake
├── src
│   └── main.cpp    //主函数
└── third_party 
    └── VTK
        ├── VTK-install
        └── VTK-prefix
```

### 2、main.cpp

通过调用VTK库将立方体转为obj文件并保存

```C++
#include <vtkNew.h>
#include <vtkCubeSource.h>
#include <vtkPolyDataMapper.h>
#include <vtkActor.h>
#include <vtkCamera.h>
#include <vtkRenderer.h>
#include <vtkRenderWindow.h>
#include <vtkOBJExporter.h>
#include <vtkRenderWindowInteractor.h>
#include <vtkNamedColors.h>

int main()
{
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
    //renWin->OffScreenRenderingOn();  //离线渲染
    renWin->AddRenderer(renderer);
    renWin->SetSize(600, 600); // 设置window大小

    // RenderWindowInteractor
    vtkNew<vtkRenderWindowInteractor> iren;
    iren->SetRenderWindow(renWin);

    // 数据交互
    renWin->Render();
    iren->Start();

    // 导出文件
    vtkSmartPointer<vtkOBJExporter> porter = vtkSmartPointer<vtkOBJExporter>::New();
    porter->SetFilePrefix("box");
    porter->SetInput(renWin);
    porter->Write();
    cin.get();
    return 0;
}
```

### 3、CMakeLists.txt

```C
CMAKE_MINIMUM_REQUIRED(VERSION 3.16)

set(CMAKE_ROOT_PATH ${CMAKE_SOURCE_DIR}/cmake)
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_ROOT_PATH}/Modules/")
set(CMAKE_EXTERNAL_PATH ${CMAKE_ROOT_PATH}/External)

set(CMAKE_CXX_STANDARD 17)
set(PROJECT_NAME "BuildVTK")

PROJECT(${PROJECT_NAME} VERSION ${PROJECT_VERSION} LANGUAGES C CXX)

# CMAKE_BUILD_TYPE
if (NOT CMAKE_BUILD_TYPE)
	set(CMAKE_BUILD_TYPE "Release" CACHE STRING
			"Choose the type of build, options are: Debug Release RelWithDebInfo MinSizeRel"
			FORCE)
endif ()
MESSAGE(STATUS "${PROJECT_NAME} CMAKE_BUILD_TYPE: ${CMAKE_BUILD_TYPE}")

# 判读在DEBUG模式下是否加入DEBUG宏
if (${CMAKE_BUILD_TYPE} STREQUAL "Debug")
	add_definitions(-DUSE_DEBUG)
else ()
	# add_definitions(-DUSE_TEST)
endif ()


add_executable(${PROJECT_NAME}
		src/main.cpp)

set(PROJECT_ROOT ${CMAKE_SOURCE_DIR})
set(THIRD_PARTY_PATH "${PROJECT_ROOT}/third_party" CACHE STRING
		"A path setting third party libraries download & build directories.")

set(PROJECT_INCLUDE_DIRS "")
set(PROJECT_LINKER_LIBS "")
set(PROJECT_LINKER_DIRS "")
set(PROJECT_EXTERNAL_DEPENDENCIES "")

include(${CMAKE_ROOT_PATH}/Dependencies.cmake)

if (PROJECT_EXTERNAL_DEPENDENCIES)
	add_dependencies(${PROJECT_NAME} ${PROJECT_EXTERNAL_DEPENDENCIES})
endif ()


include_directories(${PROJECT_NAME}
		PUBLIC
		${PROJECT_INCLUDE_DIRS}
)

target_link_libraries(${PROJECT_NAME}
		PRIVATE
		${PROJECT_LINKER_LIBS}
		)            
```

### 4、Dependencies.cmake

```C
set(CompileCPUMax_MakeCommand make -j${CPU_CORES})

# ---[ Threads
set(CMAKE_THREAD_PREFER_PTHREAD TRUE)
set(THREADS_PREFER_PTHREAD_FLAG TRUE)
find_package(Threads REQUIRED)
list(APPEND PROJECT_LINKER_LIBS ${CMAKE_THREAD_LIBS_INIT})


# ---[ VTK
set(VTK_DirName "VTK")
include(${CMAKE_EXTERNAL_PATH}/VTK.cmake)
list(APPEND PROJECT_INCLUDE_DIRS ${VTK_INCLUDE_DIRS})
list(APPEND PROJECT_LINKER_LIBS ${VTK_LIBRARIES})
```

### 5、auto_build_linux.sh

```bash
#!/bin/bash

rm -rf build 

#rm -rf third_party

mkdir build && cd build

cmake -DCMAKE_BUILD_TYPE=Release ..

make

```

### 6、VTK.cmake

```bash
if (NOT __VTK_INCLUDED)
	set(__VTK_INCLUDED TRUE)

	# VTK build directory
	set(VTK_SOURCES_DIR ${THIRD_PARTY_PATH}/${VTK_DirName}/${VTK_DirName}-sources)
	# VTK install directory
	set(VTK_INSTALL_DIR ${THIRD_PARTY_PATH}/${VTK_DirName}/${VTK_DirName}-install)

	# where to find VTK
	set(VTK_ROOT_DIR ${VTK_INSTALL_DIR})
	set(VTK_VERSION "9.4")
	set(VTK_DIR ${VTK_INSTALL_DIR})
	set(VTK_DIR ${VTK_INSTALL_DIR}/lib/cmake/vtk-${VTK_VERSION})
	find_package(LocalVTK)

	if (NOT VTK_FOUND)
		set(VTK_URL "https://geo.yuansuan.com/webgpu/VTK-9.4.1.tar.gz")
		set(USE_MPI_MODE "WANT")

		include(ExternalProject)
		ExternalProject_Add(${VTK_DirName}
				PREFIX ${VTK_SOURCES_DIR}
				URL ${VTK_URL}

				# common compiler and install settings
				CMAKE_ARGS -DCMAKE_C_FLAGS:STRING=${ARCH_CMAKE_C_FLAGS}
				CMAKE_ARGS -DCMAKE_CXX_FLAGS:STRING=${ARCH_CMAKE_C_FLAGS}
				# CMAKE_ARGS -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON
				CMAKE_ARGS -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
				CMAKE_ARGS -DCMAKE_INSTALL_PREFIX:PATH=${VTK_INSTALL_DIR}
				CMAKE_ARGS -DBUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS}

				CMAKE_ARGS -DVTK_Group_Rendering:BOOL=ON
				CMAKE_ARGS -DVTK_USE_OPENGL:BOOL=ON
				CMAKE_ARGS -DVTK_RENDERING_OPENGL2:BOOL=ON

				BUILD_COMMAND ${CompileCPUMax_MakeCommand}
				INSTALL_DIR ${VTK_INSTALL_DIR}
				${EXTERNAL_PROJECT_LOG_ARGS}
		)
		list(APPEND PROJECT_EXTERNAL_DEPENDENCIES ${VTK_DirName})
		#rerun cmake in initial build
		#will update cmakecache/project files on first build
		#so you may have to reload project after first build
		add_custom_target(Rescan ${CMAKE_COMMAND} ${CMAKE_SOURCE_DIR} DEPENDS  ${VTK_DirName})
		list(APPEND PROJECT_EXTERNAL_DEPENDENCIES Rescan)
	else()
		#Rescan becomes a dummy target after first build
		#this prevents cmake from rebuilding cache/projects on subsequent builds
		add_custom_target(Rescan)
	endif()
endif ()
```

### 7、FindLocalVTK.cmake

```bash

# - Find VTK
# Find the VTK includes and library
# VTK_ROOT_DIR - ROOT of VTK library
# VTK_INCLUDE_DIRS - where to find VTK.h.
# VTK_LIBRARIES - List of libraries when using VTK.
# VTK_FOUND - True if VTK found.

find_path(VTK_INCLUDE_DIRS_LOCAL
        NAMES vtkActor.h
        HINTS ${VTK_ROOT_DIR}/include/vtk-${VTK_VERSION})

find_library(VTK_LIBRARIES_LOCAL
        NAMES vtkCommonMath-${VTK_VERSION}
        HINTS ${VTK_ROOT_DIR}/lib)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(${VTK_DirName} DEFAULT_MSG VTK_LIBRARIES_LOCAL VTK_INCLUDE_DIRS_LOCAL)

if (VTK_FOUND)
    find_package(VTK NO_MODULE)
    #message(STATUS "VTK_LIBRARIES: ${VTK_LIBRARIES}")

    vtk_module_autoinit(
            TARGETS ${PROJECT_NAME}
            MODULES ${VTK_LIBRARIES}
    )

    mark_as_advanced(VTK_LIBRARIES VTK_INCLUDE_DIRS)
ENDIF ()
```


### 8、编译、运行、测试服务

```bash
./auto_build_linux.sh 即可
```