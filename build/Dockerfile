ARG SDK_Version
FROM karsten13/alexa_sdk_base:$SDK_Version
MAINTAINER Karsten Hassel

ARG WakeWordEngine
ENV WakeWordEngine=$WakeWordEngine

ARG KittAI_Version 
ARG Sensory_Version
RUN if [ "$WakeWordEngine" = "kittai" ]; then \
      cd $BASE/sdk-folder/third-party && git clone --depth 1 -b $KittAI_Version --single-branch https://github.com/Kitt-AI/snowboy.git; \
      # Fix in KittAi source because of compile error (only rpi):
      # https://github.com/alexa/avs-device-sdk/issues/385
      cd $BASE/sdk-folder/sdk-source/avs-device-sdk/KWD/KittAi/src; \
      if [ "$BuildEnv" = "rpi" ]; then \
        sed -i "s:m_maxSamplesPerPush{(audioFormat.sampleRateHz \/ HERTZ_PER_KILOHERTZ) \* msToPushPerIteration.count()}:m_maxSamplesPerPush{(audioFormat.sampleRateHz \/ HERTZ_PER_KILOHERTZ) \* static_cast<unsigned int>(msToPushPerIteration.count())}:" KittAiKeyWordDetector.cpp; \
      fi; \
      # needed since Kitt-AI version 1.3.0	
      cp $BASE/sdk-folder/third-party/snowboy/resources/alexa/alexa-avs-sample-app/alexa.umdl $BASE/sdk-folder/third-party/snowboy/resources/alexa.umdl; \
    elif [ "$WakeWordEngine" = "sensory" ]; then \
      cd $BASE/sdk-folder/third-party && git clone --depth 1 -b $Sensory_Version --single-branch https://github.com/Sensory/alexa-rpi.git; \
      $BASE/sdk-folder/third-party/alexa-rpi/bin/sdk-license file $BASE/sdk-folder/third-party/alexa-rpi/config/license-key.txt $BASE/sdk-folder/third-party/alexa-rpi/lib/libsnsr.a $BASE/sdk-folder/third-party/alexa-rpi/models/spot-alexa-rpi-20500.snsr $BASE/sdk-folder/third-party/alexa-rpi/models/spot-alexa-rpi-21000.snsr $BASE/sdk-folder/third-party/alexa-rpi/models/spot-alexa-rpi-31000.snsr; \
    fi

WORKDIR $BASE/sdk-folder/sdk-build

RUN if [ "$BuildEnv" = "rpi" ]; then \
	  myos=rpi; \
    else \
	  myos=ubuntu64; \
    fi; \
	if [ "$WakeWordEngine" = "kittai" ]; then \
	  buildparams="-DKITTAI_KEY_WORD_DETECTOR=ON -DKITTAI_KEY_WORD_DETECTOR_LIB_PATH=$BASE/sdk-folder/third-party/snowboy/lib/$myos/libsnowboy-detect.a -DKITTAI_KEY_WORD_DETECTOR_INCLUDE_DIR=$BASE/sdk-folder/third-party/snowboy/include"; \
	elif [ "$WakeWordEngine" = "sensory" ]; then \
	  buildparams="-DSENSORY_KEY_WORD_DETECTOR=ON -DSENSORY_KEY_WORD_DETECTOR_LIB_PATH=$BASE/sdk-folder/third-party/alexa-rpi/lib/libsnsr.a	-DSENSORY_KEY_WORD_DETECTOR_INCLUDE_DIR=$BASE/sdk-folder/third-party/alexa-rpi/include"; \
    else \
	  buildparams=""; \
    fi; \
    cmake $BASE/sdk-folder/sdk-source/avs-device-sdk $buildparams \
    -DGSTREAMER_MEDIA_PLAYER=ON \
    -DPORTAUDIO=ON \
    -DPORTAUDIO_LIB_PATH=$BASE/sdk-folder/third-party/portaudio/lib/.libs/libportaudio.a \
    -DPORTAUDIO_INCLUDE_DIR=$BASE/sdk-folder/third-party/portaudio/include \
    -DACSDK_EMIT_SENSITIVE_LOGS=ON \
    -DCMAKE_BUILD_TYPE=DEBUG
 
RUN make SampleApp -j2
 
RUN echo "========== Configuring ALSA Devices ==========" \
 && printf "pcm.!default {\n  type asym\n   playback.pcm {\n     type plug\n     slave.pcm \"hw:0,0\"\n   }\n   capture.pcm {\n     type plug\n     slave.pcm \"hw:1,0\"\n   }\n}" >> /root/.asoundrc

WORKDIR $BASE/sdk-folder

COPY entrypoint.sh .
RUN chmod +x entrypoint.sh

ENTRYPOINT ./entrypoint.sh
