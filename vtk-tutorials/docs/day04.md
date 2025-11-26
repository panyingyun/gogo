# Day04 glog自动下载，编译，引用案例

### 1、源码目录树

```
hello04/
├── CMakeLists.txt
├── auto_build_linux_debug.sh
├── auto_build_linux_release.sh
├── cmake
│   ├── External
│   │   ├── gflags.cmake
│   │   └── glog.cmake
│   ├── Modules
│   │   ├── FindGFlags.cmake
│   │   └── FindGlog.cmake
│   └── dependencies.cmake
├── main.cpp
└── third_party
    ├── GFlags
    │   ├── GFlags-install
    │   │   ├── bin
    │   │   │   └── gflags_completions.sh
    │   │   ├── include
    │   │   │   └── gflags
    │   │   └── lib
    │   │       ├── cmake
    │   │       ├── libgflags.a
    │   │       ├── libgflags_nothreads.a
    │   │       └── pkgconfig
    │   └── GFlags-prefix
    │       ├── src
    │       │   ├── GFlags
    │       │   ├── GFlags-build
    │       │   ├── GFlags-stamp
    │       │   └── gflags-2.2.2.tar.gz
    │       └── tmp
    │           ├── GFlags-cache-Release.cmake
    │           ├── GFlags-cfgcmd.txt
    │           └── GFlags-mkdirs.cmake
    └── Glog
        ├── Glog-install
        │   ├── include
        │   │   └── glog
        │   └── lib
        │       ├── cmake
        │       ├── libglog.a
        │       └── pkgconfig
        └── Glog-prefix
            ├── src
            │   ├── Glog
            │   ├── Glog-build
            │   ├── Glog-stamp
            │   └── glog-0.6.0.tar.gz
            └── tmp
                ├── Glog-cache-Release.cmake
                ├── Glog-cfgcmd.txt
                └── Glog-mkdirs.cmake
```

### 2、main.cpp

```bash
#include <iostream>
#include <string>
#include <glog/logging.h>
#include <gflags/gflags.h>

void init_glog(char *name)
{
  FLAGS_colorlogtostderr = true;
  FLAGS_colorlogtostdout = true;

  google::InitGoogleLogging(name);
  google::SetStderrLogging(google::INFO);
  google::InstallFailureSignalHandler();
  // google::SetLogDestination(google::INFO, "log/INFO_");
  // google::SetLogFilenameExtension("logExtension");
  // google::SetLogDestination(google::GLOG_INFO, "./demo.log.info");
  // google::SetLogDestination(google::GLOG_WARNING, "./demo.log.warning");
  // google::SetLogDestination(google::GLOG_ERROR, "./demo.log.error");
  // google::SetLogDestination(google::GLOG_FATAL, "./demo.log.fatal");
}

int main(int argc, char *argv[])
{
  // test glog
  init_glog(argv[0]);
  google::ParseCommandLineFlags(&argc, &argv, true); // 初始化 gflags
  LOG(INFO) << "argv[0]= " << argv[0];
  LOG(INFO) << "This is a info log!";
  LOG(WARNING) << "This is a warning log!";
  LOG(ERROR) << "This is a error log!";

  LOG(ERROR) << "This is a error log!";
  LOG(ERROR) << "This is a error log!";
  LOG(ERROR) << "This is a error log!";
  return 0;
}
```

### 3、CMakeLists.txt

```bash
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
MESSAGE(STATUS "ARes CMAKE_BUILD_TYPE: ${CMAKE_BUILD_TYPE}")

# SET THIRD_PARTY_PATH
set(PROJECT_ROOT ${CMAKE_SOURCE_DIR})
set(THIRD_PARTY_PATH "${PROJECT_ROOT}/third_party" CACHE STRING
  "A path setting third party libraries download & build directories.")

# These lists are later turned into target properties on main ARes library target
set(PProcess_LINKER_LIBS "")
set(PProcess_INCLUDE_DIRS "")
set(External_Project_Dependencies "")

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

### 4、auto_build_linux.sh

```bash
#!/bin/bash

rm -rf build 

rm -rf third_party

mkdir build && cd build

cmake -DCMAKE_BUILD_TYPE=Release ..

cmake --build .

./PostProcess
```

### 5、外部库的自动引用

```bash
关键在这里
cmake/dependencies.cmake
cmake/External/gflags.cmake
cmake/External/glog.cmake
```

### 6、编译、运行、测试服务

```bash
$  sh auto_build_linux_release.sh

