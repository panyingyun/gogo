# Day06 如何用CMake打包自己的Lib库案例

演示如何想专业软件一样打包，并提供Findmmathcc.cmake自动查找库的方式

### 1、目录树

```bash
mmathcc/
├── README.md
├── example
│   ├── CMakeLists.txt
│   ├── auto_build_linux.sh
│   ├── cmake
│   │   └── modules
│   │       └── Findmmathcc.cmake
│   ├── example.cpp
│   ├── mathtest
│   └── thirdpart
│       └── mmathcc
│           ├── include
│           └── lib
└── mmathcclib
    ├── CMakeLists.txt
    ├── Config.cmake.in
    ├── auto_build_linux.sh
    ├── mmathcc.cpp
    └── mmathcc.h
```

### 2、example.cpp

```bash
// example.cpp

#include <iostream>
#include "mmathcc.h"

int main()
{
    double a = 100;
    int b = 2;
    using MMathCC::Arithmetic;
    std::cout << "a + b = " << Arithmetic::Add(a, b) << std::endl;
    std::cout << "a - b = " << Arithmetic::Subtract(a, b) << std::endl;
    std::cout << "a * b = " << Arithmetic::Multiply(a, b) << std::endl;
    std::cout << "a / b = " << Arithmetic::Divide(a, b) << std::endl;

    return 0;
}
```

### 3、CMakeLists.txt

```bash
cmake_minimum_required(VERSION 3.11)
project(mathtest VERSION 2.76 LANGUAGES CXX)

set(CMAKE_ROOT_PATH ${CMAKE_SOURCE_DIR}/cmake)
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_CURRENT_SOURCE_DIR}/cmake/modules")

set(MMATHCC_ROOT_DIR ./thirdpart/mmathcc)

set(EXECUTABLE_OUTPUT_PATH  ${PROJECT_SOURCE_DIR})

find_package(mmathcc)
message(status "MMATHCC_FOUND = " ${MMATHCC_FOUND})
message(status "MMATHCC_INCLUDE_DIR = ${MMATHCC_INCLUDE_DIR}")
message(status "MMATHCC_LIBRARIES = ${MMATHCC_LIBRARIES}")


add_executable(${PROJECT_NAME})

list(APPEND SOURCES ${PROJECT_SOURCE_DIR}/example.cpp)
list(APPEND THIRDPARTY_LIBS ${MMATHCC_LIBRARIES})

target_sources(${PROJECT_NAME} 
            PRIVATE ${SOURCES}
            )
target_include_directories(${PROJECT_NAME} 
            PRIVATE  ${MMATHCC_INCLUDE_DIR}
            )
target_link_libraries(${PROJECT_NAME} 
            PRIVATE ${THIRDPARTY_LIBS}
            )
```

### 4、Findmmathcc.cmake

```bash
# - Find mmathc
# Find the mmathc includes and library
# MMATHCC_ROOT_DIR - ROOT of mmathc library
# MMATHCC_INCLUDE_DIR - where to find mmathc.h.
# MMATHCC_LIBRARIES - List of libraries when using mmathc.
# MMATHCC_FOUND - True if mmathc found.

find_path(MMATHCC_INCLUDE_DIR
  NAMES mmathcc.h
  HINTS ${MMATHCC_ROOT_DIR}/include)

find_library(MMATHCC_LIBRARIES
  NAMES mmathcc
  HINTS ${MMATHCC_ROOT_DIR}/lib)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(mmathcc DEFAULT_MSG MMATHCC_LIBRARIES MMATHCC_INCLUDE_DIR)

mark_as_advanced(
  MMATHCC_LIBRARIES
  MMATHCC_INCLUDE_DIR)

if(MMATHCC_FOUND AND NOT (TARGET mmathcc::mmathcc))
  add_library(mmathcc::mmathcc UNKNOWN IMPORTED)
  set_target_properties(mmathcc::mmathcc
    PROPERTIES
    IMPORTED_LOCATION "${MMATHCC_LIBRARIES}"
    INTERFACE_INCLUDE_DIRECTORIES "${MMATHCC_INCLUDE_DIRS}"
    )
endif()
```

### 5、编译库 example的auto_build_linux.sh

```bash
#!/bin/bash

rm -rf build 

cmake -S . -B build

cmake --build . --parallel 8
```

### 6、mmathcc.cpp && mmathcc.h

```bash
// =========mmathcc.h==============
#pragma once

namespace MMathCC
{
    class Arithmetic
    {
    public:
        // Returns a + b
        static double Add(double a, double b);

        // Returns a - b
        static double Subtract(double a, double b);

        // Returns a * b
        static double Multiply(double a, double b);

        // Returns a / b
        static double Divide(double a, double b);
    };
}

// =========mmathcc.cpp==============
#include "mmathcc.h"

namespace MMathCC
{
    double Arithmetic::Add(double a, double b)
    {
        return a + b;
    }

    double Arithmetic::Subtract(double a, double b)
    {
        return a - b;
    }

    double Arithmetic::Multiply(double a, double b)
    {
        return a * b;
    }

    double Arithmetic::Divide(double a, double b)
    {
        return a / b;
    }
}
```

### 7、Config.cmake.in
```bash
@PACKAGE_INIT@

include("${CMAKE_CURRENT_LIST_DIR}/@PROJECT_NAMESPACE_NAME@Targets.cmake")
```

### 8、编译库mmathcc的auto_build_linux.sh

```bash
#!/bin/bash

rm -rf build 

cmake -S . -B build

cd build

cmake --build . 

cmake --install . --prefix ../../example/thirdpart/mmathcc
```

### 9、编译自定义库

```bash
cd mmathcclib
sh auto_build_linux.sh
```

### 10、编译、运行、测试Example

```bash
cd example
sh auto_build_linux.sh

$ ./mathtest
a + b = 102
a - b = 98
a * b = 200
a / b = 50
```

### FAQ: make: warning:  Clock skew detected.  Your build may be incomplete.

```bash
由于文件拷贝的时间戳问题，统一touch修改时间戳即可
find ./ -type f | xargs touch
```

### FAQ: sh auto_build_linux.sh (example的) 报错 Error: could not load cache
可能是因为缓存文件的权限不足，可以使用ls -l 查看权限：
```bash
ls -ls CMakeCache.txt
```

如果权限不足，可赋予其相应的读权限：
```bash
cd build
chmod +r CMakeCache.txt
再执行
cmake --build . --parallel 8
```

### FAQ: 有哪些参考的cmake

- https://github.com/PaddlePaddle/Paddle/blob/develop/cmake/external/glog.cmake

### FAQ: Glog

- https://www.cnblogs.com/LyndonYoung/articles/8000265.html

### WSL命令

查看本地镜像
wsl --list -v

查看在线镜像
wsl --list --online

安装镜像
wsl --install Ubuntu-20.04

设置版本
wsl --set-version Ubuntu-20.04 2
