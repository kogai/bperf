package model

import (
	"time"

	s "github.com/kogai/bperf/api/service"
)

// NetworkEventJSON represents shape of response.
type NetworkEventJSON struct {
	StartTime int64  `json:"startTime"`
	EndTime   int64  `json:"endTime"`
	Name      string `json:"name"`
}

// NetworkEvent is not documented.
type NetworkEvent struct {
	SessionID string    `gorm:"not null"`
	StartTime time.Time `gorm:"not null"`
	EndTime   time.Time `gorm:"not null"`
	Name      string    `gorm:"not null"`
	BodySize  uint64
}

// NewNetworkEvent is not documented.
func NewNetworkEvent(id string, start time.Time, end time.Time, name string, bodySize uint64) NetworkEvent {
	return NetworkEvent{
		StartTime: start,
		EndTime:   end,
		Name:      name,
		SessionID: id,
		BodySize:  bodySize,
	}
}

// ToJSON is converter from Database model to JSON
func (r *NetworkEvent) ToJSON() NetworkEventJSON {
	return NetworkEventJSON{StartTime: s.TimeToMs(r.StartTime), EndTime: s.TimeToMs(r.EndTime), Name: r.Name}
}

// NetworkEventJSONArray is not documented.
func NetworkEventJSONArray(events []NetworkEvent) []NetworkEventJSON {
	var payloads = make([]NetworkEventJSON, 0)
	for _, e := range events {
		payloads = append(payloads, e.ToJSON())
	}
	return payloads
}
