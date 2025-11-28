package dao

import (
	"context"

	"gorm.io/gorm"

	"Realm/dao/model"
	"Realm/dao/query"
)

// https://gorm.io/gen/
type RealmDao struct{}

var QRealm = &RealmDao{}

// count number of domain
func (rd *RealmDao) CounterDomain(ctx context.Context, db *gorm.DB) (int64, error) {
	u := query.Use(db).Realm
	cnt, err := u.WithContext(ctx).Where().Count()
	if err != nil {
		return 0, err
	}
	return cnt, err
}

// Add a domain and passwd
func (rd *RealmDao) AddDomain(ctx context.Context, db *gorm.DB, realm *model.Realm) (int64, error) {
	u := query.Use(db).Realm
	err := u.WithContext(ctx).Create(realm)
	if err != nil {
		return 0, err
	}
	return realm.ID, err
}

// Query a domain and passwd
func (rd *RealmDao) QueryDomain(ctx context.Context, db *gorm.DB, domain string) (*model.Realm, error) {
	u := query.Use(db).Realm
	return u.WithContext(ctx).Where(u.Domain.Eq(domain)).First() // 在查询数据库时会自动添加 LIMIT 1 条件，如果没有找到记录则返回错误 ErrRecordNotFound
}

// Update a domain's passwd
func (rd *RealmDao) UpdateDomainPasswd(ctx context.Context, db *gorm.DB, realm *model.Realm) error {
	u := query.Use(db).Realm
	_, err := u.WithContext(ctx).
		Where(u.ID.Eq(realm.ID)).
		UpdateSimple(
			// u.Domain.Value(realm.Domain),
			u.Pwdd.Value(realm.Pwdd),
		)
	return err
}
