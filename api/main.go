package main

import (
	"fmt"
	"net/http"
	"os"
	"strconv"

	"github.com/gin-gonic/gin"
	"github.com/jinzhu/gorm"
	_ "github.com/jinzhu/gorm/dialects/postgres"
	"github.com/kogai/bperf/api/middleware"
	"github.com/kogai/bperf/api/model"
)

var identityKey = "id"

func beaconHandler(c *gin.Context) {
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

func eventsHandler(c *gin.Context) {
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

func ensureEnv(name string, defaultValue interface{}) string {
	v := os.Getenv(name)

	if v == "" && nil == defaultValue {
		panic(fmt.Sprintf("An environment variable [%s] must be defined.", name))
	}
	if v == "" && nil != defaultValue {
		return defaultValue.(string)
	}
	return v
}

func setRouter() (*gin.Engine, error) {
	var err error
	r := gin.Default()
	err = middleware.InitDatabase()
	if err != nil {
		return nil, err
	}
	conn, err := middleware.EstablishConnection()
	if err != nil {
		return nil, err
	}

	r.Use(middleware.DbMiddleware(conn))
	r.Use(middleware.CorsMiddleware())

	r.GET("/beacon", beaconHandler)
	r.GET("/close", func(c *gin.Context) {
		fmt.Printf("on close event occurred.\n")
	})

	chart := r.Group("/chart")
	chart.Use(middleware.JwtMiddleware())
	chart.GET("/events", eventsHandler)

	return r, nil
}

func main() {
	var err error
	r, err := setRouter()
	if err != nil {
		panic(err)
	}
	// defer conn.Close()

	port := ensureEnv("PORT", "5000")
	err = r.Run(fmt.Sprintf(":%s", port))
	if err != nil {
		panic(err)
	}
}
