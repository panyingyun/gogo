package main

import (
	"fmt"
	"math/rand"
	"time"

	godag "github.com/songzhibin97/go-Dag"
)

/*
		  a     b
		/ | \ / |
	   c  d  e   |
		  |    \ /|
		  f --> g |
		         \|
		          h
*/

type mock struct {
}

func (mock) Call(t *godag.Task) error {
	time.Sleep(time.Second * time.Duration(rand.Intn(5)))
	fmt.Printf("t.id =%v, t.status = %v \n", t.GID(), t.GetState().String())
	return nil
}

func checkErr(err error) {
	if err != nil {
		fmt.Println(err)
	}
}

// 建立关系
func demoNode() (*godag.Task, *godag.Task, *godag.Task, *godag.Task, *godag.Task, *godag.Task, *godag.Task, *godag.Task) {
	a, _ := godag.NewTask("a", mock{}, nil)
	b, _ := godag.NewTask("b", mock{}, nil)
	c, _ := godag.NewTask("c", mock{}, nil)
	d, _ := godag.NewTask("d", mock{}, nil)
	e, _ := godag.NewTask("e", mock{}, nil)
	f, _ := godag.NewTask("f", mock{}, nil)
	g, _ := godag.NewTask("g", mock{}, nil)
	h, _ := godag.NewTask("h", mock{}, nil)

	err := a.AddOutDegrees(c, d, e)
	checkErr(err)
	err = b.AddOutDegrees(e, g, h)
	checkErr(err)
	err = d.AddOutDegrees(f)
	checkErr(err)
	err = e.AddOutDegrees(f, g)
	checkErr(err)
	err = b.AddOutDegrees(h)
	checkErr(err)
	err = g.AddOutDegrees(f, h)
	checkErr(err)
	return a, b, c, d, e, f, g, h
}

// 执行 任务 `h`

func main() {
	_, _, _, _, _, _, _, h := demoNode()
	actuator := godag.NewActuator()
	err := actuator.AddTask(h) // 提交任务
	actuator.Run()             // 执行
	fmt.Println("err = ", err)
}
