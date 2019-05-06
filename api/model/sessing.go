package model

import "time"

// Session is not documented.
type Session struct {
	ID        string    `gorm:"primary_key"`
	CreatedAt time.Time `gorm:"not null"`
}

// NewSession is not documented.
func NewSession(id string, createdAt time.Time) Session {
	return Session{
		ID:        id,
		CreatedAt: createdAt,
	}
}
