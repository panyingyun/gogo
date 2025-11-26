if (NOT __MEDFILE_INCLUDED)
    set(__MEDFILE_INCLUDED TRUE)

    # MEDFile build directory
    SET(MEDFILE_SOURCES_DIR ${THIRD_PARTY_PATH}/${MEDFile_DirName}/${MEDFile_DirName}-sources)
    # MEDFile install directory
    SET(MEDFILE_INSTALL_DIR ${THIRD_PARTY_PATH}/${MEDFile_DirName}/${MEDFile_DirName}-install)

    # where to find MEDFile
    SET(MEDFILE_ROOT_DIR ${MEDFILE_INSTALL_DIR})
    SET(MEDFILE_LIBS_DIR ${MEDFILE_ROOT_DIR}/lib)
    SET(MEDFile_DIR ${MEDFILE_INSTALL_DIR}/share/cmake/medfile-4.1.1)
    find_package(LocalMEDFile)

    if (NOT MEDFile_FOUND)
        set(MEDFILE_URL "")
        if (NOT USE_LOCAL_THIRD_PARTY)
            set(MEDFILE_URL "https://cae-static-1252829527.cos.ap-shanghai.myqcloud.com/CloudCAE/ARes/med-4.1.1.tar.gz")
        else ()
            set(MEDFILE_URL file://${THIRD_PARTY_PATH}/med-4.1.1.tar.gz)
        endif ()

        set(MEDFILE_DEPENDS "")
        if (NOT HDF5_FOUND)
            list(APPEND MEDFILE_DEPENDS ${HDF5_DirName})
        endif ()
        if (NOT OpenMPI_FOUND AND BUILD_WITH_PARALLEL)
            list(APPEND MEDFILE_DEPENDS ${OpenMPI_DirName})
        endif ()

        set(MEDFILE_FFLAGS "-fdefault-integer-8  -g -O2 -ffixed-line-length-none")
        set(MEDFILE_CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} ${MEDFILE_FFLAGS}")

        # if (BUILD_WITH_PARALLEL)
        #     set(MEDFILE_CMAKE_C_FLAGS "-m64") #${MPI_C_COMPILER}
        #     set(MEDFILE_CMAKE_CXX_FLAGS "-m64") #${MPI_CXX_COMPILER}
        # else()
        #     set(MEDFILE_CMAKE_C_FLAGS "-m64") #${CMAKE_C_FLAGS}
        #     set(MEDFILE_CMAKE_CXX_FLAGS "-m64") #${CMAKE_CXX_FLAGS}
        # endif ()

        include(ExternalProject)
        ExternalProject_Add(
                ${MEDFile_DirName}
                PREFIX ${MEDFILE_SOURCES_DIR}
                DEPENDS ${MEDFILE_DEPENDS}
                URL ${MEDFILE_URL}

                CMAKE_ARGS -DHDF5_ROOT_DIR=${HDF5_ROOT_DIR}
                CMAKE_ARGS -DMEDFILE_BUILD_SHARED_LIBS=${BUILD_SHARED_LIBS}
                CMAKE_ARGS -DMEDFILE_BUILD_STATIC_LIBS=${BUILD_WITH_STATIC}
                CMAKE_ARGS -DMEDFILE_BUILD_PYTHON=OFF
                CMAKE_ARGS -DMEDFILE_BUILD_TESTS=OFF
                CMAKE_ARGS -DMEDFILE_INSTALL_DOC=OFF
                CMAKE_ARGS -DMEDFILE_USE_MPI=${BUILD_WITH_PARALLEL}
                CMAKE_ARGS -DMPI_ROOT_DIR=${MPI_HOME}
                CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${MEDFILE_INSTALL_DIR}
                CMAKE_ARGS -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
                INSTALL_DIR ${MEDFILE_INSTALL_DIR}
        )

        ExternalProject_Get_Property(${MEDFile_DirName} INSTALL_DIR)

        set(MEDFILE_INCLUDE_DIR ${INSTALL_DIR}/include)
        set(MEDFILE_LIBRARIES ${INSTALL_DIR}/lib/${LIBRARY_PREFIX}medC${LIBRARY_SUFFIX})

        # FIND_PACKAGE_HANDLE_STANDARD_ARGS(${MEDFile_DirName} DEFAULT_MSG
        #         MEDFILE_INCLUDE_DIR MEDFILE_LIBRARY
        #         )

        set(MEDFILE_LIBRARIES ${MEDFILE_LIBRARY})
        set(MEDFILE_INCLUDE_DIRS ${MEDFILE_INCLUDE_DIR})

        mark_as_advanced(MEDFILE_LIBRARIES MEDFILE_INCLUDE_DIRS)

        list(APPEND PROJECT_EXTERNAL_DEPENDENCIES ${MEDFile_DirName})
    endif ()

endif ()

