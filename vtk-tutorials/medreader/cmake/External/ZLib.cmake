if (NOT __ZLIB_INCLUDED)
    set(__ZLIB_INCLUDED TRUE)

    # Zlib build directory
    set(ZLIB_SOURCES_DIR ${THIRD_PARTY_PATH}/${ZLib_DirName}/${ZLib_DirName}-sources)
    # Zlib install directory
    set(ZLIB_INSTALL_DIR ${THIRD_PARTY_PATH}/${ZLib_DirName}/${ZLib_DirName}-install)

    # where to find Freetype
    set(ZLIB_ROOT_DIR ${ZLIB_INSTALL_DIR})
    find_package(LocalZLIB)

    if (NOT ZLIB_FOUND)
        set(ZLIB_URL "")
        if (NOT USE_LOCAL_THIRD_PARTY)
            set(ZLIB_URL "https://cae-static-1252829527.cos.ap-shanghai.myqcloud.com/CloudCAE/ARes/zlib-1.2.12-Modify.zip")
        else ()
            set(ZLIB_URL file://${THIRD_PARTY_PATH}/zlib-1.2.12-Modify.zip)
        endif ()


        include(ExternalProject)
        ExternalProject_Add(${ZLib_DirName}
                PREFIX ${ZLIB_SOURCES_DIR}
                URL ${ZLIB_URL} # file://${THIRD_PARTY_PATH}/zlib-1.2.12-Modify.zip

                CMAKE_ARGS -DBUILD_SHARED_LIBS=${BUILD_SHARED_LIBS}
                CMAKE_ARGS -DBUILD_EXAMPLES=OFF
                CMAKE_ARGS -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
                CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${ZLIB_INSTALL_DIR}
                BUILD_COMMAND ${CompileCPUMax_MakeCommand}
                INSTALL_DIR ${ZLIB_INSTALL_DIR}
                ${EXTERNAL_PROJECT_LOG_ARGS}
                )

        ExternalProject_Get_Property(${ZLib_DirName} INSTALL_DIR)

        set(ZLIB_INCLUDE_DIRS ${INSTALL_DIR}/include)

        set(ZLIB_LIB_NAME "z")
        set(ZLIB_LIBRARIES ${INSTALL_DIR}/lib/${LIBRARY_PREFIX} ${ZLIB_LIB_NAME} ${LIBRARY_SUFFIX})

        list(APPEND PROJECT_EXTERNAL_DEPENDENCIES ${ZLib_DirName})
    endif ()

endif ()

