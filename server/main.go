package main

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"net/http"
	"os"
	"strconv"

	_ "github.com/lib/pq"
)

type beacon struct {
	EventType string `json:"eventType"`
	Time      int64  `json:"time"`
}

var conn *sql.DB
var db = make([]beacon, 0)

func initDb() {
	user := ensureEnv("DB_USER", nil)
	dbname := ensureEnv("DB_DATABASE", nil)
	password := ensureEnv("DB_PASSWORD", nil)
	var err error
	conn, err = sql.Open("postgres", fmt.Sprintf("user=%s dbname=%s password=%s sslmode=disable", user, dbname, password))
	if err != nil {
		panic(err)
	}
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
	initDb()

	_, err = conn.Query("SELECT name FROM users WHERE email = $1", "a@a.com")
	if err != nil {
		panic(err)
	}

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
