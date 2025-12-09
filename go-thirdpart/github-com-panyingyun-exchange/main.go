package main

import (
	"fmt"

	exchange "github.com/panyingyun/exchange"
)

// Thanks to https://blog.mazey.net/4150.html
// How to  create myself go package
func main() {
	dor := 10.0
	cny := exchange.USD2CNY(dor)
	fmt.Println(cny)
}
