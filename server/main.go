package main

import (
	"fmt"
	"net/http"
	"os"
	"strconv"
)

type beacon struct {
	eventType string
	time      int16
}

func send(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	w.Header().Set("Access-Control-Allow-Origin", "*")
	time, _ := strconv.ParseFloat(r.URL.Query().Get("t"), 64)
	eventType := r.URL.Query().Get("e")

	b := beacon{time: int16(time), eventType: eventType}
	fmt.Println(fmt.Sprintf("%v", b))

	_, err := w.Write(make([]byte, 0))
	if err != nil {
		_ = fmt.Errorf("%s", err)
	}
}

func main() {
	port := "5000"
	if p := os.Getenv("PORT"); p != "" {
		port = p
	}

	http.HandleFunc("/beacon", send)
	http.ListenAndServe(fmt.Sprintf(":%s", port), nil)
}
