if (NOT __GLOG_INCLUDED)
  set(__GLOG_INCLUDED TRUE)

  # install directory
  SET(GLOG_INSTALL_DIR ${THIRD_PARTY_PATH}/${Glog_DirName}/${Glog_DirName}-install)
  # try the system-wide Glog first
  set(GLOG_ROOT_DIR ${GLOG_INSTALL_DIR})
  find_package(glog)
  if (NOT GLOG_FOUND)
	# Set the library prefix and library suffix properly.
	set(CMAKE_FIND_LIBRARY_PREFIXES ${CMAKE_STATIC_LIBRARY_PREFIX})
	set(CMAKE_FIND_LIBRARY_SUFFIXES ${CMAKE_STATIC_LIBRARY_SUFFIX})
	set(LIBRARY_PREFIX ${CMAKE_STATIC_LIBRARY_PREFIX})
	set(LIBRARY_SUFFIX ${CMAKE_STATIC_LIBRARY_SUFFIX})
	
	# build directory
	SET(GLOG_SOURCES_DIR ${THIRD_PARTY_PATH}/${Glog_DirName}/${Glog_DirName}-prefix)
	
	INCLUDE(ExternalProject)
	# fetch and build Glog from github
	ExternalProject_Add(
    ${Glog_DirName}
    ${EXTERNAL_PROJECT_LOG_ARGS}
    DEPENDS GFlags
    URL  https://cae-static-1252829527.cos.ap-shanghai.myqcloud.com/zh105/library/glog-0.6.0.tar.gz
    PREFIX          ${GLOG_SOURCES_DIR}
    UPDATE_COMMAND  ""
	INSTALL_DIR 	${GLOG_INSTALL_DIR}
    CMAKE_ARGS      -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}
    CMAKE_ARGS      -DCMAKE_CXX_FLAGS=${CMAKE_CXX_FLAGS}
    #CMAKE_ARGS      -DCMAKE_INSTALL_PREFIX=${GLOG_INSTALL_DIR}
    CMAKE_ARGS      -DCMAKE_POSITION_INDEPENDENT_CODE=ON
    CMAKE_ARGS      -DWITH_GFLAGS=ON
    CMAKE_ARGS      -Dgflags_DIR=${GFLAGS_INSTALL_DIR}/lib/cmake/gflags
    CMAKE_ARGS      -DBUILD_TESTING=OFF
	CMAKE_ARGS      -DBUILD_SHARED_LIBS=OFF
    CMAKE_ARGS      -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
    CMAKE_CACHE_ARGS -DCMAKE_INSTALL_PREFIX:PATH=${GLOG_INSTALL_DIR}
                     -DCMAKE_POSITION_INDEPENDENT_CODE:BOOL=ON
                     -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
	)	

	#export CPPFLAGS="-I${GFLAGS_ROOT_DIR}/include" && export LDFLAGS="-L${GFLAGS_ROOT_DIR}/lib" 
	ExternalProject_Get_Property(${Glog_DirName} INSTALL_DIR)
	set(GLOG_INCLUDE_DIR ${INSTALL_DIR}/include)
	message("GLOG_INCLUDE_DIR: " ${GLOG_INCLUDE_DIR})
	set(GLOG_LIBRARY ${INSTALL_DIR}/lib/${LIBRARY_PREFIX}glog${LIBRARY_SUFFIX})
	message("GLOG_LIBRARY: " ${GLOG_LIBRARY})

	FIND_PACKAGE_HANDLE_STANDARD_ARGS(${Glog_DirName} DEFAULT_MSG
		GLOG_INCLUDE_DIR GLOG_LIBRARY
		)
		
	set(GLOG_LIBRARIES ${GLOG_LIBRARY})
	set(GLOG_INCLUDE_DIRS ${GLOG_INCLUDE_DIR})
	get_filename_component(GLOG_LIB_DIR ${GLOG_LIBRARY} DIRECTORY)
	set(GLOG_LIB_DIRS ${GLOG_LIB_DIR})
	mark_as_advanced(GLOG_LIBRARIES GLOG_INCLUDE_DIRS GLOG_LIB_DIRS)
	
	# INCLUDE_DIRECTORIES
	#include_directories(${GLOG_INCLUDE_DIRS})
	add_dependencies(${PROJECT_NAME} ${Glog_DirName})	
#	   include_directories(${GLOG_INCLUDE_DIRS})
#   target_link_libraries(${PROJECT_NAME}  ${GLOG_LIBRARIES})
	# set GLOG_FOUND TRUE
    set(GLOG_FOUND TRUE)
		
    list(APPEND External_Project_Dependencies ${Glog_DirName})
#	elseif(GLOG_FOUND)	
#   include_directories(${GLOG_INCLUDE_DIRS})
#   target_link_libraries(${PROJECT_NAME}  ${GLOG_LIBRARIES})
  endif()

endif()

