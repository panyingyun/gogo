if (NOT _MEDCoupling_INCLUDED)
    set(_MEDCoupling_INCLUDED TRUE)

    # MEDCoupling source directory
    SET(MEDCoupling_SOURCES_DIR ${THIRD_PARTY_PATH}/${MEDCoupling_DirName}/${MEDCoupling_DirName}-sources)
    # MEDCoupling install directory
    set(MEDCoupling_INSTALL_DIR ${THIRD_PARTY_PATH}/${MEDCoupling_DirName}/${MEDCoupling_DirName}-install)

    # where to find MEDCoupling
    set(MEDCOUPLING_ROOT_DIR ${MEDCoupling_INSTALL_DIR})
    set(MEDCOUPLING_LIBS_DIR ${MEDCOUPLING_ROOT_DIR}/lib)
    set(MEDCoupling_DIR ${MEDCoupling_INSTALL_DIR}/cmake_files)
    find_package(LocalMEDCoupling)

    if (NOT MEDCoupling_FOUND)
        set(MEDCOUPLING_URL "")
        if (NOT USE_LOCAL_THIRD_PARTY)
            set(MEDCOUPLING_URL "https://cae-static-1252829527.cos.ap-shanghai.myqcloud.com/CloudCAE/ARes/ARM_MEDCOUPLING-9.8.1.tgz")
        else ()
            set(MEDCOUPLING_URL file://${THIRD_PARTY_PATH}/MEDCOUPLING-9.8.1.tgz)
        endif ()

        set(MEDCOUPLING_DEPENDS "")
        if (NOT HDF5_FOUND)
            list(APPEND MEDCOUPLING_DEPENDS ${HDF5_DirName})
        endif ()
        if (NOT MEDFile_FOUND)
            list(APPEND MEDCOUPLING_DEPENDS ${MEDFile_DirName})
        endif ()
        if (NOT OpenMPI_FOUND AND BUILD_WITH_PARALLEL)
            list(APPEND MEDCOUPLING_DEPENDS ${OpenMPI_DirName})
        endif ()

        include(ExternalProject)
        ExternalProject_Add(
                ${MEDCoupling_DirName}
                PREFIX ${MEDCoupling_SOURCES_DIR}
                DEPENDS ${MEDCOUPLING_DEPENDS}
                URL ${MEDCOUPLING_URL}

                CMAKE_ARGS -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
                CMAKE_ARGS -DMEDCOUPLING_BUILD_STATIC=${BUILD_WITH_STATIC}
                CMAKE_ARGS -DMEDCOUPLING_MICROMED=OFF
                CMAKE_ARGS -DMEDCOUPLING_ENABLE_PYTHON=OFF
                CMAKE_ARGS -DMEDCOUPLING_USE_MPI:BOOL=${BUILD_WITH_PARALLEL}
                CMAKE_ARGS -DSALOME_USE_MPI=${BUILD_WITH_PARALLEL}
                CMAKE_ARGS -DMPI_ROOT_DIR=${MPI_HOME}
                CMAKE_ARGS -DMEDCOUPLING_ENABLE_PARTITIONER=OFF
                CMAKE_ARGS -DMEDCOUPLING_ENABLE_RENUMBER=OFF
                CMAKE_ARGS -DMEDCOUPLING_WITH_FILE_EXAMPLES=OFF
                CMAKE_ARGS -DMEDCOUPLING_BUILD_TESTS=OFF
                CMAKE_ARGS -DMEDCOUPLING_BUILD_DOC=OFF
                CMAKE_ARGS -DMEDCOUPLING_USE_64BIT_IDS=ON
                CMAKE_ARGS -DCONFIGURATION_ROOT_DIR:PATH=${MEDCoupling_SOURCES_DIR}/src/${MEDCoupling_DirName}/CONFIGURATION/
                CMAKE_ARGS -DHDF5_ROOT_DIR=${HDF5_ROOT_DIR}
                CMAKE_ARGS -DMEDFILE_ROOT_DIR=${MEDFILE_ROOT_DIR}
                CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${MEDCoupling_INSTALL_DIR}
                BUILD_COMMAND ${CompileCPUMax_MakeCommand}
                INSTALL_DIR ${MEDCoupling_INSTALL_DIR}
                ${EXTERNAL_PROJECT_LOG_ARGS}
        )

        ExternalProject_Get_Property(${MEDCoupling_DirName} INSTALL_DIR)
        # set(MEDCoupling_INCLUDE_DIR )

        # set(MEDCoupling_LIBRARY )
        # todo MEDCoupling_LIBRARIES Set Error
        # List(APPEND MEDCoupling_LIBRARY ${INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}medcoupling${CMAKE_STATIC_LIBRARY_SUFFIX})
        # List(APPEND MEDCoupling_LIBRARY ${INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}medloader${CMAKE_STATIC_LIBRARY_SUFFIX})

        # FIND_PACKAGE_HANDLE_STANDARD_ARGS(${MEDCoupling_DirName} DEFAULT_MSG
        #         MEDCoupling_INCLUDE_DIR MEDCoupling_LIBRARY
        #         )

        set(MEDCOUPLING_LIBRARIES ${INSTALL_DIR}/lib)
        set(MEDCOUPLING_INCLUDE_DIRS ${INSTALL_DIR}/include)

        mark_as_advanced(MEDCOUPLING_LIBRARIES MEDCOUPLING_INCLUDE_DIRS)

        list(APPEND PROJECT_EXTERNAL_DEPENDENCIES ${MEDCoupling_DirName})
    endif ()

endif ()

