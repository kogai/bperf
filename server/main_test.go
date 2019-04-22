package main

import (
	"bytes"
	"net/http"
	"net/http/httptest"
	"testing"
)

func TestBeaconHandler(t *testing.T) {
	req, err := http.NewRequest("GET", "/beacon", nil)
	if err != nil {
		t.Fatal(err)
	}

	rr := httptest.NewRecorder()
	handler := http.HandlerFunc(beaconHandler)
	handler.ServeHTTP(rr, req)

	if status := rr.Code; status != http.StatusOK {
		t.Errorf("handler returned wrong status code: got %v want %v",
			status, http.StatusOK)
	}

	expected := make([]byte, 0)
	if !bytes.Equal(rr.Body.Bytes(), expected) {
		t.Errorf("handler returned unexpected body: got %v want %v",
			rr.Body.Bytes(), expected)
	}
}
