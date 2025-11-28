package main

import (
	"fmt"

	"Realm/helper"
)

func main() {
	plainText := "Hello, World!"
	fmt.Println("This is an original:", plainText)

	encrypted, err := helper.GetAESEncrypted("googlepyy", plainText)
	if err != nil {
		fmt.Println("Error during encryption", err)
	}

	fmt.Println("This is an encrypted:", encrypted)

	decrypted, err := helper.GetAESDecrypted("googlepyy", encrypted)
	if err != nil {
		fmt.Println("Error during decryption", err)
	}
	fmt.Println("This is a decrypted:", decrypted)
}
