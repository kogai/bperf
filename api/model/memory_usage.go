package model

// MemoryUsage is not documented.
type MemoryUsage struct {
	SessionID string `gorm:"not null"`
	Usage     int64  `gorm:"not null"`
	Time      int64  `gorm:"not null"`
}
