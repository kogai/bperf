package main

import (
	"database/sql"
	"fmt"
	"net/http"
	"os"
	"strconv"
	"time"

	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
	"github.com/jinzhu/gorm"
	_ "github.com/jinzhu/gorm/dialects/postgres"
	"github.com/kogai/bperf/api/model"
)

func initDatabase() error {
	var err error
	user := ensureEnv("DB_USER", nil)
	host := ensureEnv("DB_HOST", nil)
	password := ensureEnv("DB_PASSWORD", nil)
	dbname := ensureEnv("DB_DATABASE", nil)

	conn, err := sql.Open("postgres", fmt.Sprintf("host=%s user=%s password=%s sslmode=disable", host, user, password))
	if err != nil {
		return err
	}
	defer conn.Close()

	_, err = conn.Exec(fmt.Sprintf("create database %s;", dbname))
	if err != nil {
		if err.Error() == fmt.Sprintf("pq: database \"%s\" already exists", dbname) {
			return nil
		}
		return err
	}
	return nil
}

func establishConnection() (*gorm.DB, error) {
	var err error
	user := ensureEnv("DB_USER", nil)
	host := ensureEnv("DB_HOST", nil)
	dbname := ensureEnv("DB_DATABASE", nil)
	password := ensureEnv("DB_PASSWORD", nil)

	conn, err := gorm.Open("postgres", fmt.Sprintf("host=%s user=%s dbname=%s password=%s sslmode=disable", host, user, dbname, password))
	if err != nil {
		return nil, err
	}

	conn.AutoMigrate(&model.Beacon{})
	conn.AutoMigrate(&model.User{})
	conn.LogMode(true)

	return conn, err
}

func beaconHandler(c *gin.Context) {
	db := c.MustGet("db").(*gorm.DB)
	time, _ := strconv.ParseFloat(c.Query("t"), 64)
	eventType := c.Query("e")

	bcn := model.Beacon{Time: int64(time), EventType: eventType, UserID: 1}
	db.Create(&bcn)

	c.JSON(http.StatusOK, gin.H{})
}

func eventsHandler(c *gin.Context) {
	db := c.MustGet("db").(*gorm.DB)

	var beacons []model.Beacon
	db.Where("event_type = ?", "childList").Limit(50).Find(&beacons)
	var payloads []model.BeaconJSON
	for _, b := range beacons {
		payloads = append(payloads, model.BeaconToJSON(&b))
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

func dbMiddleWare(db *gorm.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		c.Set("db", db)
		c.Next()
	}
}

func setRouter() (*gin.Engine, error) {
	var err error
	r := gin.Default()
	err = initDatabase()
	if err != nil {
		return nil, err
	}
	conn, err := establishConnection()
	if err != nil {
		return nil, err
	}

	r.Use(dbMiddleWare(conn))
	r.Use(cors.New(cors.Config{
		AllowAllOrigins:  true,
		ExposeHeaders:    []string{"Content-Length"},
		AllowCredentials: true,
		MaxAge:           12 * time.Hour,
	}))

	r.GET("/events", eventsHandler)
	r.GET("/beacon", beaconHandler)
	r.GET("/close", func(c *gin.Context) {
		fmt.Printf("on close event occurred.\n")
	})
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
	fmt.Printf("API Server has been started at :%s\n", port)
	err = r.Run()
	if err != nil {
		panic(err)
	}
}
