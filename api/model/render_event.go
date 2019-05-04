package model

import (
	"fmt"
	"time"
)

// EventType is not documented.
// One of 'childList' 'frame' 'paint' 'characterData' 'attributes'
type EventType string

const (
	// ChildList is not documented.
	ChildList EventType = "childList"
	// CharacterData is not documented.
	CharacterData EventType = "characterData"
	// Attributes is not documented.
	Attributes EventType = "attibutes"
	// Unknown is not documented.
	Unknown EventType = "unknown"
)

// ToEventType represents shape of response.
func ToEventType(s string) (EventType, error) {
	switch s {
	case "childList":
		return ChildList, nil
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
	SessionID string    `gorm:"not null"`
	EventType EventType `gorm:"not null"  sql:"type:event_type"`
	Time      time.Time `gorm:"not null"`
}

// ToJSON converts Database model to JSON
func (r *RenderEvent) ToJSON() RenderEventJSON {
	return RenderEventJSON{EventType: r.EventType, Time: r.Time.Unix()}
}

// RenderEventJSONArray is not documented.
func RenderEventJSONArray(renderEvents []RenderEvent) []RenderEventJSON {
	var payloads = make([]RenderEventJSON, 0)
	for _, r := range renderEvents {
		payloads = append(payloads, r.ToJSON())
	}
	return payloads
}
