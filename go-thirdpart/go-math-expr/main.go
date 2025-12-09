package main

import (
	"fmt"

	"github.com/dengsgo/math-engine/engine"
)

func main() {
	s := "1 + 2 * 6 / 4 + (456 - 8 * 9.2) - (2 + 4 ^ 5)"
	// call top level function
	simple(s)

	// call deep level function
	deepseek(s)
}

func simple(exp string) {
	r, err := engine.ParseAndExec(exp)
	if err != nil {
		fmt.Println(err)
	}
	fmt.Printf("%s = %v\n", exp, r)
}

// call engine
// one by one
func deepseek(exp string) {
	// input text -> []token
	toks, err := engine.Parse(exp)
	if err != nil {
		fmt.Println("ERROR: " + err.Error())
		return
	}
	// []token -> AST Tree
	ast := engine.NewAST(toks, exp)
	if ast.Err != nil {
		fmt.Println("ERROR: " + ast.Err.Error())
		return
	}
	// AST builder
	ar := ast.ParseExpression()
	if ast.Err != nil {
		fmt.Println("ERROR: " + ast.Err.Error())
		return
	}
	fmt.Printf("ExprAST: %+v\n", ar)
	// AST traversal -> result
	r := engine.ExprASTResult(ar)
	fmt.Println("progressing ...\t", r)
	fmt.Printf("%s = %v\n", exp, r)
}
