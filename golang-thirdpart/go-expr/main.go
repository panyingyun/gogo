package main

import (
	"fmt"

	"github.com/expr-lang/expr"
)

func main() {
	// Compile the expression
	program, err := expr.Compile(`2 + 2`)
	if err != nil {
		fmt.Println("Error compiling expression:", err)
		return
	}

	// Run the compiled program
	output, err := expr.Run(program, nil) // nil environment as no variables are needed
	if err != nil {
		fmt.Println("Error running expression:", err)
		return
	}

	fmt.Println("Result of '2 + 2':", output) // Output: 4

	// Example with variables (environment)
	env := map[string]interface{}{
		"x": 10,
		"y": 5,
	}
	programWithVars, err := expr.Compile(`x * y + 3`)
	if err != nil {
		fmt.Println("Error compiling expression with variables:", err)
		return
	}
	outputWithVars, err := expr.Run(programWithVars, env)
	if err != nil {
		fmt.Println("Error running expression with variables:", err)
		return
	}
	fmt.Println("Result of 'x * y + 3':", outputWithVars) // Output: 53
}
