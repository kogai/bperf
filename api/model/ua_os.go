package model

// UaOs is not documented.
type UaOs struct {
	SessionID string `gorm:"not null"`
	Browser   string `gorm:"not null"`
	Os        string `gorm:"not null"`
}

// NewUaOs is not documented.
func NewUaOs(sessionID string, browser string, o string) UaOs {
	return UaOs{
		SessionID: sessionID,
		Browser:   browser,
		Os:        o,
	}
}
