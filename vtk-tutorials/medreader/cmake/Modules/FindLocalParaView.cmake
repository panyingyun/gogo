# - Find ParaView
# Find the ParaView includes and library
# PARAVIEW_ROOT_DIR - ROOT of ParaView library
# PARAVIEW_INCLUDE_DIRS - where to find ParaView.h.
# PARAVIEW_LIBRARIES - List of libraries when using ParaView.
# PARAVIEW_FOUND - True if ParaView found.

find_path(PARAVIEW_INCLUDE_DIRS
        NAMES vtkPointSet.h
        HINTS ${PARAVIEW_ROOT_DIR}/include/paraview-${PARAVIEW_VERSION}
        NO_DEFAULT_PATH)

find_library(PARAVIEW_LIBRARIES
        NAMES vtkFiltersCore-pv${PARAVIEW_VERSION}
        HINTS ${PARAVIEW_LIBS_DIR}
        NO_DEFAULT_PATH)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(${ParaView_DirName} DEFAULT_MSG PARAVIEW_LIBRARIES PARAVIEW_INCLUDE_DIRS)

if (ParaView_FOUND)
    find_package(ParaView COMPONENTS
            cgns
            VTKExtensionsCGNSWriter
            VTKExtensionsCGNSReader
            vtkPVVTKExtensionsCGNSWriterCS
            vtkPVVTKExtensionsCGNSReaderCS
            vtkPVVTKExtensionsMiscCS
            vtkIOVisItBridgeCS
            # VTKExtensionsFiltersRendering
            # RemotingCore
            NO_MODULE NO_DEFAULT_PATH)

    set(PARAVIEW_LIBRARIES ${ParaView_LIBRARIES})

    mark_as_advanced(PARAVIEW_LIBRARIES PARAVIEW_INCLUDE_DIRS VTK_LIBRARIES VTK_INCLUDE_DIRS)

ENDIF ()