// YS Log
#include "yslog/yslog.h"

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
 */
int main(int argc, char **argv)
{
    HV_MEMCHECK;

    // 设置为终端输出日志，默认输出到文件
    yslog_set_handler(ys_stdout_logger);

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
