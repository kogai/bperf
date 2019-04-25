package model

import (
	"github.com/jinzhu/gorm"
)

// User model
type User struct {
	gorm.Model
	Email             string `gorm:"type:varchar(100);unique_index"`
	EncryptedPassword string `gorm:"not null"`
	Beacons           []Beacon
}
