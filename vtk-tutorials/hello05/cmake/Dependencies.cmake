set(CompileCPUMax_MakeCommand make -j8)
message(${CompileCPUMax_MakeCommand})

# ---[ Threads
find_package(Threads REQUIRED)
list(APPEND PProcess_LINKER_LIBS PUBLIC pthread)

# ---[ Google-GFlags
set(GFlags_DirName "GFlags")
include(${CMAKE_EXTERNAL_PATH}/gflags.cmake)
list(APPEND PProcess_INCLUDE_DIRS PUBLIC ${GFLAGS_INCLUDE_DIRS})
list(APPEND PProcess_LINKER_LIBS PUBLIC ${GFLAGS_LIBRARIES})

# ---[ Google-Glog
set(Glog_DirName "Glog")
include(${CMAKE_EXTERNAL_PATH}/glog.cmake)
list(APPEND PProcess_INCLUDE_DIRS PUBLIC ${GLOG_INCLUDE_DIRS})
list(APPEND PProcess_LINKER_LIBS PUBLIC ${GLOG_LIBRARIES})

# ---[VTK
set(VTK_DIR "/opt/thirdpart/vtk/lib/cmake/vtk-8.2")
find_package(VTK REQUIRED)
include(${VTK_USE_FILE})
list(APPEND PProcess_INCLUDE_DIRS ${VTK_INCLUDE_DIRS})
list(APPEND PProcess_LINKER_LIBS ${VTK_LIBRARIES})

message(STATUS "VTK_FOUND: ${VTK_FOUND}")
message(STATUS "VTK_INCLUDE_DIRS: ${VTK_INCLUDE_DIRS}")
message(STATUS "VTK_LIBRARY_DIRS: ${VTK_LIBRARY_DIRS}")
message(STATUS "VTK_LIBRARY_DIRS: ${VTK_LIBRARY_DIRS}")
message(STATUS "VTK_USE_FILE: ${VTK_USE_FILE}")
message(STATUS "VTK_LIBRARIES: ${VTK_LIBRARIES}")