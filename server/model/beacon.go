package model

import (
	"github.com/jinzhu/gorm"
)

// Beacon accumulates beacons agent send.
type Beacon struct {
	gorm.Model
	EventType string `gorm:"not null"`
	Time      int64  `gorm:"not null"`
	UserID    uint   `gorm:"not null"`
}

type BeaconJson struct {
	EventType string `json:"eventType"`
	Time      int64  `json:"time"`
}

func BeaconToJson(b *Beacon) BeaconJson {
	return BeaconJson{EventType: b.EventType, Time: b.Time}
}
