cmake_minimum_required(VERSION 3.11)

#set the project name 
project(hello VERSION 1.13)

# build hello 
add_executable(hello main.cpp)
target_link_libraries(hello)

# build static hello
add_executable(hellostatic main.cpp)
target_link_libraries(hellostatic -static)