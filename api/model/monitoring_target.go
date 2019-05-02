package model

import (
	"github.com/jinzhu/gorm"
)

// MonitoringTarget is not documented.
type MonitoringTarget struct {
	gorm.Model
	PublishableID string `gorm:"not null"`
	// FIXME: Define as Has Many
	Sessions []Session
}
