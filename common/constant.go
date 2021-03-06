package common

import (
	"time"

	"github.com/peaqnetwork/peaq-network-ev-charging-message-format/golang/message"
)

const (
	// ConnectionBufSize is the number of incoming messages to buffer.
	ConnectionBufSize = 128

	// DiscoveryInterval is how often we re-publish our mDNS records.
	DiscoveryInterval = time.Hour

	// DiscoveryServiceTag is used in our mDNS advertisements to discover other chat peers.
	DiscoveryServiceTag = "charmev"

	// Subscription topic
	TOPIC = "charmev"

	// REDIS CONFIGS
	Host       = "127.0.0.1"
	Port       = "6379"
	PubChannel = "IN"
	SubChannel = "OUT"
	// A ping is set to the server with this period to test for the health of
	// the connection and server.
	HealthCheckPeriod = time.Minute
)

var (
	EventsPeerCanSend = map[message.EventType]struct{}{
		message.EventType_IDENTITY_CHALLENGE:   {},
		message.EventType_SERVICE_REQUESTED:    {},
		message.EventType_STOP_CHARGE:          {},
		message.EventType_SERVICE_DELIVERY_ACK: {},
	}

	EventsPeerCanReceive = map[message.EventType]struct{}{
		message.EventType_CHARGING_STATUS:      {},
		message.EventType_IDENTITY_RESPONSE:    {},
		message.EventType_SERVICE_DELIVERED:    {},
		message.EventType_SERVICE_REQUEST_ACK:  {},
		message.EventType_STOP_CHARGE_RESPONSE: {},
	}
)
