#!/bin/bash
# Fyne 需要 CGO 支持，请确保已安装 C 编译器
export CGO_ENABLED=1
go build main.go

