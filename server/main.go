package main

import (
	"encoding/json"
	"fmt"
	"net/http"
	"os"
	"strconv"
)

type beacon struct {
	EventType string `json:"eventType"`
	Time      int16  `json:"time"`
}

var db = make([]beacon, 0)

func beaconHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	w.Header().Set("Access-Control-Allow-Origin", "*")
	time, _ := strconv.ParseFloat(r.URL.Query().Get("t"), 64)
	eventType := r.URL.Query().Get("e")

	b := beacon{Time: int16(time), EventType: eventType}
	db = append(db, b)
	fmt.Println(fmt.Sprintf("%v", db))

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

func main() {
	port := "5000"
	if p := os.Getenv("PORT"); p != "" {
		port = p
	}

	http.HandleFunc("/events", eventsHandler)
	http.HandleFunc("/beacon", beaconHandler)
	http.ListenAndServe(fmt.Sprintf(":%s", port), nil)
}
