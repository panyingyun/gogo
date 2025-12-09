package main

import (
	"fmt"
)

//go install github.com/elliotchance/pie

type TimeSheet struct {
	UserID    int64
	ProjectID string
	TimeSheet int
}

func (ss TimeSheets) Sum() (sum int) {
	for _, s := range ss {
		sum += s.TimeSheet
	}

	return
}

//go:generate pie TimeSheets.*
type TimeSheets []TimeSheet

func main() {
	var tss TimeSheets
	ts0 := TimeSheet{
		UserID:    1,
		ProjectID: "GW0016",
		TimeSheet: 1,
	}
	ts1 := TimeSheet{
		UserID:    1,
		ProjectID: "GW0014",
		TimeSheet: 4,
	}
	ts2 := TimeSheet{
		UserID:    2,
		ProjectID: "GW0016",
		TimeSheet: 1,
	}
	ts3 := TimeSheet{
		UserID:    2,
		ProjectID: "GW0014",
		TimeSheet: 7,
	}
	ts4 := TimeSheet{
		UserID:    2,
		ProjectID: "GW0014",
		TimeSheet: 7,
	}
	tss = append(tss, ts0, ts1, ts2, ts3, ts4)

	u1time := tss.Filter(func(ts TimeSheet) bool {
		return ts.UserID == 1
	}).Sum()
	fmt.Println(u1time)

	u2time := tss.Filter(func(ts TimeSheet) bool {
		return ts.UserID == 2
	}).Sum()
	fmt.Println(u2time)

	u3time := tss.Filter(func(ts TimeSheet) bool {
		return ts.UserID == 2 && ts.ProjectID == "GW0014"
	}).Sum()
	fmt.Println(u3time)
}
