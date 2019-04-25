package model

// Beacon accumulates beacons agent send.
type Beacon struct {
	ID        uint   `gorm:"primary_key"`
	EventType string `gorm:"not null"`
	Time      int64  `gorm:"not null"`
	UserID    uint   `gorm:"not null"`
}

// BeaconJSON represents shape of response.
type BeaconJSON struct {
	EventType string `json:"eventType"`
	Time      int64  `json:"time"`
}

// BeaconToJSON is converter from Database model to JSON
func BeaconToJSON(b *Beacon) BeaconJSON {
	return BeaconJSON{EventType: b.EventType, Time: b.Time}
}
