# 第二个Hello，CMake的案例，演示一个库的引用

### 下载libhv库

https://github.com/ithewei/libhv


```bash

$ cd packages

$ tar zxvf libhv-1.3.3.tar.gz 

$ cd libhv-1.3.3

$ rm -rf build 

$ cmake -S . -B build

$ cd build

$ cmake --build . --parallel 8

$ cmake --install . --prefix ../../../thirdpart/libhv

```