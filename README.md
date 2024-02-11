# mqtt_learning

A project for learning the basics of MQTT on client (Dart/Flutter) and server (Go).

## Setup & running the apps

### Setup env

1. Copy the env template and call it `.env`:

	```shell
	cp .env.template .env
	```

2. Find out the local IP address of your server machine:
	```shell
	ifconfig | grep inet
	```

3. Fill out the .env file. The only variable that _has_ to be changed is `SERVER_URI`.

4. Symlink or copy the `.env` file to `client`.
   
   ```shell
   ln -s .env ./client/.env
   cp .env ./client/.env
   ```

### Server

1. Install deps:
   ```shell
   cd server && go mod download
   ```

2. Run the server:
   ```shell
   go run ./cmd/mqtt-server.go
   ```

### Client

1. Install deps:
	
	```shell
	flutter pub get
	```

2. Run the app:

	```shell
	flutter run
	```


#### Notes

- Only tested on a real Android device + server hosted on the dev machine.
