if (NOT __PARAVIEW_INCLUDED)
    set(__PARAVIEW_INCLUDED TRUE)

    # ParaView build directory
    set(ParaView_SOURCES_DIR ${THIRD_PARTY_PATH}/${ParaView_DirName}/${ParaView_DirName}-sources)

    # ParaView install directory
    set(ParaView_INSTALL_DIR ${THIRD_PARTY_PATH}/${ParaView_DirName}/${ParaView_DirName}-install)

    # where to find ParaView
    set(PARAVIEW_ROOT_DIR ${ParaView_INSTALL_DIR})
    set(PARAVIEW_LIBS_DIR "")

    if (BUILD_AT_UBUNTU)
        set(PARAVIEW_LIBS_DIR ${PARAVIEW_ROOT_DIR}/lib)
    elseif (BUILD_AT_CENTOS)
        set(PARAVIEW_LIBS_DIR ${PARAVIEW_ROOT_DIR}/lib64)
    endif ()

    set(PARAVIEW_VERSION "5.9")
    set(ParaView_DIR ${PARAVIEW_LIBS_DIR}/cmake/paraview-${PARAVIEW_VERSION})
    set(VTK_DIR ${ParaView_DIR}/vtk)
    find_package(LocalParaView)

    if (NOT ParaView_FOUND)
        set(PARAVIEW_URL "")
        if (NOT USE_LOCAL_THIRD_PARTY)
            set(PARAVIEW_URL "https://cae-static-1252829527.cos.ap-shanghai.myqcloud.com/CloudCAE/ARes/ParaView-5.9.0-lata.tar.gz")
        else ()
            set(PARAVIEW_URL file://${THIRD_PARTY_PATH}/ParaView-5.9.0-lata.tar.gz)
        endif ()

        set(PARAVIEW_DEPENDS "")
        if (NOT Boost_FOUND)
            list(APPEND PARAVIEW_DEPENDS ${Boost_DirName})
        endif ()
        if (NOT HDF5_FOUND)
            list(APPEND PARAVIEW_DEPENDS ${HDF5_DirName})
        endif ()
        if (NOT CGNS_FOUND)
            list(APPEND PARAVIEW_DEPENDS ${CGNS_DirName})
        endif ()

        set(PARAVIEW_INSTALL_COMMAND make install && cp -f ${ParaView_SOURCES_DIR}/src/${ParaView_DirName}/VTKExtensions/CGNSReader/vtkCGNSCache.h ${ParaView_INSTALL_DIR}/include/paraview-${PARAVIEW_VERSION}/)

        if (BUILD_WITH_PARALLEL AND BUILD_SHARED_LIBS)
            set(PARAVIEW_CMAKE_C_FLAGS "${MPI_HOME}/bin/mpicc")
            set(PARAVIEW_CMAKE_CXX_FLAGS "${MPI_HOME}/bin/mpic++")
            set(USE_MPI_MODE "YES")
            set(VTK_SMP_IMPLEMENTATION_TYPE_STRING "-DVTK_SMP_IMPLEMENTATION_TYPE=OpenMP")
        else ()
            set(PARAVIEW_CMAKE_C_FLAGS "/usr/bin/gcc")
            set(PARAVIEW_CMAKE_CXX_FLAGS "/usr/bin/g++")
            set(USE_MPI_MODE "NO")
            set(VTK_SMP_IMPLEMENTATION_TYPE_STRING "")
        endif ()

        include(ExternalProject)
        if (BUILD_WITH_STATIC)
            ExternalProject_Add(
                    ${ParaView_DirName}
                    PREFIX ${ParaView_SOURCES_DIR}
                    DEPENDS ${PARAVIEW_DEPENDS}
                    URL ${PARAVIEW_URL}
                    # Build Need Boost
                    CMAKE_ARGS -DPARAVIEW_USE_Boost=FALSE
                    CMAKE_ARGS -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
                    CMAKE_ARGS -DPARAVIEW_BUILD_SHARED_LIBS=FALSE
                    CMAKE_ARGS -DPARAVIEW_USE_QT=FALSE
                    CMAKE_ARGS -DPARAVIEW_USE_VTKM=FALSE
                    # Disabled Build Most VTK Modules
                    CMAKE_ARGS -DVTK_GROUP_ENABLE_Qt=NO
                    CMAKE_ARGS -DVTK_GROUP_ENABLE_Views=NO
                    CMAKE_ARGS -DVTK_GROUP_ENABLE_Web=NO
                    # Modules For VisIt Reader
                    CMAKE_ARGS -DPARAVIEW_ENABLE_VISITBRIDGE=TRUE
                    # Modules For MEDFileIO
                    CMAKE_ARGS -DVTK_MODULE_ENABLE_ParaView_RemotingCore=YES
                    CMAKE_ARGS -DVTK_MODULE_ENABLE_ParaView_VTKExtensionsFiltersRendering=YES
                    CMAKE_ARGS -DVTK_MODULE_ENABLE_ParaView_VTKExtensionsMisc=YES
                    # Off Screen
                    CMAKE_ARGS -DVTK_USE_X:BOOL=OFF
                    CMAKE_ARGS -DVTK_DEFAULT_RENDER_WINDOW_OFFSCREEN:BOOL=ON
                    CMAKE_ARGS -DVTK_OPENGL_HAS_OSMESA:BOOL=ON
                    # Modules For MPI
                    CMAKE_ARGS -DPARAVIEW_USE_MPI:BOOL=${BUILD_WITH_PARALLEL}
                    CMAKE_ARGS -DMPI_HOME=${MPI_HOME}
                    CMAKE_ARGS -DVTKm_ENABLE_OPENMP=${BUILD_WITH_PARALLEL}

                    # Tecplot File
                    CMAKE_ARGS -DVTK_MODULE_ENABLE_VTK_IOTecplotTable=YES

                    # CMAKE_ARGS -DCMAKE_CXX_COMPILER:STRING=${PARAVIEW_CMAKE_CXX_FLAGS}
                    # CMAKE_ARGS -DCMAKE_C_COMPILER:STRING=${PARAVIEW_CMAKE_C_FLAGS}

                    CMAKE_ARGS ${VTK_SMP_IMPLEMENTATION_TYPE_STRING}
                    CMAKE_ARGS -DVTK_MODULE_ENABLE_VTK_FiltersParallelMPI=${USE_MPI_MODE}
                    CMAKE_ARGS -DVTK_MODULE_ENABLE_VTK_ParallelMPI=${USE_MPI_MODE}

                    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${ParaView_INSTALL_DIR}
                    BUILD_COMMAND ${CompileCPUMax_MakeCommand}
                    INSTALL_DIR ${ParaView_INSTALL_DIR}
                    ${EXTERNAL_PROJECT_LOG_ARGS}
            )
        else ()
            ExternalProject_Add(
                    ${ParaView_DirName}
                    PREFIX ${ParaView_SOURCES_DIR}
                    DEPENDS ${PARAVIEW_DEPENDS}
                    URL ${PARAVIEW_URL}
                    # Ray-tracing Support
                    # CMAKE_ARGS -DPARAVIEW_ENABLE_RAYTRACING:BOOL=OFF
                    # CMAKE_ARGS -DPARAVIEW_ENABLE_OSPRAY:BOOL=OFF
                    # Build Need EXTERNAL HDF5
                    CMAKE_ARGS -DVTK_MODULE_USE_EXTERNAL_VTK_hdf5:BOOL=ON
                    CMAKE_ARGS -DHDF5_DIR:PATH=${HDF5_DIR}
                    CMAKE_ARGS -DHDF5_USE_STATIC_LIBRARIES:BOOL=${BUILD_WITH_STATIC}
                    CMAKE_ARGS -DHDF5_ROOT:PATH=${HDF5_ROOT_DIR}
                    CMAKE_ARGS -DHDF5_hdf5_LIBRARY_RELEASE=${HDF5_ROOT_DIR}/lib
                    CMAKE_ARGS -DHDF5_hdf5_hl_LIBRARY_RELEASE=${HDF5_ROOT_DIR}/lib/${LIBRARY_PREFIX}hdf5_hl${LIBRARY_SUFFIX}
                    CMAKE_ARGS -DHDF5_hdf5_CXX_LIBRARY_RELEASE=${HDF5_ROOT_DIR}/lib/${LIBRARY_PREFIX}hdf5_cpp${LIBRARY_SUFFIX}
                    CMAKE_ARGS -DHDF5_HL_LIBRARY=${HDF5_ROOT_DIR}/lib/${LIBRARY_PREFIX}hdf5_hl${LIBRARY_SUFFIX}
                    CMAKE_ARGS -DHDF5_C_INCLUDE_DIR=${HDF5_ROOT_DIR}/include

                    # Module For freetype
                    # CMAKE_ARGS -DVTK_MODULE_USE_EXTERNAL_VTK_freetype:BOOL=OFF
                    # Modules For MPI
                    CMAKE_ARGS -DPARAVIEW_USE_MPI:BOOL=${BUILD_WITH_PARALLEL}
                    CMAKE_ARGS -DVTKm_ENABLE_OPENMP=${BUILD_WITH_PARALLEL}

                    # Tecplot File
                    CMAKE_ARGS -DVTK_MODULE_ENABLE_VTK_IOTecplotTable=YES

                    # CMAKE_ARGS -DCMAKE_CXX_COMPILER:STRING=${PARAVIEW_CMAKE_CXX_FLAGS}
                    # CMAKE_ARGS -DCMAKE_C_COMPILER:STRING=${PARAVIEW_CMAKE_C_FLAGS}

                    # CMAKE_ARGS ${VTK_SMP_IMPLEMENTATION_TYPE_STRING}
                    # CMAKE_ARGS -DVTK_MODULE_ENABLE_VTK_FiltersParallelMPI=${USE_MPI_MODE}
                    # CMAKE_ARGS -DVTK_MODULE_ENABLE_VTK_ParallelMPI=${USE_MPI_MODE}

                    # Disabled Build WITH JAVA
                    CMAKE_ARGS -DVTK_WRAP_JAVA:BOOL=OFF
                    # common compiler and install settings
                    # CMAKE_ARGS -DCMAKE_C_FLAGS:STRING=-m64
                    # CMAKE_ARGS -DCMAKE_CXX_FLAGS:STRING=-m64
                    # CMAKE_ARGS -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON
                    CMAKE_ARGS -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
                    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX:STRING=${ParaView_INSTALL_DIR}

                    # common ParaView settings
                    # CMAKE_ARGS -DVTK_USE_64BIT_IDS:BOOL=ON
                    CMAKE_ARGS -DPARAVIEW_BUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS}
                    CMAKE_ARGS -DCMAKE_INSTALL_LIBDIR:STRING=lib
                    CMAKE_ARGS -DBUILD_TESTING:BOOL=OFF
                    CMAKE_ARGS -DPARAVIEW_INSTALL_DEVELOPMENT_FILES:BOOL=ON
                    # Extra options
                    CMAKE_ARGS -DPARAVIEW_PLUGINS_DEFAULT:BOOL=ON
                    CMAKE_ARGS -DPARAVIEW_PLUGIN_ENABLE_Moments:BOOL=OFF
                    CMAKE_ARGS -DPARAVIEW_PLUGIN_ENABLE_SLACTools:BOOL=OFF
                    CMAKE_ARGS -DPARAVIEW_PLUGIN_ENABLE_PacMan:BOOL=OFF
                    CMAKE_ARGS -DPARAVIEW_PLUGIN_ENABLE_pvblot:BOOL=OFF
                    # Disabled Build QT
                    CMAKE_ARGS -DPARAVIEW_USE_QT=FALSE
                    CMAKE_ARGS -DVTK_GROUP_ENABLE_Qt=NO
                    # Disabled Build Most VTK Modules
                    CMAKE_ARGS -DVTK_GROUP_ENABLE_Views=NO
                    CMAKE_ARGS -DVTK_GROUP_ENABLE_Web=NO
                    # Disabled Build VTKM
                    CMAKE_ARGS -DPARAVIEW_USE_VTKM=FALSE
                    # Modules For VisIt Reader
                    CMAKE_ARGS -DPARAVIEW_ENABLE_VISITBRIDGE=TRUE
                    # Modules For MEDFileIO
                    CMAKE_ARGS -DVTK_MODULE_ENABLE_ParaView_RemotingCore=YES
                    CMAKE_ARGS -DVTK_MODULE_ENABLE_ParaView_VTKExtensionsFiltersRendering=YES
                    CMAKE_ARGS -DVTK_MODULE_ENABLE_ParaView_VTKExtensionsMisc=YES
                    # Modules For IOGeoJSON
                    CMAKE_ARGS -DVTK_MODULE_ENABLE_VTK_IOGeoJSON=YES
                    # Modules For Misc (CompositeDataToUnstructuredGrid)
                    CMAKE_ARGS -DVTK_MODULE_ENABLE_VTK_CommonMisc=YES
                    # Off Screen
                    CMAKE_ARGS -DVTK_USE_X:BOOL=OFF
                    CMAKE_ARGS -DVTK_DEFAULT_RENDER_WINDOW_OFFSCREEN:BOOL=ON
                    CMAKE_ARGS -DVTK_OPENGL_HAS_OSMESA:BOOL=ON

                    BUILD_COMMAND ${CompileCPUMax_MakeCommand}
                    INSTALL_COMMAND ${PARAVIEW_INSTALL_COMMAND}
                    INSTALL_DIR ${ParaView_INSTALL_DIR}
                    # ${EXTERNAL_PROJECT_LOG_ARGS}
            )
        endif ()

        ExternalProject_Get_Property(${ParaView_DirName} INSTALL_DIR)

        set(PARAVIEW_INCLUDE_DIRS ${INSTALL_DIR}/include)
        # todo
        set(PARAVIEW_LIBRARIES ${INSTALL_DIR}/lib/)

        set(VTK_INCLUDE_DIRS ${PARAVIEW_INCLUDE_DIRS})
        set(VTK_LIBRARIES ${PARAVIEW_LIBRARIES})

        list(APPEND PROJECT_EXTERNAL_DEPENDENCIES ${ParaView_DirName})
    endif ()

endif ()
