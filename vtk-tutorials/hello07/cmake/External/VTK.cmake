if (NOT __VTK_INCLUDED)
	set(__VTK_INCLUDED TRUE)

	# VTK build directory
	set(VTK_SOURCES_DIR ${THIRD_PARTY_PATH}/${VTK_DirName}/${VTK_DirName}-sources)
	# VTK install directory
	set(VTK_INSTALL_DIR ${THIRD_PARTY_PATH}/${VTK_DirName}/${VTK_DirName}-install)

	# where to find VTK
	set(VTK_ROOT_DIR ${VTK_INSTALL_DIR})
	set(VTK_VERSION "9.4")
	set(VTK_DIR ${VTK_INSTALL_DIR})
	set(VTK_DIR ${VTK_INSTALL_DIR}/lib/cmake/vtk-${VTK_VERSION})
	find_package(LocalVTK)

	if (NOT VTK_FOUND)
		set(VTK_URL "https://geo.yuansuan.com/webgpu/VTK-9.4.1.tar.gz")
		set(USE_MPI_MODE "WANT")

		include(ExternalProject)
		ExternalProject_Add(${VTK_DirName}
				PREFIX ${VTK_SOURCES_DIR}
				URL ${VTK_URL}

				# common compiler and install settings
				CMAKE_ARGS -DCMAKE_C_FLAGS:STRING=${ARCH_CMAKE_C_FLAGS}
				CMAKE_ARGS -DCMAKE_CXX_FLAGS:STRING=${ARCH_CMAKE_C_FLAGS}
				# CMAKE_ARGS -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON
				CMAKE_ARGS -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
				CMAKE_ARGS -DCMAKE_INSTALL_PREFIX:PATH=${VTK_INSTALL_DIR}
				CMAKE_ARGS -DBUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS}

				CMAKE_ARGS -DVTK_Group_Rendering:BOOL=ON
				CMAKE_ARGS -DVTK_USE_OPENGL:BOOL=ON
				CMAKE_ARGS -DVTK_RENDERING_OPENGL2:BOOL=ON

				BUILD_COMMAND ${CompileCPUMax_MakeCommand}
				INSTALL_DIR ${VTK_INSTALL_DIR}
				${EXTERNAL_PROJECT_LOG_ARGS}
		)
		list(APPEND PROJECT_EXTERNAL_DEPENDENCIES ${VTK_DirName})
		#rerun cmake in initial build
		#will update cmakecache/project files on first build
		#so you may have to reload project after first build
		add_custom_target(Rescan ${CMAKE_COMMAND} ${CMAKE_SOURCE_DIR} DEPENDS  ${VTK_DirName})
		list(APPEND PROJECT_EXTERNAL_DEPENDENCIES Rescan)
	else()
		#Rescan becomes a dummy target after first build
		#this prevents cmake from rebuilding cache/projects on subsequent builds
		add_custom_target(Rescan)
	endif()
endif ()