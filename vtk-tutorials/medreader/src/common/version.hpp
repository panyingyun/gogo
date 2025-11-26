#pragma once

// for cmake
#define PROJECT_VER_MAJOR 5
#define PROJECT_VER_MINOR 3
#define PROJECT_VER_PATCH 8

#define PROJECT_VERSION (PROJECT_VER_MAJOR * 10000 + PROJECT_VER_MINOR * 100 + PROJECT_VER_PATCH)

#define PROJECT_DEPS_VER_MAJOR 4
#define PROJECT_DEPS_VER_MINOR 0

// for source code
#define _PROJECT_STR(s) #s
#define PROJECT_VERSION_STR(major, minor, patch) "v" _PROJECT_STR(major.minor.patch)
