package main

import (
	"fmt"
	"os"

	"github.com/gin-gonic/gin"
	_ "github.com/jinzhu/gorm/dialects/postgres"
	"github.com/kogai/bperf/api/controller"
	"github.com/kogai/bperf/api/middleware"
)

var identityKey = "id"

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

	r.GET("/beacon", controller.BeaconHandler)
	r.GET("/close", controller.CloseHandler)

	chart := r.Group("/chart")
	chart.Use(middleware.JwtMiddleware())
	chart.GET("/events", controller.EventsHandler)

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
