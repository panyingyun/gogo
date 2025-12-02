package main

//https://segmentfault.com/a/1190000041634906
//https://juejin.cn/post/7489382857032810537

import (
	"fmt"

	"golang.org/x/exp/constraints"
)

func Max[T constraints.Ordered](slice []T) T {
	if len(slice) == 0 {
		var zero T
		return zero
	}
	max := slice[0]
	for _, v := range slice {
		if v > max {
			max = v
		}
	}
	return max
}

func main() {
	ints := []int{1, 3, 2, 5, 4}
	floats := []float64{1.1, 3.3, 2.2, 5.5, 4.4}
	strings := []string{"apple", "banana", "cherry"}

	fmt.Println("Max int:", Max(ints))
	fmt.Println("Max float:", Max(floats))
	fmt.Println("Max string:", Max(strings))
}
