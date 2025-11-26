#!/bin/bash

rm -rf build 

cmake -S . -B build

cd build

cmake --build . 

cmake --install . --prefix ../../example/thirdpart/mmathcc