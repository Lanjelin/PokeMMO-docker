FROM ghcr.io/linuxserver/baseimage-kasmvnc:ubuntujammy

LABEL maintainer="lanjelin"

ENV TITLE=PokeMMO-Docker
ENV REVISION=31914
ENV XDG_SESSION_TYPE=x11

# add local files
COPY /root /

RUN \
    sed -i 's|</applications>|  <application title="PokeMMO-Docker" type="normal">\n    <maximized>no</maximized>\n  </application>\n</applications>|' /etc/xdg/openbox/rc.xml && \
    mkdir -p /pokemmo && mkdir -p /usr/share/man/man1 && \
  echo "**** update packages ****" && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
      wget \
      unzip \
      default-jre \
      openjdk-17-jre && \
  echo "**** install PokeMMO ****" && \
    wget https://pokemmo.com/download_file/1/ -O /pokemmo/PokeMMO-Client.zip && \
    wget https://pokemmo.com/build/images/opengraph.ce52eb8f.png -O /pokemmo/PokeMMO.png && \
    cd /pokemmo && unzip PokeMMO-Client.zip && \
  echo "**** setting permissions ****" && \
    find /pokemmo -perm 700 -exec chmod 755 {} + && \
    find /pokemmo -perm 600 -exec chmod 644 {} + && \
    chmod 755 /defaults/autostart && \
  echo "**** cleanup ****" && \
    rm -rf \
      /tmp/* \
      /var/lib/apt/lists/* \
      /var/tmp/* \
      /pokemmo/PokeMMO-Client.zip

# ports and volumes
EXPOSE 3000 3001

WORKDIR /pokemmo
VOLUME /pokemmo/config
