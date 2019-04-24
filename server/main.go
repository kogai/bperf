package main

import (
	"encoding/json"
	"fmt"
	"net/http"
	"os"
	"strconv"

	"github.com/jinzhu/gorm"
	_ "github.com/jinzhu/gorm/dialects/postgres"
	_ "github.com/lib/pq"
)

type Product struct {
	gorm.Model
	Code  string
	Price uint
}

type beacon struct {
	EventType string `json:"eventType"`
	Time      int64  `json:"time"`
}

var db = make([]beacon, 0)

func initDb() (*gorm.DB, error) {
	user := ensureEnv("DB_USER", nil)
	host := ensureEnv("DB_HOST", nil)
	dbname := ensureEnv("DB_DATABASE", nil)
	password := ensureEnv("DB_PASSWORD", nil)
	var err error
	conn, err := gorm.Open("postgres", fmt.Sprintf("host=%s user=%s dbname=%s password=%s sslmode=disable", host, user, dbname, password))
	return conn, err
}

func beaconHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	w.Header().Set("Access-Control-Allow-Origin", "*")
	time, _ := strconv.ParseFloat(r.URL.Query().Get("t"), 64)
	eventType := r.URL.Query().Get("e")

	b := beacon{Time: int64(time), EventType: eventType}
	db = append(db, b)

	_, err := w.Write(make([]byte, 0))
	if err != nil {
		_ = fmt.Errorf("%s", err)
	}
}

func eventsHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	w.Header().Set("Access-Control-Allow-Origin", "*")

	payload, _ := json.Marshal(db)

	_, err := w.Write(payload)
	if err != nil {
		_ = fmt.Errorf("%s", err)
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

	var product Product
	conn.First(&product, 1)
	conn.First(&product, "code = ?", "L1212")
	fmt.Printf("%v\n", product)

	http.HandleFunc("/events", eventsHandler)
	http.HandleFunc("/beacon", beaconHandler)
	http.HandleFunc("/close", func(w http.ResponseWriter, r *http.Request) {
		fmt.Printf("on close event occurred.\n")
	})

	fmt.Printf("API Server has been started at :%s\n", port)
	err = http.ListenAndServe(fmt.Sprintf(":%s", port), nil)
	if err != nil {
		panic(err)
	}
}
