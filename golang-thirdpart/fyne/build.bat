@echo off
REM Fyne 需要 CGO 支持，请确保已安装 C 编译器（如 TDM-GCC 或 MinGW）
set CGO_ENABLED=1
go build main.go
if %ERRORLEVEL% EQU 0 (
    echo 编译成功！
) else (
    echo 编译失败！请确保：
    echo 1. 已设置 CGO_ENABLED=1
    echo 2. 已安装 C 编译器（Windows 需要 TDM-GCC 或 MinGW）
    echo 3. C 编译器在 PATH 环境变量中
)

