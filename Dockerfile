FROM ubuntu:focal

RUN apt-get update && apt-get install --no-install-recommends -y \
  ca-certificates \
  wget \
  curl \
  jq \
  pwgen \
  nano \
  unzip \
  xz-utils \
  procps \
  && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Create dir to run datadir to bind for persistent data
RUN mkdir /raptoreum
VOLUME /raptoreum
WORKDIR /raptoreum

COPY ./bootstrap.sh ./rtm-bins.sh ./start.sh /usr/local/bin/
RUN chmod -R 755 /usr/local/bin
RUN ["/bin/bash", "-c", "rtm-bins.sh"]

# Smartnode p2p port and rpc
EXPOSE 10226 10225

# Use healthcheck to deal with hanging issues and prevent pose bans
HEALTHCHECK --start-period=20m --interval=30m --retries=3 --timeout=10s CMD check.sh

CMD start.sh
