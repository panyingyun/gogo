if (NOT __OpenMPI_INCLUDED)
    set(__OpenMPI_INCLUDED TRUE)

    # OpenMPI build directory
    set(OPENMPI_SOURCES_DIR ${THIRD_PARTY_PATH}/${OpenMPI_DirName}/${OpenMPI_DirName}-sources)
    # OpenMPI install directory
    set(OPENMPI_INSTALL_DIR ${THIRD_PARTY_PATH}/${OpenMPI_DirName}/${OpenMPI_DirName}-install)

    # where to find OpenMPI
    set(OPENMPI_ROOT_DIR ${OPENMPI_INSTALL_DIR})
    set(MPI_HOME ${OPENMPI_ROOT_DIR})
    find_package(LocalOpenMPI)

    if (NOT OpenMPI_FOUND)
        set(OpenMPI_URL "")
        if (NOT USE_LOCAL_THIRD_PARTY)
            set(OpenMPI_URL "https://cae-static-1252829527.cos.ap-shanghai.myqcloud.com/CloudCAE/ARes/openmpi-4.1.4.tar.gz")
        else ()
            set(OpenMPI_URL file://${THIRD_PARTY_PATH}/openmpi-4.1.4.tar.gz)
        endif ()

        set(OpenMPI_DEPENDS "")

        if (BUILD_WITH_STATIC)
            set(OPENMPI_BUILD_MODE "--enable-shared=no --enable-static=yes")
        else ()
            set(OPENMPI_BUILD_MODE "")
        endif ()

        include(ExternalProject)
        ExternalProject_Add(
                ${OpenMPI_DirName}
                PREFIX ${OPENMPI_SOURCES_DIR}
                DEPENDS ${OpenMPI_DEPENDS}
                URL ${OpenMPI_URL}
                CONFIGURE_COMMAND <SOURCE_DIR>/configure --prefix=${OPENMPI_INSTALL_DIR} ${OPENMPI_BUILD_MODE} #--enable-mpi1-compatibility
                BUILD_COMMAND ${CompileCPUMax_MakeCommand}
                INSTALL_COMMAND make install
                INSTALL_DIR ${OPENMPI_INSTALL_DIR}
                ${EXTERNAL_PROJECT_LOG_ARGS}
        )

        ExternalProject_Get_Property(${OpenMPI_DirName} INSTALL_DIR)

        set(MPI_INCLUDE_DIRS ${INSTALL_DIR}/include)
        set(MPI_LIBRARIES ${INSTALL_DIR}/lib/${LIBRARY_PREFIX}mpi${LIBRARY_SUFFIX})

        list(APPEND PROJECT_EXTERNAL_DEPENDENCIES ${OpenMPI_DirName})
    endif ()

endif ()

