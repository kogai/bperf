package model

import (
	"fmt"
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

// RenderDurationJSON represents shape of response.
type RenderDurationJSON struct {
	EventType RenderDurationEvent `json:"eventType"`
	StartTime int64               `json:"startTime"`
	EndTime   int64               `json:"endTime"`
	Name      string              `json:"name"`
}

// RenderDuration is not documented.
type RenderDuration struct {
	SessionID string              `gorm:"not null"`
	EventType RenderDurationEvent `gorm:"not null"  sql:"type:render_duration_event"`
	StartTime int64               `gorm:"not null"`
	EndTime   int64               `gorm:"not null"`
	Name      string              `gorm:"not null"`
}

// ToJSON is converter from Database model to JSON
func (r *RenderDuration) ToJSON() RenderDurationJSON {
	return RenderDurationJSON{EventType: r.EventType, StartTime: r.StartTime, EndTime: r.EndTime, Name: r.Name}
}

// RenderDurationJSONArray is not documented.
func RenderDurationJSONArray(events []RenderDuration) []RenderDurationJSON {
	var payloads = make([]RenderDurationJSON, 0)
	for _, e := range events {
		payloads = append(payloads, e.ToJSON())
	}
	return payloads
}
