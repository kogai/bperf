package model

// UaOs is not documented.
type UaOs struct {
	SessionID string `gorm:"not null"`
	Browser   string `gorm:"not null"`
	Os        string `gorm:"not null"`
}
