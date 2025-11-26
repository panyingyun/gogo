# - Find VTK
# Find the VTK includes and library
# VTK_ROOT_DIR - ROOT of VTK library
# VTK_INCLUDE_DIRS - where to find VTK.h.
# VTK_LIBRARIES - List of libraries when using VTK.
# VTK_FOUND - True if VTK found.

find_path(VTK_INCLUDE_DIRS_LOCAL
        NAMES vtkActor.h
        HINTS ${VTK_ROOT_DIR}/include/vtk-${VTK_VERSION})

find_library(VTK_LIBRARIES_LOCAL
        NAMES vtkCommonMath-${VTK_VERSION}
        HINTS ${VTK_ROOT_DIR}/lib)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(${VTK_DirName} DEFAULT_MSG VTK_LIBRARIES_LOCAL VTK_INCLUDE_DIRS_LOCAL)

if (VTK_FOUND)
    find_package(VTK NO_MODULE)
    #message(STATUS "VTK_LIBRARIES: ${VTK_LIBRARIES}")

    vtk_module_autoinit(
            TARGETS ${PROJECT_NAME}
            MODULES ${VTK_LIBRARIES}
    )

    mark_as_advanced(VTK_LIBRARIES VTK_INCLUDE_DIRS)
ENDIF ()