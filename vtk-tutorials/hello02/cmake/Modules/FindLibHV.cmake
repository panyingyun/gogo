# - Find LibHV
# Find the LibHV includes and library
# LIBHV_ROOT_DIR - ROOT of LibHV library
# LIBHV_INCLUDE_DIRS - where to find LibHV.h.
# LIBHV_LIBRARIES - List of libraries when using LibHV.
# LIBHV_FOUND - True if LibHV found.

find_path(LIBHV_INCLUDE_DIRS
        NAMES hv/hv.h
        HINTS ${LIBHV_ROOT_DIR}/include)

set(LIBHV_LIB_NAME "hv_static")

find_library(LIBHV_LIBRARIES
        NAMES ${LIBHV_LIB_NAME}
        HINTS ${LIBHV_ROOT_DIR}/lib)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(LibHV DEFAULT_MSG LIBHV_LIBRARIES LIBHV_INCLUDE_DIRS)

mark_as_advanced(
        LIBHV_LIBRARIES
        LIBHV_INCLUDE_DIRS)
