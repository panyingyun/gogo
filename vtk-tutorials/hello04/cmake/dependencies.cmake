set(CompileCPUMax_MakeCommand make -j${CPU_CORES})
#message(${CompileCPUMax_MakeCommand})

# ---[ Threads
find_package(Threads REQUIRED)
#list(APPEND PProcess_LINKER_LIBS PUBLIC pthread)

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



