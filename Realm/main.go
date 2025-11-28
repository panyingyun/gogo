package main

import (
	"context"
	"fmt"
	"os"
	"path"

	"Realm/dao"
	"Realm/helper"
)

const (
	DBName string = "realm.db"
)

func main() {
	dir, _ := os.Getwd()
	fmt.Println("dir = ", dir)
	realmdb, err := helper.OpenDB(path.Join(dir, DBName))

	ctx := context.Background()
	cnt, err := dao.QRealm.CounterDomain(ctx, realmdb)
	fmt.Println(cnt)
	fmt.Println(err)

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
