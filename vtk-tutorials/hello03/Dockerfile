FROM harbor.yuansuan.cn/library/ubuntu:24.04 AS builder

LABEL stage=gccbuilder

ENV DEBIAN_FRONTEND=noninteractive

RUN sed -i "s@http://.*archive.ubuntu.com@http://repo.huaweicloud.com@g" /etc/apt/sources.list.d/ubuntu.sources \
    && sed -i "s@http://.*security.ubuntu.com@http://repo.huaweicloud.com@g" /etc/apt/sources.list.d/ubuntu.sources \
    && apt-get update \
    && apt-get install -y --no-install-recommends apt-utils \
    && apt-get install tzdata -y \
    && apt-get install -y vim curl wget git net-tools  build-essential p7zip-full cmake  \
    && apt-get install net-tools iputils-ping iproute2 wget psmisc openssh-client curl -y \
    && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime  && echo "Asia/Shanghai"> /etc/timezone

# RUN sed -i "s@http://.*archive.ubuntu.com@http://repo.huaweicloud.com@g" /etc/apt/sources.list \
#     && sed -i "s@http://.*security.ubuntu.com@http://repo.huaweicloud.com@g" /etc/apt/sources.list \
#     && apt-get update \
#     && apt-get install -y --no-install-recommends apt-utils \
#     && apt-get install tzdata -y \
#     && apt-get install -y vim curl wget git net-tools  build-essential p7zip-full cmake  \
#     && apt-get install net-tools iputils-ping iproute2 wget psmisc openssh-client curl -y \
#     && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime 

WORKDIR /release

COPY .  /release/

RUN mkdir build && cd build && cmake  .. && cmake --build . --parallel 4

FROM harbor.yuansuan.cn/library/ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN sed -i "s@http://.*archive.ubuntu.com@http://repo.huaweicloud.com@g" /etc/apt/sources.list.d/ubuntu.sources \
    && sed -i "s@http://.*security.ubuntu.com@http://repo.huaweicloud.com@g" /etc/apt/sources.list.d/ubuntu.sources \
    && apt-get update \
    && apt-get install -y --no-install-recommends apt-utils \
    && apt-get install tzdata libstdc++6 -y \
    && apt-get install libstdc++6 -y \
    && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo "Asia/Shanghai"> /etc/timezone

WORKDIR /app
COPY --from=builder /release/httpserver /app/httpserver
#COPY --from=builder /release/etc /app/etc

CMD ["./httpserver", "8080"]