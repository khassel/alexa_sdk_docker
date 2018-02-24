#!/bin/bash

# Audio-Output
if [ "$Audio" == "3.5mm" ]; then
  amixer cset numid=3 1
  echo "Audio forced to 3.5mm jack."
else
  amixer cset numid=3 2
  echo "Audio forced to HDMI."
fi

# gehört auf dem Host gesetzt, nicht hier
#if [ "$SetVolumeToMax" == "true" ]; then
#  # Lautstärke 400=Max
#  amixer cset numid=1 400
#fi
#
#if [ "$SetVolumeToMax" == "true" ]; then
#  # Micro Empfindlichkeit 55=Max
#  amixer -c 1 cset numid=3,iface=MIXER,name='Mic Capture Volume' 31,55
#fi  

cd ./sdk-build/SampleApp/src \
  && ./SampleApp \
  /srv/sdk-folder/sdk-build/Integration/AlexaClientSDKConfig.json \
  /srv/sdk-folder/third-party/snowboy/resources/ $1

  