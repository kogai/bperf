package controller

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/jinzhu/gorm"
	"github.com/kogai/bperf/api/model"
)

// NetworksHandler is not documented.
func NetworksHandler(c *gin.Context) {
	db := c.MustGet("db").(*gorm.DB)

	var xs []model.NetworkEvent
	db.Find(&xs)
	payloads := model.NetworkEventJSONArray(xs)
	c.JSON(http.StatusOK, payloads)
}
