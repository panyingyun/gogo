if (NOT __GFLAGS_INCLUDED) # guard against multiple includes
  set(__GFLAGS_INCLUDED TRUE)

  # install directory
  set(GFLAGS_INSTALL_DIR ${THIRD_PARTY_PATH}/${GFlags_DirName}/${GFlags_DirName}-install)
  set(GFLAGS_ROOT_DIR ${GFLAGS_INSTALL_DIR})
  # use the system-wide gflags if present
  find_package(gflags)
  if (NOT GFLAGS_FOUND)
    # gflags will use pthreads if it's available in the system, so we must link with it
    find_package(Threads)
	
	# Set the library prefix and library suffix properly.
	set(CMAKE_FIND_LIBRARY_PREFIXES ${CMAKE_STATIC_LIBRARY_PREFIX})
	set(CMAKE_FIND_LIBRARY_SUFFIXES ${CMAKE_STATIC_LIBRARY_SUFFIX})
	set(LIBRARY_PREFIX ${CMAKE_STATIC_LIBRARY_PREFIX})
	set(LIBRARY_SUFFIX ${CMAKE_STATIC_LIBRARY_SUFFIX})
	
	# build directory
	SET(GFLAGS_SOURCES_DIR ${THIRD_PARTY_PATH}/${GFlags_DirName}/${GFlags_DirName}-prefix)

	INCLUDE(ExternalProject)
	# fetch and build GFlags from github
	#add_definitions(-D_GLIBCXX_USE_CXX11_ABI=0) 
	#add_definitions(-std=c++11)
	
	ExternalProject_Add(
		${GFlags_DirName}
		${EXTERNAL_PROJECT_LOG_ARGS}
		URL  https://cae-static-1252829527.cos.ap-shanghai.myqcloud.com/zh105/library/gflags-2.2.2.tar.gz
		PREFIX          ${GFLAGS_SOURCES_DIR}
		UPDATE_COMMAND  ""
		INSTALL_DIR 	${GFLAGS_INSTALL_DIR}
		CMAKE_ARGS      -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}
		CMAKE_ARGS      -DCMAKE_CXX_FLAGS=${CMAKE_CXX_FLAGS}
		#CMAKE_ARGS      -DCMAKE_INSTALL_PREFIX=${GFLAGS_INSTALL_DIR}
		CMAKE_ARGS      -DCMAKE_POSITION_INDEPENDENT_CODE=ON
		CMAKE_ARGS      -DBUILD_TESTING=OFF
		CMAKE_ARGS      -DBUILD_SHARED_LIBS=OFF
		CMAKE_ARGS      -DBUILD_STATIC_LIBS=ON
		CMAKE_ARGS      -DGFLAGS_NAMESPACE=google
		#CMAKE_ARGS      -D_GLIBCXX_USE_CXX11_ABI=0|1
		CMAKE_ARGS      -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
		CMAKE_CACHE_ARGS -DCMAKE_INSTALL_PREFIX:PATH=${GFLAGS_INSTALL_DIR}
						 -DCMAKE_POSITION_INDEPENDENT_CODE:BOOL=ON
						 -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
	)
	
	ExternalProject_Get_Property(${GFlags_DirName} INSTALL_DIR)
	set(GFLAGS_INCLUDE_DIR ${INSTALL_DIR}/include)
	message("GFLAGS_INCLUDE_DIR: " ${GFLAGS_INCLUDE_DIR})
	set(GFLAGS_LIBRARY ${INSTALL_DIR}/lib/${LIBRARY_PREFIX}gflags${LIBRARY_SUFFIX})
	message("GFLAGS_LIBRARY: " ${GFLAGS_LIBRARY})

	FIND_PACKAGE_HANDLE_STANDARD_ARGS(${GFlags_DirName} DEFAULT_MSG
		GFLAGS_INCLUDE_DIR GFLAGS_LIBRARY
		)
	
	set(GFLAGS_LIBRARIES ${GFLAGS_LIBRARY})
	set(GFLAGS_INCLUDE_DIRS ${GFLAGS_INCLUDE_DIR})
	mark_as_advanced(GFLAGS_LIBRARIES GFLAGS_INCLUDE_DIRS)
	
	# INCLUDE_DIRECTORIES
	#include_directories(${GFLAGS_INCLUDE_DIRS})
	add_dependencies(${PROJECT_NAME} ${GFlags_DirName})
	#target_link_libraries(${PROJECT_NAME} GFlags)
#	   include_directories(${GFLAGS_INCLUDE_DIRS})
#   target_link_libraries(${PROJECT_NAME}  ${GFLAGS_LIBRARIES})
	# set GFLAGS_FOUND TRUE
    set(GFLAGS_FOUND TRUE)

    list(APPEND External_Project_Dependencies ${GFlags_DirName})
#	elseif(GFLAGS_FOUND)
#   include_directories(${GFLAGS_INCLUDE_DIRS})
#   target_link_libraries(${PROJECT_NAME}  ${GFLAGS_LIBRARIES})
  endif()
   
endif()

