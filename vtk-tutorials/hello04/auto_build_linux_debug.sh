#!/bin/bash

rm -rf build 

rm -rf third_party

mkdir build && cd build

cmake -DCMAKE_BUILD_TYPE=Debug .. 

cmake --build .

./PostProcess