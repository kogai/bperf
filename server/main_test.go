package main

import (
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestBeaconHandler(t *testing.T) {
	router := setRouter()
	w := httptest.NewRecorder()
	r, err := http.NewRequest("GET", "/beacon", nil)
	router.ServeHTTP(w, r)

	assert.Equal(t, nil, err)
	assert.Equal(t, 200, w.Code)
	assert.Equal(t, "{}", w.Body.String())
}
