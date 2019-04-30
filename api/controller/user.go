package controller

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/jinzhu/gorm"
	"github.com/kogai/bperf/api/model"
)

// UserParams is not documented.
type UserParams struct {
	OpenID string `json:"openId"`
}

// UserHandler is not documented.
func UserHandler(c *gin.Context) {
	db := c.MustGet("db").(*gorm.DB)
	var params UserParams
	err := c.BindJSON(&params)
	if err != nil {
		c.AbortWithStatus(http.StatusBadRequest)
		return
	}
	ins := model.User{PlatformID: params.OpenID, Products: []model.Product{}, Privilege: "admin"}
	res := db.Create(&ins)
	if res.Error != nil {
		c.AbortWithStatus(http.StatusInternalServerError)
		return
	}
	c.JSON(http.StatusOK, gin.H{})
}
