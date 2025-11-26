CMAKE_MINIMUM_REQUIRED(VERSION 3.16)

set(CMAKE_ROOT_PATH ${CMAKE_SOURCE_DIR}/cmake)
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_ROOT_PATH}/Modules/")
set(CMAKE_EXTERNAL_PATH ${CMAKE_ROOT_PATH}/External)

# Make sure that all _ROOT variables *are* used when they are set.
if (POLICY CMP0074)
    cmake_policy(SET CMP0074 NEW)
endif ()

# 指定为C++17 版本
set(CMAKE_CXX_STANDARD 17)

include(${CMAKE_ROOT_PATH}/Utils.cmake)
include(${CMAKE_ROOT_PATH}/System.cmake)
include(${CMAKE_ROOT_PATH}/SearchIncludeDir.cmake)

#--------------------------------------------
# Project setting
#--------------------------------------------
set(PROJECT_NAME "MEDTEST")

include(CMakeDependentOption)
option(BUILD_THIRD_PARTY_MODE "Build ${PROJECT_NAME} Dependency Only." OFF)

if (BUILD_THIRD_PARTY_MODE)
    MESSAGE(STATUS "Build ${PROJECT_NAME} Dependency Only: ${BUILD_THIRD_PARTY_MODE}")
else ()
    PROJECT_EXTRACT_VERSION()
endif ()

PROJECT(${PROJECT_NAME} VERSION ${PROJECT_VERSION} LANGUAGES C CXX)

MESSAGE(INFO "--------------------------------")
MESSAGE(STATUS "Build ${PROJECT_NAME}: ${PROJECT_VERSION}")
MESSAGE(STATUS "Found ${PROJECT_NAME} host system: ${HOST_SYSTEM}")
MESSAGE(STATUS "Found ${PROJECT_NAME} host system's CPU: ${CPU_CORES} cores")
#
# Project User options
# ============
option(BUILD_WITH_MEDFILEIO "Build ${PROJECT_NAME} with MEDFileIO dependency." ON)

option(BUILD_WITH_STATIC "Build ${PROJECT_NAME} dependency library in static mode." OFF)
option(BUILD_WITH_PARALLEL "Build ${PROJECT_NAME} dependency library with parallel mode." OFF)

if (BUILD_WITH_STATIC)
    set(BUILD_SHARED_LIBS FALSE)
else ()
    set(BUILD_SHARED_LIBS TRUE)
endif ()

option(USE_LOCAL_THIRD_PARTY "Build ${PROJECT_NAME} with Local dependency." OFF)

if (${HOST_SYSTEM} STREQUAL "ubuntu")
    set(BUILD_AT_UBUNTU TRUE)
elseif (${HOST_SYSTEM} STREQUAL "centos")
    set(BUILD_AT_CENTOS TRUE)
else ()
    message(FATAL_ERROR "Sorry !! This Platform Is Not Currently Supported !")
endif ()

# CMAKE_BUILD_TYPE
if (NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE "Release" CACHE STRING
            "Choose the type of build, options are: Debug Release RelWithDebInfo MinSizeRel"
            FORCE)
endif ()
MESSAGE(STATUS "${PROJECT_NAME} CMAKE_BUILD_TYPE: ${CMAKE_BUILD_TYPE}")

# 判读在测试模式下是否加入测试宏
if (BUILD_TESTS)
    add_definitions(-DUSE_TEST)
else ()
    # add_definitions(-DUSE_TEST)
endif ()

# 判读在DEBUG模式下是否加入DEBUG宏
if (${CMAKE_BUILD_TYPE} STREQUAL "Debug")
    add_definitions(-DUSE_DEBUG)
else ()
    # add_definitions(-DUSE_TEST)
endif ()

# todo 官方文档提示慎用此功能 故在此做标记（用于获取所有需要包含的编译文件）
# 递归获取目标路径下的所有需要编译的文件
set(SRC_SOURCES "")
file(GLOB_RECURSE SRC_SOURCES
        ${CMAKE_CURRENT_SOURCE_DIR}/src/*c
        ${CMAKE_CURRENT_SOURCE_DIR}/src/*cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/src/*cxx)

file(GLOB_RECURSE HEAD_SOURCES
        ${CMAKE_CURRENT_SOURCE_DIR}/src/*h
        ${CMAKE_CURRENT_SOURCE_DIR}/src/*hpp
        ${CMAKE_CURRENT_SOURCE_DIR}/src/*hxx)

# 向下递归二级获取目标路径下的所有需要包含的头文件夹
set(SOURCE_INCLUDE_DIRS "")
FIND_SUBDIRECTORY(${CMAKE_CURRENT_SOURCE_DIR}/src SOURCE_INCLUDE_DIRS)

add_executable(${PROJECT_NAME})

# SET THIRD_PARTY_PATH
set(PROJECT_ROOT ${CMAKE_SOURCE_DIR})
set(THIRD_PARTY_PATH "${PROJECT_ROOT}/third_party" CACHE STRING
        "A path setting third party libraries download & build directories.")

# These lists are later turned into target properties on main ${PROJECT_NAME} library target
set(PROJECT_INCLUDE_DIRS "")
set(PROJECT_LINKER_LIBS "")
set(PROJECT_LINKER_DIRS "")
set(PROJECT_EXTERNAL_DEPENDENCIES "")

# DOWNLOAD BUILD INSTALL THIRD_PARTY_PATH
include(${CMAKE_ROOT_PATH}/Dependencies.cmake)

if (PROJECT_EXTERNAL_DEPENDENCIES)
    add_dependencies(${PROJECT_NAME} ${PROJECT_EXTERNAL_DEPENDENCIES})
endif ()

target_sources(${PROJECT_NAME}
        PUBLIC ${HEAD_SOURCES}
        PRIVATE ${SRC_SOURCES}
)

target_include_directories(${PROJECT_NAME}
        PUBLIC
        ${SOURCE_INCLUDE_DIRS})

if (BUILD_THIRD_PARTY_MODE)
    MESSAGE(STATUS "Not Link Everything")
else ()
    include_directories(${PROJECT_NAME}
            PUBLIC
            ${PROJECT_INCLUDE_DIRS}
    )

    if (BUILD_WITH_STATIC)
        target_link_libraries(${PROJECT_NAME}
                PUBLIC
                -Wl,--start-group
                ${PROJECT_LINKER_LIBS}
                -Wl,--end-group
        )
    else ()
        set(CMAKE_SKIP_BUILD_RPATH FALSE)
        set(CMAKE_BUILD_WITH_INSTALL_RPATH FALSE)
        set(CMAKE_INSTALL_RPATH "${CMAKE_INSTALL_PREFIX}/lib" "${PROJECT_LINKER_DIRS}")
        set(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)

        target_link_libraries(${PROJECT_NAME}
                PUBLIC
                ${PROJECT_LINKER_LIBS}
        )
    endif ()
endif ()
