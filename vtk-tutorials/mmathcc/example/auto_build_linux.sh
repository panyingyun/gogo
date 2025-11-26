#!/bin/bash

rm -rf build 

cmake -S . -B build

cd build 

cmake --build . --parallel 8
