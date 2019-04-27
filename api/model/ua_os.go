package model

// UaOs is not documented.
type UaOs struct {
	Session Session `gorm:"not null"`
	Ua      string  `gorm:"not null"`
	Os      string  `gorm:"not null"`
}
