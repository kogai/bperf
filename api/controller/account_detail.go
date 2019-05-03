package controller

import (
	"fmt"
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/jinzhu/gorm"
	m "github.com/kogai/bperf/api/model"
)

// AccountDetailJSON is not documented.
type AccountDetailJSON struct {
	// TODO:
	// ProductName       string      `json:"productName"`
	// ScriptID          string      `json:"scriptId"`
	// MonitoringTargets []string    `json:"monitoringTargets"`
	// PricePlan         m.PricePlan `json:"pricePlan"`
	Privilege m.Privilege `json:"privilege"`
	Mail      string      `json:"mail"`
}

// AccountDetailHandler is not documented.
func AccountDetailHandler(c *gin.Context) {
	db := c.MustGet("db").(*gorm.DB)
	accessToken := c.GetHeader("Access-Token")
	userInfo, err := retrieveOpenID(accessToken)
	if err != nil {
		fmt.Printf("%v", err)
		c.AbortWithStatus(http.StatusUnauthorized)
		return
	}

	var user m.User
	result := db.Where("platform_id = ?", userInfo.Sub).Find(&user)
	if result.Error != nil {
		c.JSON(http.StatusOK, gin.H{})
		return
	}

	response := AccountDetailJSON{
		Privilege: user.Privilege,
		Mail:      userInfo.Email,
	}

	c.JSON(http.StatusOK, response)
}
