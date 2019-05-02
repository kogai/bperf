package main

import (
	"fmt"

	"github.com/gin-gonic/gin"
	_ "github.com/jinzhu/gorm/dialects/postgres"
	c "github.com/kogai/bperf/api/controller"
	m "github.com/kogai/bperf/api/middleware"
	s "github.com/kogai/bperf/api/service"
)

func setRouter() (*gin.Engine, error) {
	var err error
	r := gin.Default()
	err = m.InitDatabase()
	if err != nil {
		return nil, err
	}
	conn, err := m.EstablishConnection()
	if err != nil {
		return nil, err
	}

	r.Use(m.DbMiddleware(conn))
	r.Use(m.CorsMiddleware())

	r.GET("/beacon", c.BeaconHandler)
	r.GET("/close", c.CloseHandler)
	r.POST("/user", c.UserHandler)

	// Authenticated only
	chart := r.Group("/chart")
	chart.Use(m.JwtMiddleware())
	chart.GET("/events", c.EventsHandler)
	chart.GET("/durations", c.DurationsHandler)
	chart.GET("/networks", c.NetworksHandler)
	chart.GET("/sessions", c.SessionsHandler)

	return r, nil
}

func main() {
	var err error
	r, err := setRouter()
	if err != nil {
		panic(err)
	}
	// defer conn.Close()

	port := s.EnsureEnv("PORT", "5000")
	err = r.Run(fmt.Sprintf(":%s", port))
	if err != nil {
		panic(err)
	}
}