-- The CXX compiler identification is GNU 13.2.0
-- Detecting CXX compiler ABI info
-- Detecting CXX compiler ABI info - done
-- Check for working CXX compiler: /usr/bin/c++ - skipped
-- Detecting CXX compile features
-- Detecting CXX compile features - done
-- ARes CMAKE_BUILD_TYPE: Release
-- Performing Test CMAKE_HAVE_LIBC_PTHREAD
-- Performing Test CMAKE_HAVE_LIBC_PTHREAD - Success
-- Found Threads: TRUE
-- Could NOT find gflags (missing: GFLAGS_LIBRARIES GFLAGS_INCLUDE_DIRS)
GFLAGS_INCLUDE_DIR: /mnt/e/project/caetraining/vtk-tutorials/hello04/third_party/GFlags/GFlags-install/include
GFLAGS_LIBRARY: /mnt/e/project/caetraining/vtk-tutorials/hello04/third_party/GFlags/GFlags-install/lib/libgflags.a
-- Found GFlags: /mnt/e/project/caetraining/vtk-tutorials/hello04/third_party/GFlags/GFlags-install/include
-- Could NOT find glog (missing: GLOG_LIBRARIES GLOG_INCLUDE_DIRS)
GLOG_INCLUDE_DIR: /mnt/e/project/caetraining/vtk-tutorials/hello04/third_party/Glog/Glog-install/include
GLOG_LIBRARY: /mnt/e/project/caetraining/vtk-tutorials/hello04/third_party/Glog/Glog-install/lib/libglog.a
-- Found Glog: /mnt/e/project/caetraining/vtk-tutorials/hello04/third_party/Glog/Glog-install/include
-- Configuring done (2.1s)
-- Generating done (0.1s)
-- Build files have been written to: /mnt/e/project/caetraining/vtk-tutorials/hello04/build
[  5%] Creating directories for 'GFlags'
[ 11%] Performing download step (download, verify and extract) for 'GFlags'
-- Downloading...
   dst='/mnt/e/project/caetraining/vtk-tutorials/hello04/third_party/GFlags/GFlags-prefix/src/gflags-2.2.2.tar.gz'
   timeout='none'
   inactivity timeout='none'
-- Using src='https://cae-static-1252829527.cos.ap-shanghai.myqcloud.com/zh105/library/gflags-2.2.2.tar.gz'
-- [download 16% complete]
-- [download 58% complete]
-- [download 100% complete]
-- Downloading... done
-- extracting...
     src='/mnt/e/project/caetraining/vtk-tutorials/hello04/third_party/GFlags/GFlags-prefix/src/gflags-2.2.2.tar.gz'
     dst='/mnt/e/project/caetraining/vtk-tutorials/hello04/third_party/GFlags/GFlags-prefix/src/GFlags'
-- extracting... [tar xfz]
-- extracting... [analysis]
-- extracting... [rename]
-- extracting... [clean up]
-- extracting... done
[ 16%] No update step for 'GFlags'
[ 22%] No patch step for 'GFlags'
[ 27%] Performing configure step for 'GFlags'
loading initial cache file /mnt/e/project/caetraining/vtk-tutorials/hello04/third_party/GFlags/GFlags-prefix/tmp/GFlags-cache-Release.cmake
CMake Deprecation Warning at CMakeLists.txt:73 (cmake_minimum_required):
  Compatibility with CMake < 3.5 will be removed from a future version of
  CMake.

  Update the VERSION argument <min> value or use a ...<max> suffix to tell
  CMake that the project does not need compatibility with older versions.


