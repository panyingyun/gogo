if (NOT __HDF5_INCLUDED)
    set(__HDF5_INCLUDED TRUE)

    # HDF5 build directory
    SET(HDF5_SOURCES_DIR ${THIRD_PARTY_PATH}/${HDF5_DirName}/${HDF5_DirName}-sources)
    # HDF5 install directory
    SET(HDF5_INSTALL_DIR ${THIRD_PARTY_PATH}/${HDF5_DirName}/${HDF5_DirName}-install)

    # where to find HDF5
    set(HDF5_ROOT_DIR ${HDF5_INSTALL_DIR})
    set(HDF5_LIBS_DIR ${HDF5_ROOT_DIR}/lib)
    set(HDF5_DIR ${HDF5_INSTALL_DIR}/share/cmake/hdf5)
    find_package(LocalHDF5)

    if (NOT HDF5_FOUND)
        set(HDF5_URL "")
        if (NOT USE_LOCAL_THIRD_PARTY)
            set(HDF5_URL "https://cae-static-1252829527.cos.ap-shanghai.myqcloud.com/CloudCAE/ARes/hdf5-1.10.6.tar.gz")
        else ()
            set(HDF5_URL file://${THIRD_PARTY_PATH}/hdf5-1.10.6.tar.gz)
        endif ()

        set(HDF5_DEPENDS "")
        if (NOT ZLIB_FOUND)
            list(APPEND HDF5_DEPENDS ${ZLib_DirName})
        endif ()
        if (NOT OpenMPI_FOUND AND BUILD_WITH_PARALLEL)
            list(APPEND HDF5_DEPENDS ${OpenMPI_DirName})
        endif ()

        include(ExternalProject)
        ExternalProject_Add(
                ${HDF5_DirName}
                PREFIX ${HDF5_SOURCES_DIR}
                DEPENDS ${HDF5_DEPENDS}
                URL ${HDF5_URL}

                CMAKE_ARGS -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON
                CMAKE_ARGS -DHDF5_BUILD_TOOLS:BOOL=ON
                CMAKE_ARGS -DHDF5_BUILD_HL_LIB:BOOL=ON
                CMAKE_ARGS -DHDF5_BUILD_CPP_LIB:BOOL=ON
                CMAKE_ARGS -DHDF5_ENABLE_PARALLEL:BOOL=${BUILD_WITH_PARALLEL}
                CMAKE_ARGS -DHDF5_ENABLE_THREADSAFE:BOOL=OFF
                CMAKE_ARGS -DMPI_HOME:PATH=${MPI_HOME}
                CMAKE_ARGS -DALLOW_UNSUPPORTED:BOOL=ON
                CMAKE_ARGS -DHDF5_ALLOW_EXTERNAL_SUPPORT:BOOL=ON
                CMAKE_ARGS -DBUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS}
                CMAKE_ARGS -DBUILD_TESTING=OFF
                CMAKE_ARGS -DHDF5_ENABLE_Z_LIB_SUPPORT:BOOL=ON
                CMAKE_ARGS -DZLIB_INCLUDE_DIR:PATH=${ZLIB_INSTALL_DIR}/include
                CMAKE_ARGS -DZLIB_LIBRARY:PATH=${ZLIB_INSTALL_DIR}/lib/${LIBRARY_PREFIX}z${LIBRARY_SUFFIX}
                CMAKE_ARGS -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
                CMAKE_ARGS -DCMAKE_INSTALL_PREFIX:PATH=${HDF5_INSTALL_DIR}

                BUILD_COMMAND ${CompileCPUMax_MakeCommand}
                INSTALL_COMMAND make install
                INSTALL_DIR ${HDF5_INSTALL_DIR}
                ${EXTERNAL_PROJECT_LOG_ARGS}
        )

        ExternalProject_Get_Property(${HDF5_DirName} INSTALL_DIR)

        set(HDF5_INCLUDE_DIRS ${INSTALL_DIR}/include)
        # todo
        set(HDF5_LIBRARIES ${INSTALL_DIR}/lib/${LIBRARY_PREFIX}hdf5${LIBRARY_SUFFIX})


        list(APPEND PROJECT_EXTERNAL_DEPENDENCIES ${HDF5_DirName})
    endif ()
endif ()