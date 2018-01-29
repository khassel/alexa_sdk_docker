ARG myimage
FROM $myimage
MAINTAINER Karsten Hassel

RUN apt-get update

RUN apt-get -y install gcc-4.8 g++-4.8

RUN apt-get -y install git cmake libsqlite3-dev libcurl4-openssl-dev libfaad-dev \
	libsoup2.4-dev libgcrypt20-dev libgstreamer-plugins-bad1.0-dev gstreamer1.0-plugins-good libasound2-dev \
	sox nano python-pip python libatlas-base-dev wget gstreamer1.0-plugins-good gstreamer1.0-plugins-ugly \
	gstreamer1.0-plugins-bad gstreamer1.0-alsa alsa-utils make
	
	
RUN pip install --upgrade setuptools
RUN pip install flask commentjson requests

RUN python --version 
RUN pip --version
 
RUN cd /usr/bin && ls -la | grep gcc

RUN cd /usr/bin \
 && rm gcc && rm gcc-ar && rm gcc-nm && rm gcc-ranlib \
 && ln -s gcc-4.8 gcc \
 && ln -s gcc-ar-4.8 gcc-ar \
 && ln -s gcc-nm-4.8 gcc-nm \
 && ln -s gcc-ranlib-4.8 gcc-ranlib \
 && ln -s g++-4.8 g++
 
RUN gcc --version
RUN g++ --version

ENV BASE=/srv

RUN cd $BASE \
 && mkdir sdk-folder && cd sdk-folder \
 && mkdir sdk-build sdk-source third-party application-necessities \
 && cd application-necessities && mkdir sound-files

RUN cd $BASE/sdk-folder/third-party \
 && wget -c http://www.portaudio.com/archives/pa_stable_v190600_20161030.tgz \
 && tar zxf pa_stable_v190600_20161030.tgz \
 && cd portaudio \
 && ./configure --without-jack \
 && make \
 && rm -rf ./pa_stable_v190600_20161030.tgz

# todo: https://github.com/alexa/avs-device-sdk/issues/463

RUN cd $BASE/sdk-folder/sdk-source && git clone --depth 1 -b master --single-branch git://github.com/alexa/avs-device-sdk.git 

RUN cd $BASE/sdk-folder/third-party && git clone --depth 1 -b master --single-branch https://github.com/Kitt-AI/snowboy.git

RUN gcc --version
RUN g++ --version

# Fix im Quelltext wegen compile error (todo: mit sed lösen):
# https://github.com/alexa/avs-device-sdk/issues/385
COPY KittAiKeyWordDetector.cpp $BASE/sdk-folder/sdk-source/avs-device-sdk/KWD/KittAi/src/KittAiKeyWordDetector.cpp

#RUN ln -s /usr/lib/atlas-base/atlas/libblas.so.3 /usr/lib/libblas.so

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
 
#RUN apt-get clean  

RUN echo "========== Configuring ALSA Devices ==========" \
 && printf "pcm.!default {\n  type asym\n   playback.pcm {\n     type plug\n     slave.pcm \"hw:0,0\"\n   }\n   capture.pcm {\n     type plug\n     slave.pcm \"hw:1,0\"\n   }\n}" >> /root/.asoundrc

WORKDIR $BASE/sdk-folder

COPY entrypoint.sh .
RUN chmod +x entrypoint.sh

RUN env

ENTRYPOINT ./entrypoint.sh
