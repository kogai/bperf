package main

// import "log"
// 	log.New()

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"net/url"
	"os"
)

func toJSON(m interface{}) []byte {
	js, err := json.Marshal(m)
	if err != nil {
		log.Fatal(err)
	}
	return js
}

type beacon struct {
	Time float64 `json:"time"`
}

func send(w http.ResponseWriter, r *http.Request) {
	type MyRes struct {
		A string `json:"a"`
	}

	res, _ := json.Marshal(MyRes{A: "aaa"})

	w.Header().Set("Content-Type", "application/json")
	w.Header().Set("Access-Control-Allow-Origin", "*")
	// time.Sleep(time.Duration(1 * time.Second)) // Emulate distance of remote server.

	js, _ := url.ParseQuery(r.URL.RawQuery)
	bytes, _ := json.Marshal(js)
	var b beacon
	_ = json.Unmarshal(bytes, &b)
	fmt.Printf("Time %v", b.Time)

	_, err := w.Write(res)
	if err != nil {
		_ = fmt.Errorf("%s", err)
	}
	fmt.Println(fmt.Sprintf("%s", res))
}

func main() {
	port := "5000"
	if p := os.Getenv("PORT"); p != "" {
		port = p
	}
	fmt.Printf("Server just started at PORT=%s\n", port)
	js, _ := url.ParseQuery("time=99")

	fmt.Printf("%v %v\n", js, js.Get("time"))
	bytes, _ := json.Marshal(js)
	var b beacon
	e := json.Unmarshal(bytes, &b)

	fmt.Printf("E %v\n", e)
	fmt.Printf("Time %v", b.Time)

	http.HandleFunc("/beacon", send)
	http.ListenAndServe(fmt.Sprintf(":%s", port), nil)
}
