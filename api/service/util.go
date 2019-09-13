package service

import (
	"fmt"
	"os"
	"time"
)

// EnsureEnv is not documented.
func EnsureEnv(name string, defaultValue interface{}) string {
	v := os.Getenv(name)

	if v == "" && nil == defaultValue {
		panic(fmt.Sprintf("An environment variable [%s] must be defined.", name))
	}
	if v == "" && nil != defaultValue {
		return defaultValue.(string)
	}
	return v
}

// TimeToMs is not documented.
func TimeToMs(t time.Time) int64 {
	return t.UnixNano() / 1000000
}

// DurationToMs is not documented.
func DurationToMs(t time.Duration) int64 {
	return t.Nanoseconds() / 1000000
}
