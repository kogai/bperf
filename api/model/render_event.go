package model

import (
	"fmt"
	"time"

	s "github.com/kogai/bperf/api/service"
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
	SessionID string    `gorm:"not null" gorm:"primary_key"`
	EventType EventType `gorm:"not null"  sql:"type:event_type"`
	Time      time.Time `gorm:"not null"`
}

// NewRenderEvent is not documented.
func NewRenderEvent(sessionID string, eventType EventType, t time.Time) RenderEvent {
	return RenderEvent{
		SessionID: sessionID,
		EventType: eventType,
		Time:      t,
	}
}

// ToJSON converts Database model to JSON
func (r *RenderEvent) ToJSON() RenderEventJSON {
	return RenderEventJSON{EventType: r.EventType, Time: s.TimeToMs(r.Time)}
}

// RenderEventJSONArray is not documented.
func RenderEventJSONArray(renderEvents []RenderEvent) []RenderEventJSON {
	var payloads = make([]RenderEventJSON, 0)
	for _, r := range renderEvents {
		payloads = append(payloads, r.ToJSON())
	}
	return payloads
}
