package model

// NetworkEventJSON represents shape of response.
type NetworkEventJSON struct {
	StartTime int64  `json:"startTime"`
	EndTime   int64  `json:"endTime"`
	Name      string `json:"name"`
}

// NetworkEvent is not documented.
type NetworkEvent struct {
	SessionID string `gorm:"not null"`
	StartTime int64  `gorm:"not null"`
	EndTime   int64  `gorm:"not null"`
	Name      string `gorm:"not null"`
}

// ToJSON is converter from Database model to JSON
func (r *NetworkEvent) ToJSON() NetworkEventJSON {
	return NetworkEventJSON{StartTime: r.StartTime, EndTime: r.EndTime, Name: r.Name}
}

// NetworkEventJSONArray is not documented.
func NetworkEventJSONArray(events []NetworkEvent) []NetworkEventJSON {
	var payloads = make([]NetworkEventJSON, 0)
	for _, e := range events {
		payloads = append(payloads, e.ToJSON())
	}
	return payloads
}
