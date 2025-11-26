# - Find OPENMPI
# Find the OPENMPI include and library
# OPENMPI_ROOT_DIR - ROOT of OPENMPI library
# OPENMPI_INCLUDE_DIRS - where to find OPENMPI.h
# OPENMPI_LIBRARIES - List of libraries when using OPENMPI
# OPENMPI_FOUND - True if OPENMPI found.

find_path(OPENMPI_INCLUDE_DIRS
        NAMES mpi.h
        HINTS ${OPENMPI_ROOT_DIR}/include
		NO_DEFAULT_PATH)

find_library(OPENMPI_LIBRARIES
        NAMES mpi
        HINTS ${OPENMPI_ROOT_DIR}/lib
		NO_DEFAULT_PATH)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(${OpenMPI_DirName} DEFAULT_MSG OPENMPI_LIBRARIES OPENMPI_INCLUDE_DIRS)

if (OpenMPI_FOUND)
	FIND_PACKAGE(MPI)

	SET(MPI_INCLUDE_DIRS ${MPI_C_INCLUDE_PATH} ${MPI_CXX_INCLUDE_PATH})
	SET(MPI_LIBRARIES ${MPI_C_LIBRARIES} ${MPI_CXX_LIBRARIES})
endif ()


