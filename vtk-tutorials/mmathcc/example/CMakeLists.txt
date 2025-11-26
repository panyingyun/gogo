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