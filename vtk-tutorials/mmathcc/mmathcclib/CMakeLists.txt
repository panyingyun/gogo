cmake_minimum_required(VERSION 3.11)

# The version number
set(MMATHCC_VERSION_MAJOR 2)
set(MMATHCC_VERSION_MINOR 76)
project(mmathcc VERSION "${MMATHCC_VERSION_MAJOR}.${MMATHCC_VERSION_MINOR}" LANGUAGES CXX)
set(PROJECT_NAMESPACE_NAME "MMathcc")
include(GNUInstallDirs)
include(CMakePackageConfigHelpers)
include(GenerateExportHeader)

add_library(${PROJECT_NAME} STATIC)
add_library(${PROJECT_NAMESPACE_NAME}::${PROJECT_NAME} ALIAS ${PROJECT_NAME})

list(APPEND SOURCES ${PROJECT_SOURCE_DIR}/mmathcc.cpp)

target_sources(${PROJECT_NAME} PRIVATE ${SOURCES}
        PUBLIC $<BUILD_INTERFACE:${CMAKE_CURRENT_LIST_DIR}/mmathcc.h>
        PUBLIC $<INSTALL_INTERFACE:include/mmathcc.h>
        )

target_include_directories(${PROJECT_NAME} 
        PUBLIC $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
        PUBLIC $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>
        PUBLIC $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
        )   

#install lib and include   
set(ConfigPackageLocation "${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAMESPACE_NAME}")

# 'make install' to the correct locations (provided by GNUInstallDirs).
install(TARGETS ${PROJECT_NAME}
    EXPORT ${PROJECT_NAMESPACE_NAME}Targets
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR} COMPONENT Library
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR} COMPONENT Library
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}  COMPONENT Library # This is for Windows
    PUBLIC_HEADER DESTINATION ${CMAKE_INSTALL_INCLUDEDIR} COMPONENT Development
    INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
    )

install(FILES ${CMAKE_CURRENT_LIST_DIR}/mmathcc.h DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

install(EXPORT ${PROJECT_NAMESPACE_NAME}Targets
  FILE
    ${PROJECT_NAMESPACE_NAME}Targets.cmake
  NAMESPACE
    ${PROJECT_NAMESPACE_NAME}::
  DESTINATION
    ${ConfigPackageLocation}
  COMPONENT
    Development
)


# generate the config file that is includes the exports
include(CMakePackageConfigHelpers)

configure_package_config_file(
    Config.cmake.in
    ${PROJECT_NAMESPACE_NAME}Config.cmake
    INSTALL_DESTINATION "${ConfigPackageLocation}"
    PATH_VARS CMAKE_INSTALL_PREFIX
    )

# generate the version file for the config file
write_basic_package_version_file(
    ${PROJECT_NAMESPACE_NAME}ConfigVersion.cmake
    VERSION "${MMATHCC_VERSION_MAJOR}.${MMATHCC_VERSION_MINOR}"
    COMPATIBILITY AnyNewerVersion
    )

install(
  FILES
    "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAMESPACE_NAME}Config.cmake"
    "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAMESPACE_NAME}ConfigVersion.cmake"
  DESTINATION
    ${ConfigPackageLocation}
  COMPONENT
    Development
)