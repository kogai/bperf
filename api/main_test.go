package main

import (
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/gin-gonic/gin"
	"github.com/stretchr/testify/assert"
)

func TestBeaconHandler(t *testing.T) {
	var err error
	preRouter := gin.Default()
	router, err := setRouter(preRouter)
	assert.Equal(t, nil, err)

	w := httptest.NewRecorder()
	r, err := http.NewRequest("GET", "/beacon", nil)
	router.ServeHTTP(w, r)

	assert.Equal(t, nil, err)
	assert.Equal(t, 200, w.Code)
	assert.Equal(t, "{}", w.Body.String())
}
