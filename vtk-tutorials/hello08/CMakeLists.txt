CMAKE_MINIMUM_REQUIRED(VERSION 3.16)

set(CMAKE_ROOT_PATH ${CMAKE_SOURCE_DIR}/cmake)
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_ROOT_PATH}/Modules/")
set(CMAKE_EXTERNAL_PATH ${CMAKE_ROOT_PATH}/External)

set(CMAKE_CXX_STANDARD 17)
set(PROJECT_NAME "OffScreen")

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
