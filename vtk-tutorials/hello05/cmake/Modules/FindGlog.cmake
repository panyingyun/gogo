# - Find GLOG
# Find the GLOG includes and library
# GLOG_ROOT_DIR - ROOT of GLOG library
# GLOG_INCLUDE_DIRS - where to find logging.h
# GLOG_LIBRARIES - List of libraries when using GLOG.
# GLOG_FOUND - True if GLOG found.

set(GLOG_FOUND False)
find_path(GLOG_INCLUDE_DIRS
  NAMES glog/logging.h
  HINTS ${GLOG_ROOT_DIR}/include)

find_library(GLOG_LIBRARIES
  NAMES libglog.a
  HINTS ${GLOG_ROOT_DIR}/lib)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(glog DEFAULT_MSG GLOG_LIBRARIES GLOG_INCLUDE_DIRS)

mark_as_advanced(
  GLOG_LIBRARIES
  GLOG_INCLUDE_DIRS)

if(GLOG_LIBRARIES AND GLOG_INCLUDE_DIRS)
	set(GLOG_FOUND True)
	message("GLOG_INCLUDE_DIRS: " ${GLOG_INCLUDE_DIRS})
	message("GLOG_LIBRARYS: " ${GLOG_LIBRARIES})
elseif()
	message("GLOG NOT FIND")
endif()