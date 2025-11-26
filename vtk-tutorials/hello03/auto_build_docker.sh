#!/bin/bash
docker build -t httpserver:latest -f Dockerfile .

docker rm -f httpserver || true

docker run --restart=always -itd  -p 8000:8080 --name httpserver httpserver:latest