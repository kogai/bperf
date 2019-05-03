package model

import (
	"github.com/jinzhu/gorm"
)

// PricePlan is not documented.
// sql:"type:price_plan"
// FIXME: Define as ENUM
type PricePlan string

// Product is not documented.
type Product struct {
	gorm.Model
	Name              string
	APIKey            string    `gorm:"not null"`
	PricePlan         PricePlan `gorm:"not null" sql:"type:price_plan"`
	MonitoringTargets []MonitoringTarget
	Users             []User
}
