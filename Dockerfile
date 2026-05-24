# syntax=docker/dockerfile:1

FROM ghcr.io/linuxserver/baseimage-selkies:ubunturesolute

# set version label
ARG BUILD_DATE
ARG VERSION
ARG ARCHIPELAGO_RELEASE
LABEL build_version="version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="SecureTaco"

ENV \
  CUSTOM_PORT="8080" \
  CUSTOM_HTTPS_PORT="8181" \
  HOME="/config" \
  TITLE="Archipelago" \
  QTWEBENGINE_DISABLE_SANDBOX="1" \
  NO_GAMEPAD=true \
  PIXELFLUX_WAYLAND=true

COPY /root/defaults/ /defaults/

RUN \
  echo "**** install archipelago-client ****" && \
  mkdir -p /opt/archipelago-client && \
  if [ -z ${ARCHIPELAGO_RELEASE+x} ]; then \
    ARCHIPELAGO_RELEASE=$(curl -sX GET "https://api.github.com/repos/ArchipelagoMW/Archipelago/releases/latest" \
      | jq -r .tag_name); \
  fi && \
  ARCHIPELAGO_URL="https://github.com/ArchipelagoMW/Archipelago/releases/download/${ARCHIPELAGO_RELEASE}/Archipelago_${ARCHIPELAGO_RELEASE}_linux-x86_64.AppImage" &&  \
  curl -fo /opt/archipelago-client/archipelago.AppImage -L "$ARCHIPELAGO_URL" && \
  chmod +x /opt/archipelago-client/archipelago.AppImage && \
  cd /opt/archipelago-client && \
  /opt/archipelago-client/archipelago.AppImage --appimage-extract && \
  dbus-uuidgen > /etc/machine-id && \
  printf "version: ${VERSION}\nBuild-date: ${BUILD_DATE}" > /build_version && \
  echo "**** cleanup build deps ****" && \
  apt-get autoremove -y && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*  

    # Define health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
    CMD curl -f http://localhost:${PORT:-8080} || exit 1

