package main

import (
	"log"
	"os"
	"os/signal"
	"strconv"
	"syscall"

	mqtt "github.com/mochi-mqtt/server/v2"
	"github.com/mochi-mqtt/server/v2/hooks/auth"
	"github.com/mochi-mqtt/server/v2/listeners"

	"github.com/golobby/dotenv"
)

type Config struct {
	Server struct {
		Port int    `env:"SERVER_PORT"`
		Id   string `env:"SERVER_ID"`
	}
}

func main() {
	config, err := loadConfig("../.env")
	if err != nil {
		log.Fatal("Error loading .env file")
	}

	done := setupStopSignal()

	server, err := createMqttServer(config)
	if err != nil {
		log.Fatal(err)
	}

	go func() {
		err := server.Serve()
		if err != nil {
			log.Fatal(err)
		}
	}()

	<-done
}

func loadConfig(envFilePath string) (*Config, error) {
	config := Config{}
	file, err := os.Open(envFilePath)
	if err != nil {
		return nil, err
	}

	err = dotenv.NewDecoder(file).Decode(&config)
	if err != nil {
		return nil, err
	}

	return &config, nil
}

func setupStopSignal() chan bool {
	osSignals := make(chan os.Signal, 1)
	done := make(chan bool, 1)

	signal.Notify(osSignals, syscall.SIGINT, syscall.SIGABRT, syscall.SIGTERM)

	go func() {
		<-osSignals
		done <- true
	}()

	return done
}

func createMqttServer(config *Config) (*mqtt.Server, error) {
	server := mqtt.New(nil)

	_ = server.AddHook(new(auth.AllowHook), nil)

	uri := ":" + strconv.Itoa(config.Server.Port)
	ws := listeners.NewWebsocket(config.Server.Id, uri, nil)
	err := server.AddListener(ws)
	if err != nil {
		return nil, err
	}

	return server, nil
}
