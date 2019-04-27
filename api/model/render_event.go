package model

import (
	"fmt"
)

// EventType is not documented.
// One of 'childList' 'frame' 'paint' 'characterData' 'attributes'
type EventType string

const (
	ChildList     EventType = "childList"
	Frame         EventType = "frame"
	Paint         EventType = "paint"
	CharacterData EventType = "characterData"
	Attributes    EventType = "attibutes"
	Unknown       EventType = "unknown"
)

func ToEventType(s string) (EventType, error) {
	switch s {
	case "childList":
		return ChildList, nil
	case "frame":
		return Frame, nil
	case "paint":
		return Paint, nil
	case "characterData":
		return CharacterData, nil
	case "attributes":
		return Attributes, nil
	default:
		return Unknown, fmt.Errorf("Expect one of EventType, got %s", s)
	}
}

// RenderEventJSON represents shape of response.
type RenderEventJSON struct {
	EventType EventType `json:"eventType"`
	Time      int64     `json:"time"`
}

// RenderEvent is not documented.
type RenderEvent struct {
	Session   Session   `gorm:"not null"`
	EventType EventType `gorm:"not null"  sql:"type:event_type"`
	Time      int64     `gorm:"not null"`
}

// BeaconToJSON is converter from Database model to JSON
func (r *RenderEvent) BeaconToJSON() RenderEventJSON {
	return RenderEventJSON{EventType: r.EventType, Time: r.Time}
}
