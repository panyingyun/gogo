cmake_minimum_required(VERSION 3.11)
project(httpserver VERSION 2.76)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -std=c99")

set(CMAKE_ROOT_PATH ${CMAKE_SOURCE_DIR}/cmake)
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_ROOT_PATH}/Modules/")

set(LIBHV_ROOT_DIR ./thirdpart/libhv)

set(EXECUTABLE_OUTPUT_PATH  ${PROJECT_SOURCE_DIR})

find_package(LibHV REQUIRED)

message(STATUS " LIBHV_FOUND = " ${LIBHV_FOUND})
message(STATUS " LIBHV_ROOT_DIR = " ${LIBHV_ROOT_DIR})
message(STATUS " LIBHV_INCLUDE_DIRS = " ${LIBHV_INCLUDE_DIRS})
message(STATUS " LIBHV_LIBRARIES = " ${LIBHV_LIBRARIES})




#list(APPEND SOURCES ${PROJECT_SOURCE_DIR}/yslog.c)
#list(APPEND SOURCES ${PROJECT_SOURCE_DIR}/yslog.h)
list(APPEND SOURCES ${PROJECT_SOURCE_DIR}/http_server_test.cpp)

list(APPEND THIRDPARTY_LIBS ${LIBHV_LIBRARIES})
list(APPEND THIRDPARTY_LIBS pthread)
list(APPEND THIRDPARTY_LIBS yslog)

message(STATUS " SOURCES = " ${SOURCES})
message(STATUS " THIRDPARTY_LIBS = " ${THIRDPARTY_LIBS})


add_subdirectory(yslog)

aux_source_directory(. DIR_SRCS)

add_executable(${PROJECT_NAME} MACOSX_BUNDLE ${DIR_SRCS} ${DIR_YSLOG_SRCS})

#target_sources(${PROJECT_NAME} ${DIR_SRCS})


target_include_directories(${PROJECT_NAME} PUBLIC
              ${LIBHV_INCLUDE_DIRS}
            )
            
target_link_libraries(${PROJECT_NAME} ${THIRDPARTY_LIBS})
