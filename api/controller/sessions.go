package controller

import (
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/jinzhu/gorm"
)

// SessionsJSON represents shape of response.
type SessionsJSON struct {
	CreatedAt time.Time `json:"createdAt"`
	Os        string    `json:"os"`
	Browser   string    `json:"browser"`
}

// SessionsHandler is not documented.
func SessionsHandler(c *gin.Context) {
	db := c.MustGet("db").(*gorm.DB)
	rows, err := db.Table("sessions as S").Select("S.created_at, U.os, U.browser").Joins("left join ua_os as U on S.id = U.session_id").Rows()
	if err != nil {
		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{})
		return
	}
	defer rows.Close()

	var payloads = make([]SessionsJSON, 0)
	// FIXME: Seems very slow. and the SQL command seems fast.
	for rows.Next() {
		var payload SessionsJSON

		db.ScanRows(rows, &payload)
		payloads = append(payloads, payload)
	}

	c.JSON(http.StatusOK, payloads)
}
