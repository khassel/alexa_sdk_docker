# Run alexa as docker image

## Setup for raspberry-pi

### Requirements
[please read the wiki-section](https://github.com/khassel/alexa_docker/wiki/Prepare-your-raspberry-pi)

The setup for graphical desktop is not needed.

### Setup alexa docker image
-	```bash
	git clone --depth 1 -b rpi https://github.com/khassel/alexa_sdk_docker.git ~/alexa
	```
	
-	```bash
	docker pull karsten13/alexa_sdk:rpi
	```
	
## Setup for linux
### Requirements
- [Docker](https://docs.docker.com/engine/installation/)
- [docker-compose](https://docs.docker.com/compose/install/)


### Setup alexa docker image
-	```bash
	git clone --depth 1 -b ubuntu64 https://github.com/khassel/alexa_sdk_docker.git ~/alexa
	```
	
-	```bash
	docker pull karsten13/alexa_sdk:ubuntu64
	```

## Next setup steps for raspberry-pi and linux
	
-	Before starting the container you need to put a valid "AlexaClientSDKConfig.json"-file into the folder ~/alexa/run. If you have this file you can skip the next steps in this section.
-   Otherwise you have to create the "AlexaClientSDKConfig.json"-file. You find a template in ~/alexa/run, copy it to "AlexaClientSDKConfig.json".

	```bash
	nano ~/alexa/run/AlexaClientSDKConfig.json
	```
	Set the params "clientSecret", "clientId" and "productId". How to get these values? See the documentation [here](https://github.com/alexa/avs-device-sdk/wiki/Ubuntu-Linux-Quick-Start-Guide) for more info (Register a Device).
-	Now you have to obtain a valid refresh token. Details coming soon ...
	
### Starting alexa docker container
- goto ```cd ~/alexa/run``` and execute ```docker-compose up -d```
- in case you want to stop it ```docker-compose down```
- give Alexa ~30 sec. to start, then you can talk with her.


> The container is configured to restart automatically so after executing ```docker-compose up -d``` it will restart with every reboot of your machine.

### Alternative wakeword with Kitt-AI
Details coming soon ...
