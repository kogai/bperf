package controller

import (
	"fmt"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
	"github.com/jinzhu/gorm"
	"github.com/kogai/bperf/api/model"
)

// BeaconHandler is not documented.
func BeaconHandler(c *gin.Context) {
	db := c.MustGet("db").(*gorm.DB)
	e := c.Query("e")
	switch e {
	case "childList", "attributes", "characterData":
		time, _ := strconv.ParseFloat(c.Query("t"), 64)
		eventType, _ := model.ToEventType(e)
		ins := model.RenderEvent{Time: int64(time), EventType: eventType}
		db.Create(&ins)
	case "frame", "paint":
		start, _ := strconv.ParseFloat(c.Query("start"), 64)
		end, _ := strconv.ParseFloat(c.Query("end"), 64)
		eventType, _ := model.ToRenderDurationType(e)
		ins := model.RenderDuration{StartTime: int64(start), EndTime: int64(end), EventType: eventType}
		db.Create(&ins)
	case "resource":
		start, _ := strconv.ParseFloat(c.Query("start"), 64)
		end, _ := strconv.ParseFloat(c.Query("end"), 64)
		ins := model.NetworkEvent{StartTime: int64(start), EndTime: int64(end)}
		db.Create(&ins)
	default:
		fmt.Printf("Beacon [%s] does not supported yet.\n", e)
	}

	c.JSON(http.StatusOK, gin.H{})
}
