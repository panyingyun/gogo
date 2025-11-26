# - Find ZLIB
# Find the ZLIB includes and library
# ZLIB_ROOT_DIR - ROOT of zlib library
# ZLIB_INCLUDE_DIRS - where to find zlib.h
# ZLIB_LIBRARIES - List of libraries when using ZLIB.
# ZLIB_FOUND - True if ZLIB found.

find_path(ZLIB_INCLUDE_DIR
        NAMES zlib.h
        HINTS ${ZLIB_ROOT_DIR}/include
        NO_DEFAULT_PATH)

find_library(ZLIB_LIBRARY
        NAMES z
        HINTS ${ZLIB_ROOT_DIR}/lib
        NO_DEFAULT_PATH)

if(ZLIB_INCLUDE_DIR AND EXISTS "${ZLIB_INCLUDE_DIR}/zlib.h")
    file(STRINGS "${ZLIB_INCLUDE_DIR}/zlib.h" ZLIB_H REGEX "^#define ZLIB_VERSION \"[^\"]*\"$")

    string(REGEX REPLACE "^.*ZLIB_VERSION \"([0-9]+).*$" "\\1" ZLIB_VERSION_MAJOR "${ZLIB_H}")
    string(REGEX REPLACE "^.*ZLIB_VERSION \"[0-9]+\\.([0-9]+).*$" "\\1" ZLIB_VERSION_MINOR  "${ZLIB_H}")
    string(REGEX REPLACE "^.*ZLIB_VERSION \"[0-9]+\\.[0-9]+\\.([0-9]+).*$" "\\1" ZLIB_VERSION_PATCH "${ZLIB_H}")
    set(ZLIB_VERSION_STRING "${ZLIB_VERSION_MAJOR}.${ZLIB_VERSION_MINOR}.${ZLIB_VERSION_PATCH}")

    # only append a TWEAK version if it exists:
    set(ZLIB_VERSION_TWEAK "")
    if( "${ZLIB_H}" MATCHES "ZLIB_VERSION \"[0-9]+\\.[0-9]+\\.[0-9]+\\.([0-9]+)")
        set(ZLIB_VERSION_TWEAK "${CMAKE_MATCH_1}")
        string(APPEND ZLIB_VERSION_STRING ".${ZLIB_VERSION_TWEAK}")
    endif()

    set(ZLIB_MAJOR_VERSION "${ZLIB_VERSION_MAJOR}")
    set(ZLIB_MINOR_VERSION "${ZLIB_VERSION_MINOR}")
    set(ZLIB_PATCH_VERSION "${ZLIB_VERSION_PATCH}")
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(ZLIB REQUIRED_VARS ZLIB_LIBRARY ZLIB_INCLUDE_DIR
        VERSION_VAR ZLIB_VERSION_STRING)

if (ZLIB_FOUND)
    if (NOT TARGET ZLIB::ZLIB)
        add_library(ZLIB::ZLIB UNKNOWN IMPORTED)
        set_target_properties(ZLIB::ZLIB PROPERTIES
                INTERFACE_INCLUDE_DIRECTORIES "${ZLIB_INCLUDE_DIR}")

        set_property(TARGET ZLIB::ZLIB APPEND PROPERTY
                IMPORTED_CONFIGURATIONS RELEASE)
        set_target_properties(ZLIB::ZLIB PROPERTIES
                IMPORTED_LOCATION_RELEASE "${ZLIB_LIBRARY}")
    endif ()

    set(ZLIB_LIBRARIES ZLIB::ZLIB)
    set(ZLIB_INCLUDE_DIRS ${ZLIB_INCLUDE_DIR})

    mark_as_advanced(ZLIB_INCLUDE_DIRS ZLIB_LIBRARIES)
ENDIF ()

