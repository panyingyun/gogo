# Day03 HTTP服务及docker镜像案例

### 1、源码目录树

```bash
hello03/
├── CMakeLists.txt
├── Dockerfile
├── README.md
├── auto_build_docker.sh
├── build
│   ├── CMakeCache.txt
│   ├── CMakeFiles
│   ├── Makefile
│   └── cmake_install.cmake
├── cmake
│   └── Modules
├── http_server_test.cpp
└── thirdpart
    ├── README.md
    └── libhv
```

### 2、http_server_test.cpp

```bash
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

    // 设置为终端输出日志，默认输出到文件
    hlog_set_handler(stdout_logger);

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
list(APPEND THIRDPARTY_LIBS ${LIBHV_LIBRARIES})

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

### 4、auto_build_docker.sh

```bash
#!/bin/bash
docker build -t httpserver:latest -f Dockerfile .

docker rm -f httpserver || true

docker run --restart=always -itd  -p 8000:8080 --name httpserver httpserver:latest
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

### 6、编译、运行、测试服务docker

```bash
sh auto_build_docker.sh

## 查看服务日志
$ docker logs -f httpserver
2024-11-20 09:59:12.116 INFO  http server listening on 0.0.0.0:8080 [HttpServer.cpp:178:http_server_run]
2024-11-20 09:59:12.116 INFO  EventLoop started, pid=1 tid=7 [HttpServer.cpp:151:loop_thread]
2024-11-20 10:31:13.674 INFO  [1-7][172.17.0.1:57542][GET /ping]=>[200 OK] [HttpHandler.cpp:326:onMessageComplete]
2024-11-20 10:31:25.060 INFO  [1-7][172.17.0.1:38818][GET /ping]=>[200 OK] [HttpHandler.cpp:326:onMessageComplete]
2024-11-20 10:31:37.667 INFO  [1-7][172.17.0.1:50796][GET /ping]=>[200 OK] [HttpHandler.cpp:326:onMessageComplete]
2024-11-20 12:01:45.189 INFO  [1-7][172.17.0.1:59962][GET /ping]=>[200 OK] [HttpHandler.cpp:326:onMessageComplete]
2024-11-20 12:01:50.005 INFO  [1-7][172.17.0.1:59976][GET /date]=>[404 Not Found] [HttpHandler.cpp:326:onMessageComplete]
2024-11-20 12:02:09.999 INFO  [1-7][172.17.0.1:46176][GET /data]=>[200 OK] [HttpHandler.cpp:326:onMessageComplete]
```
### 7、Tips
如果ubuntu安装的系统版本为中文，Dockerfile中的
```bash
sed -i "s@http://.*archive.ubuntu.com@http://repo.huaweicloud.com@g" /etc/apt/sources.list.d/ubuntu.sources \
&& sed -i "s@http://.*security.ubuntu.com@http://repo.huaweicloud.com@g" /etc/apt/sources.list.d/ubuntu.sources
```
执行时，镜像源地址会被默认增加cn的前缀，影响软件下载：
```bash
vim /etc/apt/sources.list # 修改文件中所有url地址，删除cn前缀
=========================
# See http://help.ubuntu.com/community/UpgradeNotes for how to upgrade to
# newer versions of the distribution.
deb http://mirrors.huaweicloud.com/ubuntu/ focal main restricted
deb http://mirrors.huaweicloud.com/ubuntu/ focal universe
deb http://mirrors.huaweicloud.com/ubuntu/ focal multiverse

deb http://mirrors.huaweicloud.com/ubuntu focal-security main restricted
deb-src http://mirrors.huaweicloud.com/ubuntu focal-security universe main multiverse restricted
deb http://mirrors.huaweicloud.com/ubuntu focal-security universe
# deb-src http://mirrors.huaweicloud.com/ubuntu focal-security universe
deb http://mirrors.huaweicloud.com/ubuntu focal-security multiverse
# deb-src http://mirrors.huaweicloud.com/ubuntu focal-security multiverse

deb http://archive.ubuntu.com/ubuntu focal main restricted universe multiverse
deb-src http://archive.ubuntu.com/ubuntu focal main restricted universe multiverse #Added by software-properties

```
