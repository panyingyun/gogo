package main

import (
	"fmt"

	"github.com/duke-git/lancet/v2/slice"
)

func main() {
	nums := []int{1, 2, 3, 4, 5}

	isEven := func(i, num int) bool {
		return num%2 == 0
	}

	result := slice.Filter(nums, isEven)

	fmt.Println(result)

	// Output:
	// [2 4]
}
