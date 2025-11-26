# - Find HDF5
# Find the HDF5 includes and library
# HDF5_ROOT_DIR - ROOT of HDF5 library
# HDF5_INCLUDE_DIRS - where to find HDF5.h.
# HDF5_LIBRARIES - List of libraries when using HDF5.
# HDF5_FOUND - True if HDF5 found.

find_path(HDF5_INCLUDE_DIRS
        NAMES hdf5.h
        HINTS ${HDF5_ROOT_DIR}/include)

find_library(HDF5_LIBRARIES
        NAMES hdf5
        HINTS ${HDF5_ROOT_DIR}/lib)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(${HDF5_DirName} DEFAULT_MSG HDF5_LIBRARIES HDF5_INCLUDE_DIRS)

if (HDF5_FOUND)
    if (BUILD_WITH_STATIC)
        set(LIB_TYPE STATIC)
        set(HDF5_USE_STATIC_LIBRARIES ON)
    else ()
        set(LIB_TYPE SHARED)
        set(HDF5_USE_STATIC_LIBRARIES OFF)
    endif ()
    string(TOLOWER ${LIB_TYPE} SEARCH_TYPE)

    find_package(HDF5 NAMES hdf5 COMPONENTS C CXX ${SEARCH_TYPE} NO_MODULE)

    set(HDF5_LIBRARIES ${HDF5_C_${LIB_TYPE}_LIBRARY} ${HDF5_CXX_${LIB_TYPE}_LIBRARY})
    set(HDF5_INCLUDE_DIRS ${HDF5_INCLUDE_DIR})

    mark_as_advanced(HDF5_LIBRARIES HDF5_INCLUDE_DIRS)
ENDIF ()

