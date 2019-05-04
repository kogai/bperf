package controller

import (
	"testing"
	"time"

	"github.com/stretchr/testify/assert"
)

func TestDurationToJSON(t *testing.T) {
	var err error
	createdAt, err := time.Parse(time.RFC3339, "2019-01-01T00:00:00.000Z")
	assert.Equal(t, nil, err)
	endTime, err := time.Parse(time.RFC3339, "2019-01-01T00:00:00.005Z")
	assert.Equal(t, nil, err)
	base := RenderDurationIntermediate{CreatedAt: createdAt, EndTime: endTime}
	actual := base.toJSON()

	assert.Equal(t, createdAt.Unix(), actual.StartTime)
	assert.Equal(t, int64(5), actual.DurationMs)
}
