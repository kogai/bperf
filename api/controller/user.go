package controller

import (
	"encoding/json"
	"fmt"
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/jinzhu/gorm"
	"github.com/kogai/bperf/api/model"
	"github.com/kogai/bperf/api/service"
)

// UserParams is not documented.
type UserParams struct {
	AccessToken string `json:"accessToken"`
}

// UserInfo is not documented.
type UserInfo struct {
	Sub           string `json:"sub"`
	Email         string `json:"email"`
	EmailVerified bool   `json:"email_verified"`
}

func retrieveOpenID(accessToken string) (UserInfo, error) {
	var err error
	var u UserInfo
	client := &http.Client{}

	url := fmt.Sprintf("https://%s/userinfo", service.EnsureEnv("AUTH0_DOMAIN", nil))
	req, err := http.NewRequest("GET", url, nil)
	req.Header.Add("Authorization", fmt.Sprintf("Bearer %s", accessToken))
	response, err := client.Do(req)
	if err != nil {
		return u, err
	}
	decoder := json.NewDecoder(response.Body)
	err = decoder.Decode(&u)
	if err != nil {
		return u, err
	}
	return u, nil
}

// UserHandler is not documented.
func UserHandler(c *gin.Context) {
	db := c.MustGet("db").(*gorm.DB)
	var params UserParams
	err := c.BindJSON(&params)
	if err != nil {
		fmt.Printf("%v", err)
		c.AbortWithStatus(http.StatusBadRequest)
		return
	}

	userInfo, err := retrieveOpenID(params.AccessToken)
	if err != nil {
		fmt.Printf("%v", err)
		c.AbortWithStatus(http.StatusInternalServerError)
		return
	}

	ins := model.User{PlatformID: userInfo.Sub, Products: []model.Product{}, Privilege: "admin"}
	result := db.Create(&ins)
	if result.Error != nil {
		// User already registered.
		c.JSON(http.StatusOK, gin.H{})
		return
	}
	c.JSON(http.StatusOK, gin.H{})
}
