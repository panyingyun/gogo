# - Find mmathc
# Find the mmathc includes and library
# MMATHCC_ROOT_DIR - ROOT of mmathc library
# MMATHCC_INCLUDE_DIR - where to find mmathc.h.
# MMATHCC_LIBRARIES - List of libraries when using mmathc.
# MMATHCC_FOUND - True if mmathc found.

find_path(MMATHCC_INCLUDE_DIR
  NAMES mmathcc.h
  HINTS ${MMATHCC_ROOT_DIR}/include)

find_library(MMATHCC_LIBRARIES
  NAMES mmathcc
  HINTS ${MMATHCC_ROOT_DIR}/lib)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(mmathcc DEFAULT_MSG MMATHCC_LIBRARIES MMATHCC_INCLUDE_DIR)

mark_as_advanced(
  MMATHCC_LIBRARIES
  MMATHCC_INCLUDE_DIR)

if(MMATHCC_FOUND AND NOT (TARGET mmathcc::mmathcc))
  add_library(mmathcc::mmathcc UNKNOWN IMPORTED)
  set_target_properties(mmathcc::mmathcc
    PROPERTIES
    IMPORTED_LOCATION "${MMATHCC_LIBRARIES}"
    INTERFACE_INCLUDE_DIRECTORIES "${MMATHCC_INCLUDE_DIRS}"
    )
endif()