package main

// import "log"
// 	log.New()
import "time"
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
	time.Sleep(time.Duration(1 * time.Second)) // Emulate distance of remote server.

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

	http.HandleFunc("/send", send)
	http.ListenAndServe(fmt.Sprintf(":%s", port), nil)
}
