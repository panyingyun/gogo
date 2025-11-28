package helper

import (
	"context"
	"errors"
	"fmt"
	"strings"

	"Realm/dao"
	"Realm/dao/model"

	"github.com/glebarez/sqlite"
	gorm "gorm.io/gorm"
)

func isStringBlank(s string) bool {
	return len(strings.TrimSpace(s)) == 0
}

func OpenDB(dbname string) (db *gorm.DB, err error) {
	db, err = gorm.Open(sqlite.Open(dbname), &gorm.Config{})
	//_ = db.Exec("PRAGMA journal_mode=WAL;") // 开启 SQLite3 WAL 模式，读写不会互相阻塞，降低锁库的概率
	fmt.Println("db = ", db)
	fmt.Println("err = ", err)
	return
}

func Counter(realmdb *gorm.DB) int64 {
	ctx := context.Background()
	cnt, _ := dao.QRealm.CounterDomain(ctx, realmdb)
	return cnt
}

func AddDomain(realmdb *gorm.DB, domain string, pwdd string) int64 {
	if isStringBlank(domain) || isStringBlank(pwdd) {
		return -1
	}
	ctx := context.Background()
	var realm *model.Realm
	realm.Domain = domain
	realm.Pwdd = pwdd
	id, _ := dao.QRealm.AddDomain(ctx, realmdb, realm)
	return id
}

func QueryDomain(realmdb *gorm.DB, domain string) string {
	ctx := context.Background()
	realm, err := dao.QRealm.QueryDomain(ctx, realmdb, domain)
	if err == nil {
		return ""
	}
	return realm.Pwdd
}

func UpdateDomainPasswd(realmdb *gorm.DB, domain string, pwdd string) error {
	if isStringBlank(domain) || isStringBlank(pwdd) {
		return errors.New("domain or pwdd cannot be blank")
	}
	ctx := context.Background()
	var realm *model.Realm
	realm.Domain = domain
	realm.Pwdd = pwdd
	return dao.QRealm.UpdateDomainPasswd(ctx, realmdb, realm)
}
