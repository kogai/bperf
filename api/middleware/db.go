package middleware

import (
	"database/sql"
	"fmt"

	"github.com/gin-gonic/gin"
	"github.com/jinzhu/gorm"
	"github.com/kogai/bperf/api/model"
	"github.com/kogai/bperf/api/service"
)

// InitDatabase is not documented.
func InitDatabase() error {
	var err error
	user := service.EnsureEnv("DB_USER", nil)
	port := service.EnsureEnv("DB_PORT", nil)
	host := service.EnsureEnv("DB_HOST", nil)
	password := service.EnsureEnv("DB_PASSWORD", nil)
	dbname := service.EnsureEnv("DB_DATABASE", nil)

	conn, err := sql.Open("postgres", fmt.Sprintf("-p %s host=%s user=%s password=%s sslmode=disable", port, host, user, password))
	if err != nil {
		return err
	}
	defer conn.Close()

	_, err = conn.Exec(fmt.Sprintf("create database %s;", dbname))
	if err != nil {
		if err.Error() == fmt.Sprintf("pq: database \"%s\" already exists", dbname) {
			return nil
		}
		return err
	}
	return nil
}

// EstablishConnection is not documented.
func EstablishConnection() (*gorm.DB, error) {
	var err error
	user := service.EnsureEnv("DB_USER", nil)
	host := service.EnsureEnv("DB_HOST", nil)
	dbname := service.EnsureEnv("DB_DATABASE", nil)
	password := service.EnsureEnv("DB_PASSWORD", nil)

	conn, err := gorm.Open("postgres", fmt.Sprintf("host=%s user=%s dbname=%s password=%s sslmode=disable", host, user, dbname, password))
	if err != nil {
		return nil, err
	}

	_ = conn.Exec("CREATE TYPE price_plan AS ENUM ('free', 'developer', 'enterprise');")
	_ = conn.Exec("CREATE TYPE event_type AS ENUM ('childList', 'attributes', 'characterData');")
	_ = conn.Exec("CREATE TYPE render_duration_event AS ENUM ('frame', 'paint');")
	_ = conn.Exec("CREATE TYPE privilege AS ENUM ('admin', 'developer', 'observer');")

	conn.AutoMigrate(&model.MemoryUsage{})
	conn.AutoMigrate(&model.MonitoringTarget{})
	conn.AutoMigrate(&model.NetworkEvent{})
	conn.AutoMigrate(&model.Product{})
	conn.AutoMigrate(&model.RenderEvent{})
	conn.AutoMigrate(&model.RenderDuration{})
	conn.AutoMigrate(&model.Session{})
	conn.AutoMigrate(&model.UaOs{})
	conn.AutoMigrate(&model.User{})
	conn.LogMode(true)

	return conn, err
}

// DbMiddleware is not documented.
func DbMiddleware(db *gorm.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		c.Set("db", db)
		c.Next()
	}
}
