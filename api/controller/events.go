package controller

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/jinzhu/gorm"
	"github.com/kogai/bperf/api/model"
)

// EventsHandler is not documented.
func EventsHandler(c *gin.Context) {
	db := c.MustGet("db").(*gorm.DB)

	var renderEvents []model.RenderEvent
	// db.Where("event_type = ?", "childList").Limit(50).Find(&beacons)
	// db.Where("event_type = ?", "childList").Find(&beacons)
	db.Find(&renderEvents)
	var payloads = make([]model.RenderEventJSON, 0)
	for _, r := range renderEvents {
		payloads = append(payloads, r.ToJSON())
	}
	c.JSON(http.StatusOK, payloads)
}
