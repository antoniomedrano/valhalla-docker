FROM ubuntu:trusty
MAINTAINER Tim Niblett <tniblett@arogi.com>

ENV TERM xterm
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y git \
  libtool \
  automake \
  pkg-config \
  libcurl4-gnutls-dev \
  sudo \
  build-essential \
  libboost1.54-all-dev \
  software-properties-common \
  wget

RUN git clone --depth=1 --recurse-submodules --single-branch --branch=master https://github.com/zeromq/libzmq.git && \
  cd libzmq && \
  ./autogen.sh && \
  ./configure --without-libsodium && \
  make -j4 && \
  make install && \
  cd ..

RUN git clone --depth=1 --recurse-submodules --single-branch --branch=master https://github.com/kevinkreiser/prime_server.git && \
  cd prime_server && \
  ./autogen.sh && \
  ./configure && \
  make -j4 && \
  make install && \
  cd ..

RUN git clone --depth=1 --recurse-submodules --single-branch --branch=master https://github.com/valhalla/mjolnir.git && \
  cd mjolnir && \
  ./scripts/dependencies.sh && \
  ./scripts/install.sh && \
  cd ..

RUN git clone --depth=1 --recurse-submodules --single-branch --branch=master https://github.com/valhalla/tools.git && \
  cd tools && \
  ./scripts/dependencies.sh && \
  ./scripts/install.sh && \
  cd ..

ADD ./conf /conf

RUN ldconfig

#Set the protobuffer for valhalla here
#RUN wget https://s3.amazonaws.com/metro-extracts.mapzen.com/trento_italy.osm.pbf
RUN wget http://download.geofabrik.de/north-america/us/california-latest.osm.pbf

RUN mkdir -p /data/valhalla
RUN pbfadminbuilder -c conf/valhalla.json *.pbf
RUN pbfgraphbuilder -c conf/valhalla.json *.pbf

RUN apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 8002
CMD ["tools/tyr_simple_service", "conf/valhalla.json"]
