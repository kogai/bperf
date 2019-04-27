package model

// EventType is not documented.
// One of 'childList' 'frame' 'paing' 'charData' 'attributes'
type EventType string

// RenderEvent is not documented.
type RenderEvent struct {
	Session   Session
	EventType EventType `gorm:"not null"  sql:"type:event_type"`
	Time      int64     `gorm:"not null"`
}
