package main

import (
	"fmt"
	"time"

	"github.com/google/go-cmp/cmp"
	"github.com/google/go-cmp/cmp/cmpopts"
)

func CompareBasic() {
	// 基本类型比较
	x := 42
	y := 42
	fmt.Println(cmp.Equal(x, y)) // true

	// 不同值
	a := "hello"
	b := "world"
	fmt.Println(cmp.Equal(a, b)) // false

	// 输出差异
	diff := cmp.Diff(a, b)
	fmt.Println(diff)
	// 输出: "hello" != "world"
}

type User struct {
	ID        int
	Name      string
	CreatedAt time.Time
	UpdatedAt time.Time
}

func CompareStructIgnoreTimestamps() {
	u1 := User{ID: 1, Name: "John", CreatedAt: time.Now(), UpdatedAt: time.Now()}
	u2 := User{ID: 1, Name: "John", CreatedAt: time.Now().Add(1 * time.Hour), UpdatedAt: time.Now().Add(2 * time.Hour)}

	// 忽略 CreatedAt 和 UpdatedAt 字段
	opts := cmp.Options{
		cmpopts.IgnoreFields(User{}, "CreatedAt", "UpdatedAt"),
	}

	if !cmp.Equal(u1, u2, opts) {
		fmt.Printf("Users differ:\n%s", cmp.Diff(u1, u2, opts))
	} else {
		fmt.Println("Users are equal")
	}
}

func main() {
	CompareBasic()
	CompareStructIgnoreTimestamps()
}
