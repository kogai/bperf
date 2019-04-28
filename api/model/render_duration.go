package model

import (
	"fmt"
)

// RenderDurationEvent is not documented.
// One of'frame' 'paint'
type RenderDurationEvent string

const (
	Frame     RenderDurationEvent = "frame"
	Paint     RenderDurationEvent = "paint"
	UnknownRd RenderDurationEvent = "unknown"
)

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
}

// RenderDuration is not documented.
type RenderDuration struct {
	Session   Session             `gorm:"not null"`
	EventType RenderDurationEvent `gorm:"not null"  sql:"type:render_duration_event"`
	StartTime int64               `gorm:"not null"`
	EndTime   int64               `gorm:"not null"`
}

// ToJSON is converter from Database model to JSON
func (r *RenderDuration) ToJSON() RenderDurationJSON {
	return RenderDurationJSON{EventType: r.EventType, StartTime: r.StartTime, EndTime: r.EndTime}
}