# Pull base image.
FROM jlesage/baseimage-gui:ubuntu-20.04

# Define download URLs.
ARG TARTUBE_VERSION=2.4.165
ARG TARTUBE_URL=https://github.com/axcore/tartube/releases/download/v${TARTUBE_VERSION}/python3-tartube_${TARTUBE_VERSION}.deb

# Define working directory.
WORKDIR /tmp

# Add files
COPY rootfs/ /

### Install Tartube
RUN \
	add-pkg \
		python3-matplotlib \
		python3-pip \
		python3-feedparser \
		python3-requests \
		python3-gi \
		gir1.2-gtk-3.0 \
		dbus-x11 \
		at-spi2-core \
		fonts-wqy-zenhei \
		ffmpeg \
		&& \
	add-pkg --virtual build-dependencies \
		wget \
		&& \
	echo "download tartbue..." && \
	wget -q ${TARTUBE_URL} && \
	dpkg -i python3-tartube_${TARTUBE_VERSION}.deb && \
	del-pkg build-dependencies && \
	rm -rf /tmp/* /tmp/.[!.]* && \
	# Maximize only the main window.
    sed-patch 's/<application type="normal">/<application type="normal" title="Tartube">/' \
        /etc/xdg/openbox/rc.xml

# Set environment variables.
ENV	APP_NAME="Tartube"

# Define mountable directories.
VOLUME ["/config", "/storage"]