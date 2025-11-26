package main

import (
	"fmt"

	"github.com/samber/lo"
)

func basic0() {
	names := lo.Uniq([]string{"Samuel", "John", "Samuel"})
	fmt.Println(names)
}

func basic1() {
	groups := lo.GroupBy([]int{0, 1, 2, 3, 4, 5}, func(i int) int {
		return i % 3
	})
	fmt.Println(groups)
}

type timesheet struct {
	UserID    int64
	TimeSheet int
}

type timesheets []timesheet

var tss timesheets

// 自定义filter
func filteruser(userid int64) func(ts timesheet, index int) bool {
	return func(ts timesheet, index int) bool {
		return ts.UserID == userid
	}
}

func sum(item timesheet) int {
	return item.TimeSheet
}

func basic2() {
	tss = append(tss, timesheet{UserID: 1, TimeSheet: 1})
	tss = append(tss, timesheet{UserID: 1, TimeSheet: 7})
	tss = append(tss, timesheet{UserID: 1, TimeSheet: 7})
	tss = append(tss, timesheet{UserID: 2, TimeSheet: 2})
	tss = append(tss, timesheet{UserID: 2, TimeSheet: 6})
	tss = append(tss, timesheet{UserID: 3, TimeSheet: 6})
	tss = append(tss, timesheet{UserID: 4, TimeSheet: 8})
	tss1 := lo.Filter(tss, filteruser(1))
	fmt.Println("tss1 = ", tss1)
	sum1 := lo.SumBy(tss1, sum)
	fmt.Println("sum1 = ", sum1)
}

func main() {
	// basic0()
	// basic1()
	basic2()
}