-- The CXX compiler identification is GNU 13.2.0
-- Detecting CXX compiler ABI info
-- Detecting CXX compiler ABI info - done
-- Check for working CXX compiler: /usr/bin/c++ - skipped
-- Detecting CXX compile features
-- Detecting CXX compile features - done
-- Looking for C++ include unistd.h
-- Looking for C++ include unistd.h - found
-- Looking for C++ include stdint.h
-- Looking for C++ include stdint.h - found
-- Looking for C++ include inttypes.h
-- Looking for C++ include inttypes.h - found
-- Looking for C++ include sys/types.h
-- Looking for C++ include sys/types.h - found
-- Looking for C++ include sys/stat.h
-- Looking for C++ include sys/stat.h - found
-- Looking for C++ include fnmatch.h
-- Looking for C++ include fnmatch.h - found
-- Looking for C++ include stddef.h
-- Looking for C++ include stddef.h - found
-- Check size of uint32_t
-- Check size of uint32_t - done
-- Looking for strtoll
-- Looking for strtoll - found
-- Performing Test CMAKE_HAVE_LIBC_PTHREAD
-- Performing Test CMAKE_HAVE_LIBC_PTHREAD - Success
-- Found Threads: TRUE
-- Check size of pthread_rwlock_t
-- Check size of pthread_rwlock_t - done
-- Configuring done (4.8s)
-- Generating done (0.2s)
-- Build files have been written to: /mnt/e/project/caetraining/vtk-tutorials/hello04/third_party/GFlags/GFlags-prefix/src/GFlags-build
[ 33%] Performing build step for 'GFlags'
[ 12%] Building CXX object CMakeFiles/gflags_static.dir/src/gflags.cc.o
[ 25%] Building CXX object CMakeFiles/gflags_static.dir/src/gflags_reporting.cc.o
[ 37%] Building CXX object CMakeFiles/gflags_static.dir/src/gflags_completions.cc.o
[ 50%] Linking CXX static library lib/libgflags.a
[ 50%] Built target gflags_static
[ 62%] Building CXX object CMakeFiles/gflags_nothreads_static.dir/src/gflags.cc.o
[ 75%] Building CXX object CMakeFiles/gflags_nothreads_static.dir/src/gflags_reporting.cc.o
[ 87%] Building CXX object CMakeFiles/gflags_nothreads_static.dir/src/gflags_completions.cc.o
[100%] Linking CXX static library lib/libgflags_nothreads.a
[100%] Built target gflags_nothreads_static
[ 38%] Performing install step for 'GFlags'
[ 50%] Built target gflags_static
[100%] Built target gflags_nothreads_static
Install the project...
-- Install configuration: "Release"
-- Installing: /mnt/e/project/caetraining/vtk-tutorials/hello04/third_party/GFlags/GFlags-install/lib/libgflags.a
-- Installing: /mnt/e/project/caetraining/vtk-tutorials/hello04/third_party/GFlags/GFlags-install/lib/libgflags_nothreads.a
-- Installing: /mnt/e/project/caetraining/vtk-tutorials/hello04/third_party/GFlags/GFlags-install/include/gflags/gflags.h
-- Installing: /mnt/e/project/caetraining/vtk-tutorials/hello04/third_party/GFlags/GFlags-install/include/gflags/gflags_declare.h
-- Installing: /mnt/e/project/caetraining/vtk-tutorials/hello04/third_party/GFlags/GFlags-install/include/gflags/gflags_completions.h
-- Installing: /mnt/e/project/caetraining/vtk-tutorials/hello04/third_party/GFlags/GFlags-install/lib/cmake/gflags/gflags-config.cmake
-- Installing: /mnt/e/project/caetraining/vtk-tutorials/hello04/third_party/GFlags/GFlags-install/lib/cmake/gflags/gflags-config-version.cmake
-- Installing: /mnt/e/project/caetraining/vtk-tutorials/hello04/third_party/GFlags/GFlags-install/lib/cmake/gflags/gflags-targets.cmake
-- Installing: /mnt/e/project/caetraining/vtk-tutorials/hello04/third_party/GFlags/GFlags-install/lib/cmake/gflags/gflags-targets-release.cmake
-- Installing: /mnt/e/project/caetraining/vtk-tutorials/hello04/third_party/GFlags/GFlags-install/lib/cmake/gflags/gflags-nonamespace-targets.cmake
-- Installing: /mnt/e/project/caetraining/vtk-tutorials/hello04/third_party/GFlags/GFlags-install/lib/cmake/gflags/gflags-nonamespace-targets-release.cmake
-- Installing: /mnt/e/project/caetraining/vtk-tutorials/hello04/third_party/GFlags/GFlags-install/bin/gflags_completions.sh
-- Installing: /mnt/e/project/caetraining/vtk-tutorials/hello04/third_party/GFlags/GFlags-install/lib/pkgconfig/gflags.pc
-- Installing: /home/yypan/.cmake/packages/gflags/94b8dd8794e39347864199437f18f33c
[ 44%] Completed 'GFlags'
[ 44%] Built target GFlags
[ 50%] Creating directories for 'Glog'
[ 55%] Performing download step (download, verify and extract) for 'Glog'
-- Downloading...
   dst='/mnt/e/project/caetraining/vtk-tutorials/hello04/third_party/Glog/Glog-prefix/src/glog-0.6.0.tar.gz'
   timeout='none'
   inactivity timeout='none'
