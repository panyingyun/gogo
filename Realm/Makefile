.PHONY: env  clean lint build

all: env  clean lint build

env:
	@echo "=========install goimports ==========="
	GOPROXY=https://goproxy.cn/,direct go install mvdan.cc/gofumpt@latest
	GOPROXY=https://goproxy.cn/,direct go install -v github.com/incu6us/goimports-reviser/v3@latest
	@echo "=========install golangci-lint for static code check========="
	GOPROXY=https://goproxy.cn/,direct go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest

build:
	go mod tidy
	gofumpt -l -w .
	CGO_ENABLED=0 go build  -ldflags "$(LDFLAGS)" -v .
	
gensql:
	gentool -dsn "root:abcdef@tcp(127.0.0.1:7306)/realmdb?charset=utf8mb4&parseTime=True&loc=Local" -outPath "./dao/query"

clean:
	go clean -i .

run:
	./Realm