package main

import (
	"fmt"

	"github.com/elliotchance/pie/v2"
)

type timesheet struct {
	UserID    int64
	TimeSheet int
}

type timesheets []timesheet

// filterUser 返回一个过滤函数，用于筛选指定用户ID的timesheet
func filterUser(userID int64) func(ts timesheet) bool {
	return func(ts timesheet) bool {
		return ts.UserID == userID
	}
}

// filterUser 返回一个过滤函数，用于筛选指定用户ID的timesheet
func transformUser(userID int64) func(ts timesheet) timesheet {
	return func(ts timesheet) timesheet {
		ts.UserID = ts.UserID + 100
		ts.TimeSheet = ts.TimeSheet
		return ts
	}
}

// Sum 计算timesheets中所有TimeSheet的总和
func (ss timesheets) Sum() int {
	sum := 0
	for _, s := range ss {
		sum += s.TimeSheet
	}
	return sum
}

func main() {
	tss := timesheets{
		{UserID: 1, TimeSheet: 1},
		{UserID: 1, TimeSheet: 7},
		{UserID: 2, TimeSheet: 2},
		{UserID: 2, TimeSheet: 6},
		{UserID: 3, TimeSheet: 6},
		{UserID: 4, TimeSheet: 8},
	}

	// 使用链式调用，统一代码风格
	sum1 := timesheets(pie.Of(tss).Filter(filterUser(1)).Result).Sum()
	fmt.Println(sum1) // timesheet of user1

	sum2 := timesheets(pie.Of(tss).Filter(filterUser(2)).Result).Sum()
	fmt.Println(sum2) // timesheet of user2

	sum3 := timesheets(pie.Of(tss).Filter(filterUser(3)).Result).Sum()
	fmt.Println(sum3) // timesheet of user3

	sum123 := timesheets(pie.Of(tss).FilterNot(filterUser(4)).Result).Sum()
	fmt.Println(sum123) // timesheet of user1+user2+user3

	tss1 := pie.Of(tss).Map(transformUser(1)).Result
	fmt.Println(tss1)
}
