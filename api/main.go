package main

import (
	"fmt"
	"os"
	"time"

	"github.com/gin-gonic/gin"
	_ "github.com/jinzhu/gorm/dialects/postgres"
	c "github.com/kogai/bperf/api/controller"
	m "github.com/kogai/bperf/api/middleware"
	s "github.com/kogai/bperf/api/service"
)

func setRouter(r *gin.Engine) (*gin.Engine, error) {
	var err error
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

	account := r.Group("/account")
	account.GET("/detail", c.AccountDetailHandler)

	return r, nil
}

func main() {
	var err error
	r := gin.Default()
	log, err := os.Create(fmt.Sprintf("./tmp/%d.log", time.Now().Unix()))
	if err != nil {
		panic(err)
	}
	r.Use(gin.LoggerWithWriter(log))

	router, err := setRouter(r)
	if err != nil {
		panic(err)
	}
	// defer conn.Close()

	port := s.EnsureEnv("PORT", "5000")
	err = router.Run(fmt.Sprintf(":%s", port))
	if err != nil {
		panic(err)
	}
}
