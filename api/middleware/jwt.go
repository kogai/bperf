package middleware

import (
	"fmt"
	"net/http"

	auth0 "github.com/auth0-community/go-auth0"
	"github.com/gin-gonic/gin"
	"github.com/kogai/bperf/api/service"
	"gopkg.in/square/go-jose.v2"
)

// JwtMiddleware is not documented.
func JwtMiddleware() gin.HandlerFunc {
	client := auth0.NewJWKClient(auth0.JWKClientOptions{URI: fmt.Sprintf("https://%s/.well-known/jwks.json", service.EnsureEnv("AUTH0_DOMAIN", nil))}, nil)
	audience := service.EnsureEnv("AUTH0_CLIENT_ID", nil)
	configuration := auth0.NewConfiguration(client, []string{audience}, fmt.Sprintf("https://%s/", service.EnsureEnv("AUTH0_DOMAIN", nil)), jose.RS256)
	validator := auth0.NewValidator(configuration, nil)

	return func(c *gin.Context) {
		token, err := validator.ValidateRequest(c.Request)
		if err != nil {
			c.AbortWithStatus(http.StatusUnauthorized)
			c.Next()
			return
		}
		c.Set("token", token)
		c.Next()
	}
}
