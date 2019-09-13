package controller

import (
	"fmt"
	"net/http"
	"strconv"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/jinzhu/gorm"
	"github.com/kogai/bperf/api/model"
	"github.com/mssola/user_agent"
)

const ms int64 = 1000 * 1000 * 1000

func strToTime(s string) (time.Time, error) {
	var err error
	var t time.Time
	timestamp, err := strconv.ParseInt(s, 10, 64)
	if err != nil {
		return t, err
	}
	// 123456 / 1000 -> 123,123456 % 1000 -> 456
	t = time.Unix(timestamp/ms, timestamp%ms).UTC()
	return t, nil
}

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
		createdAt, err := strToTime(c.Query("timeOrigin"))
		if err != nil {
			c.AbortWithStatus(http.StatusBadRequest)
			return
		}

		session := model.NewSession(sessionID, createdAt)
		uaOs := model.NewUaOs(
			session.ID,
			browserName+":"+browserVersion,
			osInfo.FullName+":"+osInfo.Version,
		)
		db.Create(&session)
		db.Create(&uaOs)

	case "childList", "attributes", "characterData":
		t, err := strToTime(c.Query("t"))
		if err != nil {
			c.AbortWithStatus(http.StatusBadRequest)
			return
		}
		eventType, _ := model.ToEventType(e)
		sessionID := c.Query("id")
		ins := model.NewRenderEvent(sessionID, eventType, t)
		db.Create(&ins)
	case "frame", "paint":
		start, err := strToTime(c.Query("start"))
		if err != nil {
			c.AbortWithStatus(http.StatusBadRequest)
			return
		}
		end, err := strToTime(c.Query("end"))
		if err != nil {
			c.AbortWithStatus(http.StatusBadRequest)
			return
		}
		eventType, _ := model.ToRenderDurationType(e)
		sessionID := c.Query("id")
		name := c.Query("name")
		ins := model.NewRenderDuration(sessionID, eventType, start, end, name)
		db.Create(&ins)
	case "resource":
		start, err := strToTime(c.Query("start"))
		if err != nil {
			c.AbortWithStatus(http.StatusBadRequest)
			return
		}
		end, err := strToTime(c.Query("end"))
		if err != nil {
			c.AbortWithStatus(http.StatusBadRequest)
			return
		}
		sessionID := c.Query("id")
		bodySize, _ := strconv.ParseUint(c.Query("bodySize"), 10, 64)
		name := c.Query("name")
		ins := model.NewNetworkEvent(sessionID, start, end, name, bodySize)
		db.Create(&ins)
	default:
		fmt.Printf("Beacon [%s] does not supported yet.\n", e)
	}

	c.JSON(http.StatusOK, gin.H{})
}
