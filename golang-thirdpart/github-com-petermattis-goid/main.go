package main

import (
	"fmt"
	"sync"

	"github.com/petermattis/goid"
)

func main() {
	fmt.Println("main", goid.Get())
	var wg sync.WaitGroup
	for i := 0; i < 10; i++ {
		wg.Add(1)
		go func(id int) {
			defer wg.Done()
			fmt.Println(id, goid.Get())
		}(i)
	}
	wg.Wait()
}
