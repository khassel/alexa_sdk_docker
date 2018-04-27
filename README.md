# Run alexa as docker image

## Setup for raspberry-pi

### Requirements
[please read the wiki-section](https://github.com/khassel/alexa_docker/wiki/Prepare-your-raspberry-pi)

The setup for graphical desktop is not needed.

### Setup alexa docker image
-	```bash
	git clone --depth 1 -b rpi_v1.6 https://github.com/khassel/alexa_sdk_docker.git ~/alexa
	```
	
-	```bash
	docker pull karsten13/alexa_sdk:rpi_v1.6
	```
	
## Setup for linux
### Requirements
- [Docker](https://docs.docker.com/engine/installation/)
- [docker-compose](https://docs.docker.com/compose/install/)


### Setup alexa docker image
-	```bash
	git clone --depth 1 -b ubuntu64_v1.6 https://github.com/khassel/alexa_sdk_docker.git ~/alexa
	```
	
-	```bash
	docker pull karsten13/alexa_sdk:ubuntu64_v1.6
	```

## Next setup steps for raspberry-pi and linux
	
-	Before starting the container you need to put a valid "AlexaClientSDKConfig.json" file into the folder ~/alexa/run. If you have this file you can skip the next steps in this section.
-   Otherwise you have to create the "AlexaClientSDKConfig.json" file. You find a template in ~/alexa/run, copy it to "AlexaClientSDKConfig.json".

	```bash
	nano ~/alexa/run/AlexaClientSDKConfig.json
	```
	Set the params "clientSecret", "clientId" and "productId". How to get these values? See the documentation [here](https://github.com/alexa/avs-device-sdk/wiki/Ubuntu-Linux-Quick-Start-Guide) for more info (Register a Device).
-	Now you have to obtain a valid refresh token. Start the docker container with
	```bash
	docker-compose -f token_docker-compose.yml up
	```
-   Wait for this message
	```bash
	Creating al ... done
	Attaching to al
	al       |  * Running on http://127.0.0.1:3000/ (Press CTRL+C to quit)
	```
-	Open the url in a browser on the same machine. Log in with your amazon credentials, wait until your browser show the lines
	```bash
	The file is written successfully.	
	Server is shutting down, so you can close this window.
	```
-	Shutdown the docker container with
	```bash
	docker-compose down
	```
	
### Starting alexa docker container
- goto ```cd ~/alexa/run``` and execute ```docker-compose up -d```
- in case you want to stop it ```docker-compose down```
- give Alexa ~30 sec. to start, then you can talk with her.


> The container is configured to restart automatically so after executing ```docker-compose up -d``` it will restart with every reboot of your machine.

### Alternative wakeword with Kitt-AI
[As described here](https://github.com/khassel/alexa_docker/wiki/Alternative-WakeWord-with-Kitt-AI) you have to map your own pdml file into the container.
Therefore you have to comment out this line 
```bash
#      - ./Hilde.pmdl:/srv/sdk-folder/third-party/snowboy/resources/alexa.umdl
```
in ~/alexa/run/docker-compose.yml and replace "Hilde.pdml" with your "xy.pdml". The xy.pdml is expected in ~/alexa/run.
Additionally you have to set the environment parameter 
```bash
KITT_AI_APPLY_FRONT_END_PROCESSING=false
```
and play with the KITT_AI_SENSITIVITY parameter until it fits (default is 0.6, for "Hilde.pdml" the results are better with 0.47).