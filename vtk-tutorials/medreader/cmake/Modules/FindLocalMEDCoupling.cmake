# - Find MEDCoupling
# Find the MEDCoupling includes and library
# MEDCOUPLING_ROOT_DIR - ROOT of MEDCoupling library
# MEDCOUPLING_INCLUDE_DIRS - where to find MEDCoupling.hxx
# MEDCOUPLING_LIBRARIES - List of libraries when using MEDCoupling.
# MEDCOUPLING_FOUND - True if MEDCoupling found.

# Detect headers directory
FIND_PATH(MEDCOUPLING_INCLUDE_DIRS MEDCoupling.hxx HINTS ${MEDCOUPLING_ROOT_DIR}/include)
# --

# Detect libraries
SET(MEDCOUPLING_LIBRARIES "")

FIND_LIBRARY(MEDCOUPLING_LIBRARY_medcoupling NAMES medcoupling HINTS ${MEDCOUPLING_ROOT_DIR}/lib)
IF (MEDCOUPLING_LIBRARY_medcoupling)
    LIST(APPEND MEDCOUPLING_LIBRARIES "${MEDCOUPLING_LIBRARY_medcoupling}")
ENDIF ()

FIND_LIBRARY(MEDCOUPLING_LIBRARY_medloader NAMES medloader HINTS ${MEDCOUPLING_ROOT_DIR}/lib)
IF (MEDCOUPLING_LIBRARY_medloader)
    LIST(APPEND MEDCOUPLING_LIBRARIES "${MEDCOUPLING_LIBRARY_medloader}")
ENDIF ()

FIND_LIBRARY(MEDCOUPLING_LIBRARY_interpkernel NAMES interpkernel HINTS ${MEDCOUPLING_ROOT_DIR}/lib)
IF (MEDCOUPLING_LIBRARY_interpkernel)
    LIST(APPEND MEDCOUPLING_LIBRARIES "${MEDCOUPLING_LIBRARY_interpkernel}")
ENDIF ()

FIND_LIBRARY(MEDCOUPLING_LIBRARY_medcouplingremapper NAMES medcouplingremapper HINTS ${MEDCOUPLING_ROOT_DIR}/lib)
IF (MEDCOUPLING_LIBRARY_medcouplingremapper)
    LIST(APPEND MEDCOUPLING_LIBRARIES "${MEDCOUPLING_LIBRARY_medcouplingremapper}")
ENDIF ()

FIND_LIBRARY(MEDCOUPLING_LIBRARY_medicoco NAMES medicoco HINTS ${MEDCOUPLING_ROOT_DIR}/lib)
IF (MEDCOUPLING_LIBRARY_medicoco)
    LIST(APPEND MEDCOUPLING_LIBRARIES "${MEDCOUPLING_LIBRARY_medicoco}")
ENDIF ()

INCLUDE(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(${MEDCoupling_DirName} REQUIRED_VARS MEDCOUPLING_INCLUDE_DIRS MEDCOUPLING_LIBRARY_medcoupling
        MEDCOUPLING_LIBRARY_medloader MEDCOUPLING_LIBRARY_interpkernel MEDCOUPLING_LIBRARY_medcouplingremapper MEDCOUPLING_LIBRARY_medicoco)

if (MEDCoupling_FOUND)
    find_package(MEDCoupling NO_MODULE)

    if (BUILD_WITH_PARALLEL)
        SET(MEDCOUPLING_LIBRARIES interpkernel medcouplingcpp medcouplingremapper medicoco medloader paramedmem paramedloader)
    else ()
        SET(MEDCOUPLING_LIBRARIES interpkernel medcouplingcpp medcouplingremapper medicoco medloader)
    endif ()

    mark_as_advanced(MEDCOUPLING_LIBRARIES MEDCOUPLING_INCLUDE_DIRS)
ENDIF ()