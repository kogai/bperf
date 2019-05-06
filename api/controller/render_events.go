package controller

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/jinzhu/gorm"
	"github.com/kogai/bperf/api/model"
)

// RenderEventsHandler is not documented.
func RenderEventsHandler(c *gin.Context) {
	db := c.MustGet("db").(*gorm.DB)

	var renderEvents []model.RenderEvent
	// db.Where("event_type = ?", "childList").Limit(50).Find(&beacons)
	db.Find(&renderEvents)
	payloads := model.RenderEventJSONArray(renderEvents)
	c.JSON(http.StatusOK, payloads)
}
