package main

import (
	"fmt"
	"time"

	"github.com/dustin/go-humanize"
)

// 容量显示
func ReadableByte() {
	// That file is 83 MB.
	fmt.Printf("That file is %s.\n", humanize.Bytes(82900000))
	// That file is 82 GB.
	fmt.Printf("That file is %s.\n", humanize.Bytes(82000000000))
}

// 时间显示
func ReadableTime() {
	before3STime := time.Now().Add(-3 * time.Second)
	fmt.Printf("This was touched %s.\n", humanize.Time(before3STime))
	before3MTime := time.Now().Add(-3*time.Minute - 63*time.Second)
	fmt.Printf("This was touched %s.\n", humanize.Time(before3MTime))
}

// 千分位显示
func ReadableNumber() {
	fmt.Printf("You owe ￥%s.\n", humanize.Comma(123000))
	fmt.Printf("You owe ￥%s.\n", humanize.Comma(7890100))
}

// 去掉浮点后面的0

func FloatStr() {
	fmt.Printf("%f", 2.24)                // 2.240000
	fmt.Printf("%s", humanize.Ftoa(2.24)) // 2.24
}

func main() {
	//OutPut:
	//That file is 83 MB.
	//That file is 82 GB.
	ReadableByte()
	//OutPut:
	//This was touched 3 seconds ago.
	//This was touched 4 minutes ago.
	ReadableTime()
	//OutPut:
	//You owe ￥123,000.
	//You owe ￥7,890,100.
	ReadableNumber()
}
