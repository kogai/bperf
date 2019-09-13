package controller

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/jinzhu/gorm"
	"github.com/kogai/bperf/api/model"
)

// RenderEventsHandler is not documented.
func RenderEventsHandler(c *gin.Context) {
	var err error
	var isExist bool
	db := c.MustGet("db").(*gorm.DB)
	from, isExist := c.GetQuery("from")
	fromTime, err := strToTime(from)
	if !isExist || err != nil {
		c.AbortWithStatus(http.StatusBadRequest)
		return
	}

	to, isExist := c.GetQuery("to")
	toTime, err := strToTime(to)
	if !isExist || err != nil {
		c.AbortWithStatus(http.StatusBadRequest)
		return
	}

	var renderEvents []model.RenderEvent
	// db.Where("event_type = ?", "childList").Limit(50).Find(&beacons)
	db.Where("time BETWEEN ? AND ?", fromTime, toTime).Find(&renderEvents)
	payloads := model.RenderEventJSONArray(renderEvents)
	c.JSON(http.StatusOK, payloads)
}
