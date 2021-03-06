package model

import (
	"fmt"
	"time"
)

// RenderDurationEvent is not documented.
// One of'frame' 'paint'
type RenderDurationEvent string

const (
	// Frame is not documented.
	Frame RenderDurationEvent = "frame"
	// Paint is not documented.
	Paint RenderDurationEvent = "paint"
	// UnknownRd is not documented.
	UnknownRd RenderDurationEvent = "unknown"
)

// ToRenderDurationType is not documented.
func ToRenderDurationType(s string) (RenderDurationEvent, error) {
	switch s {
	case "frame":
		return Frame, nil
	case "paint":
		return Paint, nil
	default:
		return UnknownRd, fmt.Errorf("Expect one of EventType, got %s", s)
	}
}

// RenderDuration is not documented.
type RenderDuration struct {
	SessionID string              `gorm:"not null"`
	EventType RenderDurationEvent `gorm:"not null"  sql:"type:render_duration_event"`
	StartTime time.Time           `gorm:"not null"`
	EndTime   time.Time           `gorm:"not null"`
	Name      string              `gorm:"not null"`
}
