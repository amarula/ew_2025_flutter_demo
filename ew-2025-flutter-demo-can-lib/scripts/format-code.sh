#!/bin/bash -e

FULL_PATH=$(realpath $0)
SCRIPT_PATH=$(dirname $FULL_PATH)

cd ${SCRIPT_PATH}/..

CMAKE_FILES="cmake/* CMakeLists.txt example/CMakeLists.txt"
cmake-format -i ${CMAKE_FILES}

SOURCES_FILES=`find "example" "include" "source" -name "*.hpp" -o -name "*.cpp"`
clang-format --style=file -i ${SOURCES_FILES}