package model

import (
	"github.com/jinzhu/gorm"
)

// Privilege is not documented.
type Privilege string

// User model
type User struct {
	gorm.Model
	PlatformID string `gorm:"type:varchar(100);unique_index"`
	Products   []Product
	Privilege  Privilege `gorm:"not null" sql:"type:privilege"`
}
