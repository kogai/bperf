package controller

import (
	"fmt"

	"github.com/gin-gonic/gin"
)

// CloseHandler is not documented.
func CloseHandler(c *gin.Context) {
	fmt.Printf("on close event occurred.\n")
}
