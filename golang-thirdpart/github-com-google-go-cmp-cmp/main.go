package main

import (
	"fmt"
	"math"
	"strings"
	"time"

	"github.com/google/go-cmp/cmp"
	"github.com/google/go-cmp/cmp/cmpopts"
)

// 比较基础类型
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

// 比较结构体
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

// 自定义比较函数

type Product struct {
	ID       string
	Name     string
	Price    float64
	Category string
}

func CompareStructByCustomComparer() {
	p1 := Product{ID: "P1", Name: "Laptop", Price: 999.99, Category: "Electronics"}
	p2 := Product{ID: "P1", Name: "Laptop", Price: 999.991, Category: "electronics"}

	opts := cmp.Options{
		// 忽略大小写比较分类
		cmp.Comparer(func(x, y string) bool {
			return strings.EqualFold(x, y)
		}),

		// 价格允许小误差
		cmp.Comparer(func(x, y float64) bool {
			return math.Abs(x-y) < 0.01
		}),

		// 忽略 ID 字段
		cmpopts.IgnoreFields(Product{}, "ID"),
	}

	if !cmp.Equal(p1, p2, opts) {
		fmt.Printf("Products differ:\n%s", cmp.Diff(p1, p2, opts))
	} else {
		fmt.Println("Products is equal.")
	}
}

func main() {
	CompareBasic()
	CompareStructIgnoreTimestamps()
	CompareStructByCustomComparer()
}
