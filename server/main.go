package main

import (
	"encoding/json"
	"fmt"
	"net/http"
	"os"
	"strconv"

	"github.com/jinzhu/gorm"
	_ "github.com/jinzhu/gorm/dialects/postgres"
	"github.com/kogai/bperf/server/model"
)

type beacon struct {
	EventType string `json:"eventType"`
	Time      int64  `json:"time"`
}

func initDb() (*gorm.DB, error) {
	user := ensureEnv("DB_USER", nil)
	host := ensureEnv("DB_HOST", nil)
	dbname := ensureEnv("DB_DATABASE", nil)
	password := ensureEnv("DB_PASSWORD", nil)
	var err error
	conn, err := gorm.Open("postgres", fmt.Sprintf("host=%s user=%s dbname=%s password=%s sslmode=disable", host, user, dbname, password))
	return conn, err
}

func beaconHandler(conn *gorm.DB) func(w http.ResponseWriter, r *http.Request) {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		w.Header().Set("Access-Control-Allow-Origin", "*")
		time, _ := strconv.ParseFloat(r.URL.Query().Get("t"), 64)
		eventType := r.URL.Query().Get("e")

		bcn := model.Beacon{Time: int64(time), EventType: eventType, UserID: 1}
		conn.Create(&bcn)

		_, err := w.Write(make([]byte, 0))
		if err != nil {
			panic(err)
		}
	}
}

func eventsHandler(conn *gorm.DB) func(w http.ResponseWriter, r *http.Request) {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		w.Header().Set("Access-Control-Allow-Origin", "*")

		var beacons []model.Beacon
		conn.Find(&beacons)
		var payloads []model.BeaconJson
		for _, b := range beacons {
			payloads = append(payloads, model.BeaconToJson(&b))
		}
		payload, err := json.Marshal(payloads)
		if err != nil {
			panic(err)
		}

		_, err = w.Write(payload)
		if err != nil {
			panic(err)
		}
	}
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

func main() {
	var err error
	port := ensureEnv("PORT", "5000")
	conn, err := initDb()
	if err != nil {
		panic(err)
	}
	defer conn.Close()

	tmpUser := model.User{Email: "bperf@example.com", EncryptedPassword: "***", Beacons: make([]model.Beacon, 0)}
	conn.Create(&tmpUser)
	defer conn.Delete(&tmpUser)

	conn.AutoMigrate(&model.Beacon{})
	conn.AutoMigrate(&model.User{})

	http.HandleFunc("/events", eventsHandler(conn))
	http.HandleFunc("/beacon", beaconHandler(conn))
	http.HandleFunc("/close", func(w http.ResponseWriter, r *http.Request) {
		fmt.Printf("on close event occurred.\n")
	})

	fmt.Printf("API Server has been started at :%s\n", port)
	err = http.ListenAndServe(fmt.Sprintf(":%s", port), nil)
	if err != nil {
		panic(err)
	}
}
