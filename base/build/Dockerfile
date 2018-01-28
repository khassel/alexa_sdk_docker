ARG myimage
FROM $myimage
MAINTAINER Karsten Hassel

RUN apt-get update && apt-get upgrade -y

RUN apt-get -y install git gcc cmake build-essential libsqlite3-dev libcurl4-openssl-dev libfaad-dev \
 libsoup2.4-dev libgcrypt20-dev libgstreamer-plugins-bad1.0-dev gstreamer1.0-plugins-good libasound2-dev doxygen \
 libatlas-base-dev wget sox python-pip python
 
RUN pip install --upgrade setuptools
RUN pip install flask commentjson requests

RUN apt-get update && apt-get -y install alsa-utils nano
 
RUN cd /usr/bin && ls -la | grep gcc

RUN apt-get -y remove gcc-6

RUN apt-get -y install gcc-4.8 g++-4.8

RUN cd /usr/bin \
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

RUN env
