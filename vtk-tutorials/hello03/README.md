# 第三个Hello，CMake的案例，演示一个库的引用，并且docker容器化


### 容器化编译

```bash
docker build -t httpserver:latest -f Dockerfile .

docker rm -f httpserver || true

docker run --restart=always -itd  -p 8000:8080 --name httpserver httpserver:latest
```


### CURL测试

```bash
curl -v http://127.0.0.1:8000/ping
curl -v http://127.0.0.1:8000/data
curl -v http://127.0.0.1:8000/paths
curl -v http://127.0.0.1:8000/get?env=1
curl -v http://127.0.0.1:8000/echo -d "hello,world!"
 ```