package main

import (
	"errors"
	"fmt"
	"log/slog"
	"os"
	"slices"
)

// go v1.21.5 slices新特性
func maxMinClear() {
	maxArr := max(3, 1, 5, 9, 6)
	minArr := min(3, 1, 5, 9, 6)
	fmt.Println("maxArr = ", maxArr)
	fmt.Println("minArr = ", minArr)

	arr := []int{3, 1, 5, 9, 6}
	fmt.Println("before clear arr = ", arr)
	clear(arr)
	fmt.Println("after clear arr = ", arr)

	mp := map[string]string{"a": "123"}
	fmt.Println("before clear mp = ", mp)
	clear(mp)
	fmt.Println("before clear mp = ", mp)
}

func slicesFunc() {
	sArr := []int{3, 1, 5, 9, 6}
	fmt.Println("before sort sArr = ", sArr)
	slices.Sort(sArr)
	fmt.Println("before sort sArr = ", sArr)
	maxArr := slices.Max(sArr)
	fmt.Println("max of  sArr = ", maxArr)
	minArr := slices.Min(sArr)
	fmt.Println("min of  sArr = ", minArr)
}

// https://betterstack.com/community/guides/logging/logging-in-go/
func slogDefault() {
	var a int = 10
	var b string = "abc"
	var err error = errors.New("read fail")
	slog.Debug("slogDefault", "a", a)
	slog.Info("slogDefault", "b", b)
	slog.Error("slogDefault", "err", err)
}

func slogTextHandler() {
	opts := &slog.HandlerOptions{
		Level:     slog.LevelDebug,
		AddSource: true,
	}
	handler := slog.NewTextHandler(os.Stdout, opts)
	logger := slog.New(handler)
	var a int = 10
	var b string = "abc"
	var err error = errors.New("read fail")
	logger.Debug("slogDefault", "a", a)
	logger.Info("slogDefault", "b", b)
	logger.Error("slogDefault", "err", err)
}

func slogJsonHandler() {
	opts := &slog.HandlerOptions{
		Level:     slog.LevelDebug,
		AddSource: true,
	}
	handler := slog.NewJSONHandler(os.Stdout, opts)
	logger := slog.New(handler)
	var a int = 10
	var b string = "abc"
	var err error = errors.New("read fail")
	logger.Debug("slogDefault", "a", a)
	logger.Info("slogDefault", "b", b)
	logger.Error("slogDefault", "err", err)
}

func main() {
	maxMinClear()
	slicesFunc()
	fmt.Println("=========================================")
	slogDefault()
	fmt.Println("=========================================")
	slogTextHandler()
	fmt.Println("=========================================")
	slogJsonHandler()
}
