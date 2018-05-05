# Run alexa as docker image

## Setup for raspberry-pi

### Requirements
[please read the wiki-section](https://github.com/khassel/alexa_docker/wiki/Prepare-your-raspberry-pi)

The setup for graphical desktop is not needed.

### Setup
```
git clone --depth 1 -b rpi_v1.7 https://github.com/khassel/alexa_sdk_docker.git ~/alexa
```
	
## Setup for linux
### Requirements
- [Docker](https://docs.docker.com/engine/installation/)
- [docker-compose](https://docs.docker.com/compose/install/)


### Setup
```
git clone --depth 1 -b ubuntu64_v1.7 https://github.com/khassel/alexa_sdk_docker.git ~/alexa
```

## Next setup steps for both raspberry-pi and linux
### Pull the docker image (also needed for updating the image)
- goto ```cd ~/alexa/run``` and execute ```docker-compose pull```
### Select the WakeWordEngine
Two WakeWordEngines are supported:
- Kitt-AI: Works for linux and raspberry-pi, you can change the WakeWord "Alexa".
- Sensory: Works for raspberry-pi only, you can't change the WakeWord "Alexa".

Kitt-AI is the default-WakeWordEngine. If you want to use Sensory, goto ```cd ~/alexa``` and edit the file .env, set ```WakeWordEngine=sensory```.

### Preparing for the first start of the container

-	Before the first start of the container you need to put valid parameters in the `docker-compose.yml` file in the folder ~/alexa/run. In the environment section of `docker-compose.yml` fill in the following (missing) values:
	```
      - SETTING_LOCALE_VALUE=de-DE
      - SDK_CONFIG_DEVICE_SERIAL_NUMBER=123456
      - SDK_CONFIG_CLIENT_ID=
      - SDK_CONFIG_PRODUCT_ID=
	```
	These values are used in the `AlexaClientSDKConfig.json` file internally. You find more infos about this [here](https://github.com/alexa/avs-device-sdk/wiki/Create-Security-Profile).
-   Now goto ```cd ~/alexa/run``` and execute ```docker-compose up -d```. The container will start, wait a moment and execute ```docker logs al``` to see the logs.
    Search for a similar section in the logs:
	```
    ##################################
    #       NOT YET AUTHORIZED       #
    ##################################
    ################################################################################################
    #       To authorize, browse to: 'https://amazon.com/us/code' and enter the code: {XXXX}       #
    ################################################################################################
	```
	Follow the instructions [here](https://github.com/alexa/avs-device-sdk/wiki/Ubuntu-Linux-Quick-Start-Guide#run-and-authorize)
	beginning with Point 3. to Point 7.
	Execute ```docker logs al``` again to see if the authorization was successful. You should see 
	```
    ########################################
    #       Alexa is currently idle!       #
    ########################################
	```
    Now you can talk with Alexa.
	
### Starting and stopping the alexa docker container
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