-- Using src='https://cae-static-1252829527.cos.ap-shanghai.myqcloud.com/zh105/library/glog-0.6.0.tar.gz'
-- [download 8% complete]
-- [download 25% complete]
-- [download 42% complete]
-- [download 59% complete]
-- [download 93% complete]
-- [download 100% complete]
-- Downloading... done
-- extracting...
     src='/mnt/e/project/caetraining/vtk-tutorials/hello04/third_party/Glog/Glog-prefix/src/glog-0.6.0.tar.gz'
     dst='/mnt/e/project/caetraining/vtk-tutorials/hello04/third_party/Glog/Glog-prefix/src/Glog'
-- extracting... [tar xfz]
-- extracting... [analysis]
-- extracting... [rename]
-- extracting... [clean up]
-- extracting... done
[ 61%] No update step for 'Glog'
[ 66%] No patch step for 'Glog'
[ 72%] Performing configure step for 'Glog'
loading initial cache file /mnt/e/project/caetraining/vtk-tutorials/hello04/third_party/Glog/Glog-prefix/tmp/Glog-cache-Release.cmake
-- The CXX compiler identification is GNU 13.2.0
-- Detecting CXX compiler ABI info
-- Detecting CXX compiler ABI info - done
-- Check for working CXX compiler: /usr/bin/c++ - skipped
-- Detecting CXX compile features
-- Detecting CXX compile features - done
CMake Deprecation Warning at cmake/GetCacheVariables.cmake:2 (cmake_policy):
  Compatibility with CMake < 3.5 will be removed from a future version of
  CMake.

  Update the VERSION argument <min> value or use a ...<max> suffix to tell
  CMake that the project does not need compatibility with older versions.
Call Stack (most recent call first):
  CMakeLists.txt:34 (include)


