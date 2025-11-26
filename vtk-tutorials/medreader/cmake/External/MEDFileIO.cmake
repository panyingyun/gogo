if (NOT __MEDFILEIO_INCLUDED)
    set(__MEDFILEIO_INCLUDED TRUE)

    # MEDFILEIO build directory
    SET(MEDFILEIO_SOURCES_DIR ${THIRD_PARTY_PATH}/${MEDFileIO_DirName}/${MEDFileIO_DirName}-sources)
    # MEDFILEIO install directory
    set(MEDFILEIO_INSTALL_DIR ${THIRD_PARTY_PATH}/${MEDFileIO_DirName}/${MEDFileIO_DirName}-install)

    set(MEDFILEIO_ROOT_DIR ${MEDFILEIO_INSTALL_DIR})
    set(MEDFileIO_DIR ${MEDFILEIO_ROOT_DIR}/cmake_files)
    set(MEDFILEIO_LIBS_DIR ${MEDFILEIO_ROOT_DIR}/lib)
    find_package(LocalMEDFileIO)

    if (NOT MEDFileIO_FOUND)
        set(MEDFILEIO_URL "")

        if (NOT USE_LOCAL_THIRD_PARTY)
            set(MEDFILEIO_URL "https://cae-static-1252829527.cos.ap-shanghai.myqcloud.com/CloudCAE/ARes/MEDFileIO-9.8-MPI2.tar.gz")
        else ()
            set(MEDFILEIO_URL file://${THIRD_PARTY_PATH}/MEDFileIO-9.8-MPI2.tar.gz)
        endif ()

        set(MEDFILEIO_DEPENDS "")
        if (NOT HDF5_FOUND)
            list(APPEND MEDFILEIO_DEPENDS ${HDF5_DirName})
        endif ()

        if (NOT MEDFile_FOUND)
            list(APPEND MEDFILEIO_DEPENDS ${MEDFile_DirName})
        endif ()

        if (NOT MEDCoupling_FOUND)
            list(APPEND MEDFILEIO_DEPENDS ${MEDCoupling_DirName})
        endif ()

        if (NOT ParaView_FOUND)
            list(APPEND MEDFILEIO_DEPENDS ${ParaView_DirName})
        endif ()

        if (NOT OpenMPI_FOUND AND BUILD_WITH_PARALLEL)
            list(APPEND MEDFILEIO_DEPENDS ${OpenMPI_DirName})
        endif ()

        include(ExternalProject)
        ExternalProject_Add(
                ${MEDFileIO_DirName}
                PREFIX ${MEDFILEIO_SOURCES_DIR}
                DEPENDS ${MEDFILEIO_DEPENDS} # ${MEDFile_DirName} ${MEDCoupling_DirName} ${ParaView_DirName} # ${ZLib_DirName}
                URL ${MEDFILEIO_URL}
                CMAKE_ARGS -DMEDFILEIO_BUILD_STATIC=${BUILD_WITH_STATIC}
                CMAKE_ARGS -DMEDFILEIO_MICROMED=OFF
                CMAKE_ARGS -DMEDFILEIO_WITH_FILE_EXAMPLES=OFF
                CMAKE_ARGS -DMEDFILEIO_BUILD_TESTS=OFF
                CMAKE_ARGS -DMEDFILEIO_BUILD_DOC=OFF
                CMAKE_ARGS -DMEDFILEIO_USE_MPI:BOOL=${BUILD_WITH_PARALLEL}
                CMAKE_ARGS -DSALOME_USE_MPI=${BUILD_WITH_PARALLEL}
                CMAKE_ARGS -DMPI_ROOT_DIR=${MPI_HOME}
                CMAKE_ARGS -DHDF5_ROOT_DIR=${HDF5_ROOT_DIR}
                CMAKE_ARGS -DHDF5_ROOT=${HDF5_ROOT_DIR}
                CMAKE_ARGS -DMEDFILE_ROOT_DIR=${MEDFILE_ROOT_DIR}
                CMAKE_ARGS -DMEDCOUPLING_ROOT_DIR:PATH=${MEDCOUPLING_ROOT_DIR}
                CMAKE_ARGS -DParaView_DIR:PATH=${ParaView_DIR}
                CMAKE_ARGS -DVTK_DIR:PATH=${VTK_DIR}
                CMAKE_ARGS -DCONFIGURATION_ROOT_DIR:PATH=${MEDCoupling_SOURCES_DIR}/src/${MEDCoupling_DirName}/CONFIGURATION/
                CMAKE_ARGS -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
                CMAKE_ARGS -DCMAKE_INSTALL_PREFIX:PATH=${MEDFILEIO_INSTALL_DIR}
                BUILD_COMMAND ${CompileCPUMax_MakeCommand}
                INSTALL_DIR ${MEDFILEIO_INSTALL_DIR}
                ${EXTERNAL_PROJECT_LOG_ARGS}
        )

        ExternalProject_Get_Property(${MEDFileIO_DirName} INSTALL_DIR)

        set(MEDFILEIO_INCLUDE_DIR ${INSTALL_DIR}/include)
        set(MEDFILEIO_LIBRARY "")

        List(APPEND MEDFILEIO_LIBRARY ${INSTALL_DIR}/lib/${LIBRARY_PREFIX}medloaderForPV${LIBRARY_SUFFIX})
        List(APPEND MEDFILEIO_LIBRARY ${INSTALL_DIR}/lib/${LIBRARY_PREFIX}medreaderIO${LIBRARY_SUFFIX})
        List(APPEND MEDFILEIO_LIBRARY ${INSTALL_DIR}/lib/${LIBRARY_PREFIX}medwriterIO${LIBRARY_SUFFIX})


        set(MEDFILEIO_LIBRARYS ${MEDFILEIO_LIBRARY})
        set(MEDFILEIO_INCLUDE_DIRS ${MEDFILEIO_INCLUDE_DIR})


        list(APPEND PROJECT_EXTERNAL_DEPENDENCIES ${MEDFileIO_DirName})
    endif ()

endif ()

