package controller

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestStrToTime(t *testing.T) {
	var err error
	actual, err := strToTime("1556946279372416000")
	assert.Equal(t, nil, err)
	assert.Equal(t, "2019-05-04 05:04:39.372416 +0000 UTC", actual.String())
}
