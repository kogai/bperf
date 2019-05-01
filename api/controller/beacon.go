package controller

import (
	"fmt"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
	"github.com/jinzhu/gorm"
	"github.com/kogai/bperf/api/model"
	"github.com/mssola/user_agent"
)

// BeaconHandler is not documented.
func BeaconHandler(c *gin.Context) {
	db := c.MustGet("db").(*gorm.DB)
	e := c.Query("e")
	switch e {
	case "init":
		sessionID := c.Query("id")
		ua := user_agent.New(c.GetHeader("User-Agent"))
		browserName, browserVersion := ua.Browser()
		osInfo := ua.OSInfo()

		session := model.Session{ID: sessionID}
		uaOs := model.UaOs{
			SessionID: session.ID,
			Browser:   browserName + ":" + browserVersion,
			Os:        osInfo.FullName + ":" + osInfo.Version,
		}
		db.Create(&session)
		db.Create(&uaOs)

	case "childList", "attributes", "characterData":
		time, _ := strconv.ParseFloat(c.Query("t"), 64)
		eventType, _ := model.ToEventType(e)
		sessionID := c.Query("id")
		ins := model.RenderEvent{Time: int64(time), EventType: eventType, SessionID: sessionID}
		db.Create(&ins)
	case "frame", "paint":
		start, _ := strconv.ParseFloat(c.Query("start"), 64)
		end, _ := strconv.ParseFloat(c.Query("end"), 64)
		eventType, _ := model.ToRenderDurationType(e)
		sessionID := c.Query("id")
		name := c.Query("name")
		ins := model.RenderDuration{StartTime: int64(start), EndTime: int64(end), EventType: eventType, Name: name, SessionID: sessionID}
		db.Create(&ins)
	case "resource":
		start, _ := strconv.ParseFloat(c.Query("start"), 64)
		end, _ := strconv.ParseFloat(c.Query("end"), 64)
		sessionID := c.Query("id")
		name := c.Query("name")
		ins := model.NetworkEvent{StartTime: int64(start), EndTime: int64(end), Name: name, SessionID: sessionID}
		db.Create(&ins)
	default:
		fmt.Printf("Beacon [%s] does not supported yet.\n", e)
	}

	c.JSON(http.StatusOK, gin.H{})
}
