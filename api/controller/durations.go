package controller

import (
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/jinzhu/gorm"
)

// RenderDurationIntermediate represents shape of response.
type RenderDurationIntermediate struct {
	CreatedAt time.Time
	EndTime   time.Time
}

// toJSON converts Database model to JSON
func (r *RenderDurationIntermediate) toJSON() RenderDurationJSON {
	duration := r.EndTime.Sub(r.CreatedAt)
	return RenderDurationJSON{StartTime: r.CreatedAt.Unix(), DurationMs: duration.Nanoseconds() / 1000000}
}

// RenderDurationJSON represents shape of response.
type RenderDurationJSON struct {
	StartTime  int64 `json:"startTime"`
	DurationMs int64 `json:"durationMs"`
}

// DurationsHandler is not documented.
func DurationsHandler(c *gin.Context) {
	var err error

	db := c.MustGet("db").(*gorm.DB)
	rows, err := db.Table("sessions as S").Select("S.created_at, R.end_time").Joins("inner join render_durations as R on S.id = R.session_id").Order("S.created_at asc").Rows()
	if err != nil {
		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{})
		return
	}

	var payloads = make([]RenderDurationJSON, 0)
	for rows.Next() {
		var payload RenderDurationIntermediate

		err = db.ScanRows(rows, &payload)
		if err != nil {
			break
		}

		payloads = append(payloads, payload.toJSON())
	}
	if err != nil {
		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{})
		return
	}
	c.JSON(http.StatusOK, payloads)
}
