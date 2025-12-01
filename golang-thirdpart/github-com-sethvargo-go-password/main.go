package main

import (
	"log"

	"github.com/sethvargo/go-password/password"
)

func main() {
	// Generate a password that is 64 characters long with 10 digits, 10 symbols,
	// allowing upper and lower case letters, disallowing repeat characters.
	res, err := password.Generate(13, 6, 0, false, false)
	if err != nil {
		log.Fatal(err)
	}
	log.Printf(res)
}
