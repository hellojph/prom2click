# 阶段1：构建Go二进制文件
FROM golang:latest AS build-env

# 将源代码添加到构建环境
ADD ./ /go/src/github.com/iyacontrol/prom2click
WORKDIR /go/src/github.com/iyacontrol/prom2click

# 构建Go二进制文件
RUN CGO_ENABLED=0 go build -ldflags "-X main.GitCommit=${GIT_COMMIT}${GIT_DIRTY} -X main.VersionPrerelease=DEV" -o /go/bin/prom2click

# 阶段2：创建最终镜像
FROM alpine:latest

# 安装tzdata包并设置时区
RUN apk add --no-cache tzdata
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

# 从构建阶段复制二进制文件
COPY --from=build-env /go/bin/prom2click /usr/local/bin/prom2click

# 确保二进制文件具有可执行权限
RUN chmod +x /usr/local/bin/prom2click

# 设置默认命令
CMD ["prom2click"]
