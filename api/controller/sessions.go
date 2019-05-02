package controller

import (
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/jinzhu/gorm"
)

// SessionIntermediate is not documented.
type SessionIntermediate struct {
	CreatedAt time.Time
	Os        string
	Browser   string
}

// toJSON converts Database model to JSON
func (r *SessionIntermediate) toJSON() SessionsJSON {
	return SessionsJSON{CreatedAt: r.CreatedAt.Unix(), Os: r.Os, Browser: r.Browser}
}

// SessionsJSON  is not documented.
type SessionsJSON struct {
	CreatedAt int64  `json:"createdAt"`
	Os        string `json:"os"`
	Browser   string `json:"browser"`
}

// SessionsHandler is not documented.
func SessionsHandler(c *gin.Context) {
	db := c.MustGet("db").(*gorm.DB)
	rows, err := db.Table("sessions as S").Select("S.created_at, U.os, U.browser").Joins("left join ua_os as U on S.id = U.session_id").Order("S.created_at asc").Rows()
	if err != nil {
		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{})
		return
	}
	defer rows.Close()

	var payloads = make([]SessionsJSON, 0)
	// FIXME: Seems very slow, it costs almost 1 ~ 2 secondes. And the SQL command seems still fast(almost 3ms).
	for rows.Next() {
		var payload SessionIntermediate

		db.ScanRows(rows, &payload)

		payloads = append(payloads, payload.toJSON())
	}

	c.JSON(http.StatusOK, payloads)
}
