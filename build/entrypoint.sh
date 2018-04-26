#!/bin/bash

# Audio-Output
if [ "$Audio" == "3.5mm" ]; then
  amixer cset numid=3 1
  echo "Audio forced to 3.5mm jack."
else
  amixer cset numid=3 2
  echo "Audio forced to HDMI."
fi

cp /srv/sdk-folder/sdk-source/avs-device-sdk/Integration/AlexaClientSDKConfig.json .
sed -i "s:\${SDK_CBL_AUTH_DELEGATE_DATABASE_FILE_PATH}:$SDK_CBL_AUTH_DELEGATE_DATABASE_FILE_PATH:" ./AlexaClientSDKConfig.json
sed -i "s:\${SDK_CONFIG_DEVICE_SERIAL_NUMBER}:$SDK_CONFIG_DEVICE_SERIAL_NUMBER:" ./AlexaClientSDKConfig.json
sed -i "s:\${SDK_CONFIG_CLIENT_ID}:$SDK_CONFIG_CLIENT_ID:" ./AlexaClientSDKConfig.json
sed -i "s:\${SDK_CONFIG_PRODUCT_ID}:$SDK_CONFIG_PRODUCT_ID:" ./AlexaClientSDKConfig.json
sed -i "s:\${SDK_MISC_DATABASE_FILE_PATH}:$SDK_MISC_DATABASE_FILE_PATH:" ./AlexaClientSDKConfig.json
sed -i "s:\${SDK_SQLITE_DATABASE_FILE_PATH}:$SDK_SQLITE_DATABASE_FILE_PATH:" ./AlexaClientSDKConfig.json
sed -i "s:\${SDK_SQLITE_SETTINGS_DATABASE_FILE_PATH}:$SDK_SQLITE_SETTINGS_DATABASE_FILE_PATH:" ./AlexaClientSDKConfig.json
sed -i "s:\${SETTING_LOCALE_VALUE}:$SETTING_LOCALE_VALUE:" ./AlexaClientSDKConfig.json
sed -i "s:\${SDK_CERTIFIED_SENDER_DATABASE_FILE_PATH}:$SDK_CERTIFIED_SENDER_DATABASE_FILE_PATH:" ./AlexaClientSDKConfig.json
sed -i "s:\${SDK_NOTIFICATIONS_DATABASE_FILE_PATH}:$SDK_NOTIFICATIONS_DATABASE_FILE_PATH:" ./AlexaClientSDKConfig.json

cd ./sdk-build

if [ "$KITT_AI_SENSITIVITY" != "0.6" ] || [ "$KITT_AI_APPLY_FRONT_END_PROCESSING" != "true" ]; then
  # file nur patchen wenn notwendig
  sed -i "s:KITT_AI_SENSITIVITY = 0.6:KITT_AI_SENSITIVITY = $KITT_AI_SENSITIVITY:" /srv/sdk-folder/sdk-source/avs-device-sdk/KWD/KWDProvider/src/KeywordDetectorProvider.cpp
  sed -i "s:KITT_AI_APPLY_FRONT_END_PROCESSING = true:KITT_AI_APPLY_FRONT_END_PROCESSING = $KITT_AI_APPLY_FRONT_END_PROCESSING:" /srv/sdk-folder/sdk-source/avs-device-sdk/KWD/KWDProvider/src/KeywordDetectorProvider.cpp
  make SampleApp -j2
fi  

cd ./SampleApp/src \
  && ./SampleApp \
  /srv/sdk-folder/AlexaClientSDKConfig.json \
  /srv/sdk-folder/third-party/snowboy/resources $1
