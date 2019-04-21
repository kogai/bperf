package main

// import "log"
// 	log.New()
import "fmt"
import "os"
import "net/http"
import "encoding/json"

func send(w http.ResponseWriter, r *http.Request) {
	type MyRes struct {
		A string `json:"a"`
	}
	res, _ := json.Marshal(MyRes{A: "aaa"})

	w.Header().Set("Content-Type", "application/json")
	w.Header().Set("Access-Control-Allow-Origin", "*")

	_, err := w.Write(res)
	if err != nil {
		_ = fmt.Errorf("%s", err)
	}
	fmt.Printf("%s", res)
}

func main() {
	port := "5000"
	if p := os.Getenv("PORT"); p != "" {
		port = p
	}
	fmt.Printf("Server just started at PORT=%s", port)

	http.HandleFunc("/send", send)
	http.ListenAndServe(fmt.Sprintf(":%s", port), nil)
}
