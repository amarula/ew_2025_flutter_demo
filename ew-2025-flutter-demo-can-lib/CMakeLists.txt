cmake_minimum_required(VERSION 3.14)

# setup directory where we should look for cmake files
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

include(FlutterCanSettings)

project(
  fluttercan
  VERSION 0.1.0
  LANGUAGES CXX)

message(
  STATUS
    "Fluttercan Version: ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}.${PROJECT_VERSION_PATCH}"
)

option(FLUTTERCAN_EXAMPLE "Build example." OFF)
option(FLUTTERCAN_SHARED "Build shared library" ON)
option(FLUTTERCAN_INSTALL "Enable project install" ON)

include(FlutterCanDependencies)

add_definitions(-DPROJECT_SOURCE_DIR=${PROJECT_SOURCE_DIR})

file(GLOB_RECURSE PROJECT_HEADERS "${CMAKE_CURRENT_SOURCE_DIR}/include/*.hpp")
file(GLOB_RECURSE PROJECT_SOURCES "${CMAKE_CURRENT_SOURCE_DIR}/source/*.cpp")

protobuf_generate_cpp(PROTO_SRCS PROTO_HDRS
                      "${PROJECT_SOURCE_DIR}/proto/measurement.proto")

if(FLUTTERCAN_SHARED)
  add_library(${PROJECT_NAME} SHARED ${PROJECT_HEADERS} ${PROJECT_SOURCES}
                                     ${PROTO_SRCS} ${PROTO_HDRS})
else()
  add_library(${PROJECT_NAME} STATIC ${PROJECT_HEADERS} ${PROJECT_SOURCES}
                                     ${PROTO_SRCS} ${PROTO_HDRS})
endif()

add_library(${PROJECT_NAME}::${PROJECT_NAME} ALIAS ${PROJECT_NAME})

target_include_directories(
  ${PROJECT_NAME}
  PUBLIC $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
         $<BUILD_INTERFACE:${LIBSOCKETCAN_INCLUDE_DIRS}>
         $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>
         $<INSTALL_INTERFACE:include>
  PRIVATE ${CMAKE_CURRENT_BINARY_DIR}/source)

set_target_properties(${PROJECT_NAME} PROPERTIES VERSION ${PROJECT_VERSION})
set_target_properties(${PROJECT_NAME} PROPERTIES SOVERSION
                                                 ${PROJECT_VERSION_MAJOR})

set_target_properties(
  ${PROJECT_NAME}
  PROPERTIES ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib
             LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib
             RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

target_link_libraries(
  ${PROJECT_NAME} Boost::system Boost::log protobuf::libprotobuf
  Boost::program_options ${LIBSOCKETCAN_LIBRARIES})

target_compile_options(${PROJECT_NAME} PRIVATE -Wall -Wextra -Wpedantic)

if(FLUTTERCAN_EXAMPLE)
  add_subdirectory(example)
endif()

if(FLUTTERCAN_INSTALL)
  include(FlutterCanInstall)
endif()
