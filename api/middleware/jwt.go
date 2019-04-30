package middleware

import (
	"fmt"
	"net/http"

	auth0 "github.com/auth0-community/go-auth0"
	"github.com/gin-gonic/gin"
	"gopkg.in/square/go-jose.v2"
)

// JwtMiddleware is not documented.
func JwtMiddleware() gin.HandlerFunc {
	client := auth0.NewJWKClient(auth0.JWKClientOptions{URI: fmt.Sprintf("https://%s/.well-known/jwks.json", ensureEnv("AUTH0_DOMAIN", nil))}, nil)
	audience := ensureEnv("AUTH0_CLIENT_ID", nil)
	configuration := auth0.NewConfiguration(client, []string{audience}, fmt.Sprintf("https://%s/", ensureEnv("AUTH0_DOMAIN", nil)), jose.RS256)
	validator := auth0.NewValidator(configuration, nil)

	return func(c *gin.Context) {
		token, err := validator.ValidateRequest(c.Request)
		if err != nil {
			c.AbortWithStatus(http.StatusUnauthorized)
		}
		c.Set("token", token)
		c.Next()
	}
}
