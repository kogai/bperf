package model

// NetworkEvent is not documented.
type NetworkEvent struct {
	Session   Session
	StartTime int64 `gorm:"not null"`
	EndTime   int64 `gorm:"not null"`
}
