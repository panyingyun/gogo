cmake_minimum_required(VERSION 3.11)
project(httpserver VERSION 2.76 LANGUAGES CXX)

set(CMAKE_ROOT_PATH ${CMAKE_SOURCE_DIR}/cmake)
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_ROOT_PATH}/Modules/")

set(LIBHV_ROOT_DIR ./thirdpart/libhv)

set(EXECUTABLE_OUTPUT_PATH  ${PROJECT_SOURCE_DIR})

find_package(LibHV REQUIRED)

message(STATUS " LIBHV_FOUND = " ${LIBHV_FOUND})
message(STATUS " LIBHV_ROOT_DIR = " ${LIBHV_ROOT_DIR})
message(STATUS " LIBHV_INCLUDE_DIRS = " ${LIBHV_INCLUDE_DIRS})
message(STATUS " LIBHV_LIBRARIES = " ${LIBHV_LIBRARIES})

add_executable(${PROJECT_NAME})

list(APPEND SOURCES ${PROJECT_SOURCE_DIR}/http_server_test.cpp)
list(APPEND THIRDPARTY_LIBS ${LIBHV_LIBRARIES})

target_sources(${PROJECT_NAME} 
            PRIVATE ${SOURCES}
            )
target_include_directories(${PROJECT_NAME} 
            PRIVATE  ${LIBHV_INCLUDE_DIRS}
            )
target_link_libraries(${PROJECT_NAME} 
            PRIVATE ${THIRDPARTY_LIBS}
            )