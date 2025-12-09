package main

//https://segmentfault.com/a/1190000041634906
//https://juejin.cn/post/7489382857032810537

import (
	"encoding/json"
	"fmt"

	"golang.org/x/exp/constraints"
)

// =============泛型函数=============
func Max[T constraints.Ordered](slice []T) T {
	if len(slice) == 0 {
		var zero T
		return zero
	}
	max := slice[0]
	for _, v := range slice {
		if v > max {
			max = v
		}
	}
	return max
}

func testFunctionGeneric() {
	ints := []int{1, 3, 2, 5, 4}
	floats := []float64{1.1, 3.3, 2.2, 5.5, 4.4}
	strings := []string{"apple", "banana", "cherry"}

	fmt.Println("Max int:", Max(ints))
	fmt.Println("Max float:", Max(floats))
	fmt.Println("Max string:", Max(strings))
}

// =============泛型数据结构=============
// 定义一个泛型栈
type Stack[T any] struct {
	elements []T
}

// 压栈
func (s *Stack[T]) Push(element T) {
	s.elements = append(s.elements, element)
}

// 弹栈
func (s *Stack[T]) Pop() (T, bool) {
	if len(s.elements) == 0 {
		var zero T
		return zero, false
	}
	index := len(s.elements) - 1
	element := s.elements[index]
	s.elements = s.elements[:index]
	return element, true
}

// 查看栈顶元素
func (s *Stack[T]) Peek() (T, bool) {
	if len(s.elements) == 0 {
		var zero T
		return zero, false
	}
	return s.elements[len(s.elements)-1], true
}

func testDataStructureGeneric() {
	intStack := Stack[int]{}
	intStack.Push(10)
	intStack.Push(20)
	value, ok := intStack.Pop()
	fmt.Println("Pop from intStack:", value, ok)

	stringStack := Stack[string]{}
	stringStack.Push("hello")
	stringStack.Push("world")
	peekValue, peekOk := stringStack.Peek()
	fmt.Println("Peek from stringStack:", peekValue, peekOk)
}

// =============泛型接口=============
// 定义泛型接口
type Serializable[T any] interface {
	Serialize() ([]byte, error)
	Deserialize(data []byte) (T, error)
}

// 实现 Serializable 接口的结构体
type Person struct {
	Name string
	Age  int
}

func (p *Person) Serialize() ([]byte, error) {
	return json.Marshal(p)
}

func (p *Person) Deserialize(data []byte) (Person, error) {
	var person Person
	err := json.Unmarshal(data, &person)
	return person, err
}

func testInterfaceGeneric() {
	person := &Person{Name: "Alice", Age: 30}
	data, err := person.Serialize()
	if err != nil {
		fmt.Println("Serialization error:", err)
		return
	}
	fmt.Println("Serialized data:", string(data))

	newPerson, err := person.Deserialize(data)
	if err != nil {
		fmt.Println("Deserialization error:", err)
		return
	}
	fmt.Println("Deserialized Person:", newPerson)
}

func main() {
	testFunctionGeneric()
	testDataStructureGeneric()
	testInterfaceGeneric()
}
