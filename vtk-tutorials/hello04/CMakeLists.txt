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
