# Day02 CMake第三方库引用LibHV案例

### 1、源码目录树

```bash
hello02/
.
├── CMakeLists.txt
├── README.md
├── auto_build_linux.sh
├── build
├── cmake
│   └── Modules
│       └── FindLibHV.cmake
├── http_server_test.cpp
├── packages
│   └── libhv-1.3.3.tar.gz
└── thirdpart
    ├── README.md
    └── libhv
        ├── include
        └── lib
```

### 2、http_server_test.cpp

```C++
// HTTP Server Demo
#include <hv/hv.h>
#include <hv/HttpServer.h>
#include <hv/hthread.h> // import hv_gettid
#include <hv/hasync.h>  // import hv::async

using namespace hv;

/*
 *
 * @server  bin/http_server_test 8080
 *
 * @for test
 * curl -v http://127.0.0.1:8080/ping
 * curl -v http://127.0.0.1:8080/data
 * curl -v http://127.0.0.1:8080/paths
 * curl -v http://127.0.0.1:8080/get?env=1
 * curl -v http://127.0.0.1:8080/echo -d "hello,world!"
 *
 * @client  curl -v http://127.0.0.1:8080/ping
 *          curl -v https://127.0.0.1:8443/ping --insecure
 *          bin/curl -v http://127.0.0.1:8080/ping
 *          bin/curl -v https://127.0.0.1:8443/ping
 *
 */
int main(int argc, char **argv)
{
    HV_MEMCHECK;

    int port = 0;
    if (argc > 1)
    {
        port = atoi(argv[1]);
    }
    if (port == 0)
        port = 8080;

    HttpService router;

    /* API handlers */
    // curl -v http://ip:port/ping
    router.GET("/ping", [](HttpRequest *req, HttpResponse *resp)
               { return resp->String("YuanSuan"); });

    // curl -v http://ip:port/data
    router.GET("/data", [](HttpRequest *req, HttpResponse *resp)
               {
        static char data[] = "0123456789";
        return resp->Data(data, 10 /*, false */); });

    // curl -v http://ip:port/paths
    router.GET("/paths", [&router](HttpRequest *req, HttpResponse *resp)
               { return resp->Json(router.Paths()); });

    // curl -v http://ip:port/get?env=1
    router.GET("/get", [](const HttpContextPtr &ctx)
               {
        hv::Json resp;
        resp["origin"] = ctx->ip();
        resp["url"] = ctx->url();
        resp["args"] = ctx->params();
        resp["headers"] = ctx->headers();
        return ctx->send(resp.dump(2)); });

    // curl -v http://ip:port/echo -d "hello,world!"
    router.POST("/echo", [](const HttpContextPtr &ctx)
                { return ctx->send(ctx->body(), ctx->type()); });

    // curl -v http://ip:port/user/123
    router.GET("/user/{id}", [](const HttpContextPtr &ctx)
               {
        hv::Json resp;
        resp["id"] = ctx->param("id");
        return ctx->send(resp.dump(2)); });

    // curl -v http://ip:port/async
    router.GET("/async", [](const HttpRequestPtr &req, const HttpResponseWriterPtr &writer)
               {
        writer->Begin();
        writer->WriteHeader("X-Response-tid", hv_gettid());
        writer->WriteHeader("Content-Type", "text/plain");
        writer->WriteBody("This is an async response.\n");
        writer->End(); });

    HttpServer server;
    server.service = &router;
    server.port = port;
    server.start();

    // press Enter to stop
    while (getchar() != '\n')
        ;
    hv::async::cleanup();
    return 0;
}
```

### 3、CMakeLists.txt

```bash
cmake_minimum_required(VERSION 3.11)
project(httpserver VERSION 2.76 LANGUAGES CXX)

set(CMAKE_ROOT_PATH ${CMAKE_SOURCE_DIR}/cmake)
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_ROOT_PATH}/Modules/")

set(LIBHV_ROOT_DIR ./thirdpart/libhv)

set(EXECUTABLE_OUTPUT_PATH  ${PROJECT_SOURCE_DIR})

find_package(LibHV REQUIRED)

message(STATUS " LIBHV_FOUND = " ${LIBHV_FOUND})
message(STATUS " LIBHV_ROOT_DIR = " ${LIBHV_ROOT_DIR})
message(STATUS " LIBHV_INCLUDE_DIRS = " ${LIBHV_INCLUDE_DIRS})
message(STATUS " LIBHV_LIBRARIES = " ${LIBHV_LIBRARIES})

add_executable(${PROJECT_NAME})

list(APPEND SOURCES ${PROJECT_SOURCE_DIR}/http_server_test.cpp)
list(APPEND THIRDPARTY_LIBS ${LIBHV_LIBRARIES} pthread)

target_sources(${PROJECT_NAME} 
            PRIVATE ${SOURCES}
            )
target_include_directories(${PROJECT_NAME} 
            PRIVATE  ${LIBHV_INCLUDE_DIRS}
            )
target_link_libraries(${PROJECT_NAME} 
            PRIVATE ${THIRDPARTY_LIBS}
            )
```

### 4、auto_build_linux.sh

```bash
#!/bin/bash

rm -rf build 

mkdir build && cd build

cmake  ..

cmake --build . --parallel 8
```

### 5、下载、编译、安装libHV库

```bash
下载libhv库 https://github.com/ithewei/libhv

$ cd packages
$ tar zxvf libhv-1.3.3.tar.gz 
$ cd libhv-1.3.3
$ rm -rf build 
$ cmake -S . -B build
$ cd build
$ cmake --build . --parallel 8
$ cmake --install . --prefix ../../../thirdpart/libhv
```

### 6、编译、运行、测试服务

```bash
sh auto_build_linux.sh

输出日志：
$ ./httpserver 8000
2024-11-20 09:51:43.863 INFO  http server listening on 0.0.0.0:8000 [HttpServer.cpp:178:http_server_run]
2024-11-20 09:51:43.863 INFO  EventLoop started, pid=36655 tid=36656 [HttpServer.cpp:151:loop_thread]
2024-11-20 09:51:46.116 INFO  [36655-36656][127.0.0.1:53094][GET /ping]=>[200 OK] [HttpHandler.cpp:326:onMessageComplete]

测试一下：
curl -v http://127.0.0.1:8080/ping
```