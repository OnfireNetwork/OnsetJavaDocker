FROM ubuntu:18.04

EXPOSE 7777/udp
EXPOSE 7776/tcp
EXPOSE 7775/tcp

ENV CONFIG_SERVERNAME="Onset Java Server"
ENV CONFIG_SERVERNAME_SHORT="Onset Java Server"
ENV CONFIG_GAMEMODE="OnsetJava"
ENV CONFIG_WEBSITE_URL="https://github.com/OnfireNetwork/OnsetJava"
ENV CONFIG_MAX_PLAYERS=300
ENV CONFIG_PASSWORD=""
ENV CONFIG_TIMEOUT=15000
ENV CONFIG_IPLIMIT=5
ENV CONFIG_MASTERLIST=false
ENV CONFIG_PLUGINS=""
ENV CONFIG_PACKAGES=""
ENV CONFIG_VOICE=true
ENV CONFIG_VOICE_SAMPLE_RATE=24000
ENV CONFIG_VOICE_3D=true
ENV CONFIG_STREAM_DISTANCE_PLAYER=12000
ENV CONFIG_STREAM_RATE_PLAYER=0.05
ENV CONFIG_STREAM_DISTANCE_VOICE=5000
ENV CONFIG_STREAM_RATE_VOICE=0.8
ENV CONFIG_STREAM_DISTANCE_VEHICLE=12000
ENV CONFIG_STREAM_RATE_VEHICLE=0.1
ENV CONFIG_STREAM_DISTANCE_OBJECT=12000
ENV CONFIG_STREAM_RATE_OBJECT=0.1
ENV CONFIG_STREAM_DISTANCE_NPC=12000
ENV CONFIG_STREAM_RATE_NPC=0.1
ENV CONFIG_STREAM_DISTANCE_PICKUP=12000
ENV CONFIG_STREAM_RATE_PICKUP=0.1
ENV CONFIG_STREAM_DISTANCE_DOOR=12000
ENV CONFIG_STREAM_RATE_DOOR=0.1
ENV CONFIG_STREAM_DISTANCE_TEXT3D=12000
ENV CONFIG_STREAM_RATE_TEXT3D=0.1
ENV CONFIG_PLUGINS=
ENV CONFIG_PACKAGES=

RUN apt-get update -y && apt-get install -y gcc-8 g++-8 software-properties-common lib32gcc1 cmake git curl wget gettext
RUN wget -qO - https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public | apt-key add -
RUN add-apt-repository --yes https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/
RUN apt-get update -y && apt-get install -y adoptopenjdk-8-hotspot maven
RUN rm /usr/bin/cc
RUN ln -s /usr/bin/gcc-8 /usr/bin/cc && ln -s /usr/bin/g++-8 /usr/bin/c++

RUN mkdir /build && mkdir /files
WORKDIR /build
RUN git clone https://github.com/OnfireNetwork/OnsetJavaPlugin.git && git clone https://github.com/OnfireNetwork/OnsetJava.git && mkdir steamcmd

WORKDIR /build/OnsetJavaPlugin
RUN git submodule update --init

RUN JAVA_HOME=/usr/lib/jvm/adoptopenjdk-8-hotspot-amd64 cmake .
RUN make

WORKDIR /build/OnsetJavaPlugin/OnsetJavaPluginSupport
RUN mvn package

WORKDIR /build/OnsetJava
RUN mvn package

WORKDIR /build/steamcmd
RUN curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf -
RUN ./steamcmd.sh +login anonymous +force_install_dir /server +app_update 1204170 validate +exit

WORKDIR /build
RUN mkdir /server/java && mkdir /server/java/plugins
RUN cp /build/OnsetJavaPlugin/src/OnsetJavaPlugin.so /files/
RUN cp /build/OnsetJavaPlugin/OnsetJavaPluginSupport/target/OnsetJavaPluginSupport-1.0.jar /server/java/
RUN cp /build/OnsetJava/OnsetJava-JNI/target/OnsetJava-JNI-0.1.jar /server/java/

WORKDIR /server

RUN rm OnsetServer && rm start_linux.sh
COPY OnsetServer /server/OnsetServer
COPY start_linux.sh /server/start_linux.sh
RUN chmod +x OnsetServer && chmod +x start_linux.sh

RUN rm -R /build && rm server_config.json
COPY server_config.json.source /files/server_config.json.source
COPY prepare.sh /server/prepare.sh
RUN chmod +x /server/prepare.sh

CMD ./prepare.sh && ./start_linux.sh
