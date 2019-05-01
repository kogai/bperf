package controller

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/jinzhu/gorm"
	"github.com/kogai/bperf/api/model"
)

// DurationsHandler is not documented.
func DurationsHandler(c *gin.Context) {
	db := c.MustGet("db").(*gorm.DB)

	var renderEvents []model.RenderDuration
	// db.Where("event_type = ?", "frame").Find(&renderEvents)
	db.Find(&renderEvents)
	payloads := model.RenderDurationJSONArray(renderEvents)
	c.JSON(http.StatusOK, payloads)
}
