# - Find GFLAGS
# Find the GFLAGS includes and library
# GFLAGS_ROOT_DIR - ROOT of GFLAGS library
# GFLAGS_INCLUDE_DIRS - where to find logging.h
# GFLAGS_LIBRARIES - List of libraries when using GFLAGS.
# GFLAGS_FOUND - True if GFLAGS found.

set(GFLAGS_FOUND False)
find_path(GFLAGS_INCLUDE_DIRS
  NAMES gflags/gflags.h
  HINTS ${GFLAGS_ROOT_DIR}/include)

find_library(GFLAGS_LIBRARIES
  NAMES libgflags.a
  HINTS ${GFLAGS_ROOT_DIR}/lib)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(gflags DEFAULT_MSG GFLAGS_LIBRARIES GFLAGS_INCLUDE_DIRS)

mark_as_advanced(
  GFLAGS_LIBRARIES
  GFLAGS_INCLUDE_DIRS)

if(GFLAGS_LIBRARIES AND GFLAGS_INCLUDE_DIRS)
	set(GFLAGS_FOUND True)
	message("GFLAGS_INCLUDE_DIRS: " ${GFLAGS_INCLUDE_DIRS})
	message("GFLAGS_LIBRARYS: " ${GFLAGS_LIBRARIES})
elseif()
	message("GFLAGS NOT FIND")
endif()