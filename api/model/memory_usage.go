package model

// MemoryUsage is not documented.
type MemoryUsage struct {
	Session Session
	Usage   int64 `gorm:"not null"`
	Time    int64 `gorm:"not null"`
}
