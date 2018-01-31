ARG myimage
FROM $myimage
MAINTAINER Karsten Hassel

ARG myimage
ENV myimage=$myimage

RUN apt-get update && apt-get upgrade -y

RUN apt-get -y install gcc-4.8 g++-4.8

RUN apt-get -y install git cmake libsqlite3-dev libgstreamer-plugins-bad1.0-dev gstreamer1.0-plugins-good libasound2-dev \
	nano libatlas-base-dev wget gstreamer1.0-plugins-ugly gstreamer1.0-plugins-bad gstreamer1.0-alsa alsa-utils make \
	libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev libgstreamer-plugins-good1.0-dev gstreamer1.0-libav doxygen
	
RUN if [ "$myimage" = "resin/rpi-raspbian:stretch" ]; then \
	  apt-get install -y libcurl4-openssl-dev libfaad-dev libsoup2.4-dev libgcrypt20-dev sox python-pip python; \
    else \
	  apt-get install -y openssl clang-format pulseaudio  repo binutils autoconf automake autotools-dev libtool pkg-config \
		zlib1g-dev libcunit1-dev libssl-dev libxml2-dev libev-dev libevent-dev libjansson-dev libjemalloc-dev cython \
		python3-dev python-setuptools; \
    fi
	
ENV BASE=/srv

RUN cd $BASE \
 && mkdir sdk-folder && cd sdk-folder \
 && mkdir sdk-build sdk-source third-party application-necessities \
 && cd application-necessities && mkdir sound-files

RUN if [ "$myimage" = "resin/rpi-raspbian:stretch" ]; then \
      pip install --upgrade setuptools; \
      pip install flask commentjson requests; \
	else \
      cd $BASE/sdk-folder/third-party \
      && git clone https://github.com/tatsuhiro-t/nghttp2.git \
      && cd nghttp2 \
      && autoreconf -i \
      && automake \
      && autoconf \
      && ./configure \
      && make \
      && make install; \
      cd $BASE/sdk-folder/third-party \
      && wget http://curl.haxx.se/download/curl-7.54.0.tar.bz2 \
      && tar -xvjf curl-7.54.0.tar.bz2 \
      && cd curl-7.54.0 \
      && ./configure --with-nghttp2=/usr/local --with-ssl \
      && make \
      && make install \
	  && rm -rf ../curl-7.54.0.tar.bz2 \
      && ldconfig \
      && curl -I https://nghttp2.org/; \
      easy_install pip; \
      pip install --user flask requests commentjson; \
    fi	

RUN python --version && pip --version && cd /usr/bin && ls -la | grep gcc

RUN cd /usr/bin \
 && rm gcc && rm gcc-ar && rm gcc-nm && rm gcc-ranlib \
 && ln -s gcc-4.8 gcc \
 && ln -s gcc-ar-4.8 gcc-ar \
 && ln -s gcc-nm-4.8 gcc-nm \
 && ln -s gcc-ranlib-4.8 gcc-ranlib \
 && ln -s g++-4.8 g++
 
RUN gcc --version && g++ --version

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

# Fix im Quelltext wegen compile error (todo: mit sed lösen):
# https://github.com/alexa/avs-device-sdk/issues/385
COPY KittAiKeyWordDetector.cpp $BASE/sdk-folder/sdk-source/avs-device-sdk/KWD/KittAi/src/KittAiKeyWordDetector.cpp1
RUN if [ "$myimage" = "resin/rpi-raspbian:stretch" ]; then \
      cd $BASE/sdk-folder/sdk-source/avs-device-sdk/KWD/KittAi/src; \
      cp KittAiKeyWordDetector.cpp1 KittAiKeyWordDetector.cpp; \
    fi

WORKDIR $BASE/sdk-folder/sdk-build

RUN if [ "$myimage" = "resin/rpi-raspbian:stretch" ]; then \
	  myos=rpi; \
    else \
	  myos=ubuntu64; \
    fi; \
    cmake $BASE/sdk-folder/sdk-source/avs-device-sdk \
    -DKITTAI_KEY_WORD_DETECTOR=ON \
    -DKITTAI_KEY_WORD_DETECTOR_LIB_PATH=$BASE/sdk-folder/third-party/snowboy/lib/$myos/libsnowboy-detect.a \
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
 && printf "pcm.!default {\n  type asym\n   playback.pcm {\n     type plug\n     slave.pcm \"hw:0,0\"\n   }\n   capture.pcm {\n     type plug\n     slave.pcm \"hw:1,0\"\n   }\n}" >> /root/.asoundrc

WORKDIR $BASE/sdk-folder

COPY entrypoint.sh .
RUN chmod +x entrypoint.sh

ENTRYPOINT ./entrypoint.sh
