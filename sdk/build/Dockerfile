ARG myimage
FROM $myimage
MAINTAINER Karsten Hassel

RUN apt-get update && apt-get -y install alsa-utils python-pip python
RUN python --version 
RUN pip --version

# todo: https://github.com/alexa/avs-device-sdk/issues/463

RUN pip install --upgrade setuptools
RUN pip install flask commentjson requests

RUN cd $BASE/sdk-folder/sdk-source && git clone --depth 1 -b master --single-branch git://github.com/alexa/avs-device-sdk.git 

RUN cd $BASE/sdk-folder/third-party && git clone --depth 1 -b master --single-branch https://github.com/Kitt-AI/snowboy.git

RUN gcc --version
RUN g++ --version

# Fix im Quelltext wegen compile error (todo: mit sed lösen):
# https://github.com/alexa/avs-device-sdk/issues/385
COPY KittAiKeyWordDetector.cpp $BASE/sdk-folder/sdk-source/avs-device-sdk/KWD/KittAi/src/KittAiKeyWordDetector.cpp

RUN ln -s /usr/lib/atlas-base/atlas/libblas.so.3 /usr/lib/libblas.so

WORKDIR $BASE/sdk-folder/sdk-build

RUN cmake $BASE/sdk-folder/sdk-source/avs-device-sdk \
 -DKITTAI_KEY_WORD_DETECTOR=ON \
 -DKITTAI_KEY_WORD_DETECTOR_LIB_PATH=$BASE/sdk-folder/third-party/snowboy/lib/rpi/libsnowboy-detect.a \
 -DKITTAI_KEY_WORD_DETECTOR_INCLUDE_DIR=$BASE/sdk-folder/third-party/snowboy/include \
 -DGSTREAMER_MEDIA_PLAYER=ON \
 -DPORTAUDIO=ON \
 -DPORTAUDIO_LIB_PATH=$BASE/sdk-folder/third-party/portaudio/lib/.libs/libportaudio.a \
 -DPORTAUDIO_INCLUDE_DIR=$BASE/sdk-folder/third-party/portaudio/include \
 -DACSDK_EMIT_SENSITIVE_LOGS=ON \
 -DCMAKE_BUILD_TYPE=DEBUG
 
RUN make SampleApp -j2
 
RUN apt-get clean  

RUN echo "========== Configuring ALSA Devices ==========" \
 && printf "pcm.!default {\n  type asym\n   playback.pcm {\n     type plug\n     slave.pcm \"hw:0,0\"\n   }\n   capture.pcm {\n     type plug\n     slave.pcm \"hw:1,0\"\n   }\n}" >> /root/.asoundrc \
 && amixer
  
RUN amixer --version 

WORKDIR $BASE/sdk-folder

COPY entrypoint.sh .
RUN chmod +x entrypoint.sh

RUN env

ENTRYPOINT ./entrypoint.sh
