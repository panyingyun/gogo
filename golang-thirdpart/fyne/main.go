package main

// 注意：Fyne 需要 CGO 支持，编译前请确保：
// 1. 设置环境变量 CGO_ENABLED=1
// 2. 安装 C 编译器（Windows 需要 TDM-GCC 或 MinGW）
// 编译命令：CGO_ENABLED=1 go build main.go
// 或使用提供的构建脚本：build.bat (Windows) 或 build.sh (Linux/Mac)

import (
	"fyne.io/fyne/v2/app"
	"fyne.io/fyne/v2/container"
	"fyne.io/fyne/v2/widget"
)

// https://github.com/fyne-io/fyne

func main() {
	a := app.New()
	w := a.NewWindow("Hello")

	hello := widget.NewLabel("Hello Fyne!")
	w.SetContent(container.NewVBox(
		hello,
		widget.NewButton("Hi!", func() {
			hello.SetText("Welcome :)")
		}),
	))

	w.ShowAndRun()
}
