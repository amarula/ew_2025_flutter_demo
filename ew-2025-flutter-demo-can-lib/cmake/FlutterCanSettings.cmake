# Build the library with C++17 standard support, independent from other
# including software which may use a different CXX_STANDARD or
# CMAKE_CXX_STANDARD.
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# ---------------------------------------------------------------------------
# Ensure that CMAKE_BUILD_TYPE has a value specified for single configuration
# generators.
# ---------------------------------------------------------------------------
if(NOT DEFINED CMAKE_BUILD_TYPE AND NOT DEFINED CMAKE_CONFIGURATION_TYPES)
  set(CMAKE_BUILD_TYPE
      Release
      CACHE
        STRING
        "Choose the type of build, options are: Debug Release RelWithDebInfo MinSizeRel."
  )
endif()

# ---------------------------------------------------------------------------
# use ccache if found, has to be done before project()
# ---------------------------------------------------------------------------
find_program(CCACHE_EXECUTABLE "ccache" HINTS /usr/local/bin /opt/local/bin)
if(CCACHE_EXECUTABLE)
  message(STATUS "use ccache")
  set(CMAKE_CXX_COMPILER_LAUNCHER
      "${CCACHE_EXECUTABLE}"
      CACHE PATH "ccache" FORCE)
  set(CMAKE_C_COMPILER_LAUNCHER
      "${CCACHE_EXECUTABLE}"
      CACHE PATH "ccache" FORCE)
endif()

# ---------------------------------------------------------------------------
# Include some utility
# ---------------------------------------------------------------------------
include(FetchContent)