-- Could NOT find GTest (missing: GTest_DIR)
-- Looking for gflags namespace
-- Looking for gflags namespace - google
-- Performing Test CMAKE_HAVE_LIBC_PTHREAD
-- Performing Test CMAKE_HAVE_LIBC_PTHREAD - Success
-- Found Threads: TRUE
-- Could NOT find Unwind (missing: Unwind_INCLUDE_DIR Unwind_LIBRARY)
-- Looking for C++ include unwind.h
-- Looking for C++ include unwind.h - found
-- Looking for _Unwind_Backtrace
-- Looking for _Unwind_Backtrace - found
-- Looking for C++ include dlfcn.h
-- Looking for C++ include dlfcn.h - found
-- Looking for C++ include execinfo.h
-- Looking for C++ include execinfo.h - found
-- Looking for C++ include glob.h
-- Looking for C++ include glob.h - found
-- Looking for C++ include inttypes.h
-- Looking for C++ include inttypes.h - found
-- Looking for C++ include memory.h
-- Looking for C++ include memory.h - found
-- Looking for C++ include pwd.h
-- Looking for C++ include pwd.h - found
-- Looking for C++ include stdint.h
-- Looking for C++ include stdint.h - found
-- Looking for C++ include strings.h
-- Looking for C++ include strings.h - found
-- Looking for C++ include sys/stat.h
-- Looking for C++ include sys/stat.h - found
-- Looking for C++ include sys/syscall.h
-- Looking for C++ include sys/syscall.h - found
-- Looking for C++ include sys/time.h
-- Looking for C++ include sys/time.h - found
-- Looking for C++ include sys/types.h
-- Looking for C++ include sys/types.h - found
-- Looking for C++ include sys/utsname.h
-- Looking for C++ include sys/utsname.h - found
-- Looking for C++ include sys/wait.h
-- Looking for C++ include sys/wait.h - found
-- Looking for C++ include syscall.h
-- Looking for C++ include syscall.h - found
-- Looking for C++ include syslog.h
-- Looking for C++ include syslog.h - found
-- Looking for C++ include ucontext.h
-- Looking for C++ include ucontext.h - found
-- Looking for C++ include unistd.h
-- Looking for C++ include unistd.h - found
-- Looking for C++ include ext/hash_map
-- Looking for C++ include ext/hash_map - found
-- Looking for C++ include ext/hash_set
-- Looking for C++ include ext/hash_set - found
-- Looking for C++ include ext/slist
-- Looking for C++ include ext/slist - found
-- Looking for C++ include tr1/unordered_map
-- Looking for C++ include tr1/unordered_map - found
-- Looking for C++ include tr1/unordered_set
-- Looking for C++ include tr1/unordered_set - found
-- Looking for C++ include unordered_map
-- Looking for C++ include unordered_map - found
-- Looking for C++ include unordered_set
-- Looking for C++ include unordered_set - found
-- Looking for C++ include stddef.h
-- Looking for C++ include stddef.h - found
-- Check size of unsigned __int16
-- Check size of unsigned __int16 - failed
-- Check size of u_int16_t
-- Check size of u_int16_t - done
-- Check size of uint16_t
-- Check size of uint16_t - done
-- Looking for dladdr
-- Looking for dladdr - found
-- Looking for fcntl
-- Looking for fcntl - found
-- Looking for pread
-- Looking for pread - found
-- Looking for pwrite
-- Looking for pwrite - found
-- Looking for sigaction
-- Looking for sigaction - found
-- Looking for sigaltstack
-- Looking for sigaltstack - found
-- Performing Test HAVE_NO_DEPRECATED
-- Performing Test HAVE_NO_DEPRECATED - Success
-- Performing Test HAVE_NO_UNNAMED_TYPE_TEMPLATE_ARGS
-- Performing Test HAVE_NO_UNNAMED_TYPE_TEMPLATE_ARGS - Failed
-- Looking for pthread_threadid_np
-- Looking for pthread_threadid_np - not found
-- Looking for snprintf
-- Looking for snprintf - found
-- Looking for UnDecorateSymbolName in dbghelp
-- Looking for UnDecorateSymbolName in dbghelp - not found
-- Performing Test HAVE___ATTRIBUTE__
-- Performing Test HAVE___ATTRIBUTE__ - Success
-- Performing Test HAVE___ATTRIBUTE__VISIBILITY_DEFAULT
-- Performing Test HAVE___ATTRIBUTE__VISIBILITY_DEFAULT - Success
-- Performing Test HAVE___ATTRIBUTE__VISIBILITY_HIDDEN
-- Performing Test HAVE___ATTRIBUTE__VISIBILITY_HIDDEN - Success
-- Performing Test HAVE___BUILTIN_EXPECT
-- Performing Test HAVE___BUILTIN_EXPECT - Success
-- Performing Test HAVE___SYNC_VAL_COMPARE_AND_SWAP
-- Performing Test HAVE___SYNC_VAL_COMPARE_AND_SWAP - Success
-- Performing Test HAVE_RWLOCK
-- Performing Test HAVE_RWLOCK - Success
-- Performing Test HAVE___DECLSPEC
-- Performing Test HAVE___DECLSPEC - Failed
-- Performing Test STL_NO_NAMESPACE
-- Performing Test STL_NO_NAMESPACE - Failed
-- Performing Test STL_STD_NAMESPACE
-- Performing Test STL_STD_NAMESPACE - Success
-- Performing Test HAVE_USING_OPERATOR
-- Performing Test HAVE_USING_OPERATOR - Success
-- Performing Test HAVE_NAMESPACES
-- Performing Test HAVE_NAMESPACES - Success
-- Performing Test HAVE_GCC_TLS
-- Performing Test HAVE_GCC_TLS - Success
-- Performing Test HAVE_MSVC_TLS
-- Performing Test HAVE_MSVC_TLS - Failed
-- Performing Test HAVE_CXX11_TLS
-- Performing Test HAVE_CXX11_TLS - Success
-- Performing Test HAVE_ALIGNED_STORAGE
-- Performing Test HAVE_ALIGNED_STORAGE - Success
-- Performing Test HAVE_CXX11_ATOMIC
-- Performing Test HAVE_CXX11_ATOMIC - Success
-- Performing Test HAVE_CXX11_CONSTEXPR
-- Performing Test HAVE_CXX11_CONSTEXPR - Success
-- Performing Test HAVE_CXX11_CHRONO
-- Performing Test HAVE_CXX11_CHRONO - Success
-- Performing Test HAVE_CXX11_NULLPTR_T
-- Performing Test HAVE_CXX11_NULLPTR_T - Success
-- Performing Test HAVE_LOCALTIME_R
-- Performing Test HAVE_LOCALTIME_R - Success
-- Performing Test COMPILER_HAS_HIDDEN_VISIBILITY
-- Performing Test COMPILER_HAS_HIDDEN_VISIBILITY - Success
-- Performing Test COMPILER_HAS_HIDDEN_INLINE_VISIBILITY
-- Performing Test COMPILER_HAS_HIDDEN_INLINE_VISIBILITY - Success
-- Performing Test COMPILER_HAS_DEPRECATED_ATTR
-- Performing Test COMPILER_HAS_DEPRECATED_ATTR - Success
-- Configuring done (34.6s)
-- Generating done (0.1s)
-- Build files have been written to: /mnt/e/project/caetraining/vtk-tutorials/hello04/third_party/Glog/Glog-prefix/src/Glog-build
[ 77%] Performing build step for 'Glog'
[ 12%] Building CXX object CMakeFiles/glogbase.dir/src/demangle.cc.o
[ 25%] Building CXX object CMakeFiles/glogbase.dir/src/logging.cc.o
[ 37%] Building CXX object CMakeFiles/glogbase.dir/src/raw_logging.cc.o
[ 50%] Building CXX object CMakeFiles/glogbase.dir/src/symbolize.cc.o
[ 62%] Building CXX object CMakeFiles/glogbase.dir/src/utilities.cc.o
[ 75%] Building CXX object CMakeFiles/glogbase.dir/src/vlog_is_on.cc.o
[ 87%] Building CXX object CMakeFiles/glogbase.dir/src/signalhandler.cc.o
[ 87%] Built target glogbase
[100%] Linking CXX static library libglog.a
[100%] Built target glog
[ 83%] Performing install step for 'Glog'
[ 87%] Built target glogbase
[100%] Built target glog
Install the project...
-- Install configuration: "Release"
-- Installing: /mnt/e/project/caetraining/vtk-tutorials/hello04/third_party/Glog/Glog-install/lib/libglog.a
-- Installing: /mnt/e/project/caetraining/vtk-tutorials/hello04/third_party/Glog/Glog-install/include/glog/export.h
-- Installing: /mnt/e/project/caetraining/vtk-tutorials/hello04/third_party/Glog/Glog-install/include/glog/logging.h
-- Installing: /mnt/e/project/caetraining/vtk-tutorials/hello04/third_party/Glog/Glog-install/include/glog/raw_logging.h
-- Installing: /mnt/e/project/caetraining/vtk-tutorials/hello04/third_party/Glog/Glog-install/include/glog/stl_logging.h
-- Installing: /mnt/e/project/caetraining/vtk-tutorials/hello04/third_party/Glog/Glog-install/include/glog/vlog_is_on.h
-- Installing: /mnt/e/project/caetraining/vtk-tutorials/hello04/third_party/Glog/Glog-install/include/glog/log_severity.h
-- Installing: /mnt/e/project/caetraining/vtk-tutorials/hello04/third_party/Glog/Glog-install/include/glog/platform.h
-- Installing: /mnt/e/project/caetraining/vtk-tutorials/hello04/third_party/Glog/Glog-install/lib/pkgconfig/libglog.pc
-- Installing: /mnt/e/project/caetraining/vtk-tutorials/hello04/third_party/Glog/Glog-install/lib/cmake/glog/glog-modules.cmake
-- Installing: /mnt/e/project/caetraining/vtk-tutorials/hello04/third_party/Glog/Glog-install/lib/cmake/glog/glog-config.cmake
-- Installing: /mnt/e/project/caetraining/vtk-tutorials/hello04/third_party/Glog/Glog-install/lib/cmake/glog/glog-config-version.cmake
-- Installing: /mnt/e/project/caetraining/vtk-tutorials/hello04/third_party/Glog/Glog-install/lib/cmake/glog/glog-targets.cmake
-- Installing: /mnt/e/project/caetraining/vtk-tutorials/hello04/third_party/Glog/Glog-install/lib/cmake/glog/glog-targets-release.cmake
[ 88%] Completed 'Glog'
[ 88%] Built target Glog
[ 94%] Building CXX object CMakeFiles/PostProcess.dir/main.cpp.o
[100%] Linking CXX executable PostProcess
[100%] Built target PostProcess
I20241120 15:56:01.984898 55776 main.cpp:30] argv[0]= ./PostProcess
I20241120 15:56:01.985165 55776 main.cpp:31] This is a info log!
W20241120 15:56:01.985172 55776 main.cpp:32] This is a warning log!
E20241120 15:56:01.985225 55776 main.cpp:33] This is a error log!
```
