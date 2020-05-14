# Tor Browser Docker Image
FROM debian:stable-slim
LABEL maintainer="geoffh1977 <geoffh1977@gmail.com>"

# Set Variables For Docker Image
ARG TOR_USER="user"
ARG TOR_VERSION="9.0.10"
ENV TOR_VERSION=$TOR_VERSION

# Install Packages For Tor Browser
# hadolint ignore=DL3008,SC2015
RUN export DEBIAN_FRONTEND=noninteractive && \
  sed -i 's/stable main/stable main contrib/g' /etc/apt/sources.list && \
  apt-get -y update && \
  apt-get install --no-install-recommends -y ca-certificates curl file gpg libx11-xcb1 libasound2 libdbus-glib-1-2 libgtk-3-0 libxrender1 libxt6 xz-utils && \
  apt-get clean autoclean && apt-get autoremove -y && rm -rf /var/lib/apt /var/lib/dpkg /var/lib/cache /var/lib/log && \
  localedef -v -c -i en_US -f UTF-8 en_US.UTF-8 2> /dev/null || :

# Add The User And Create The Directories
RUN useradd -m -d /home/${TOR_USER} ${TOR_USER} && \
  mkdir -p /opt/tor /Downloads && \
  ln -s /Downloads /home/${TOR_USER}/Downloads && \
  chown ${TOR_USER}:${TOR_USER} -R /home/${TOR_USER} /opt/tor /Downloads

# Prepare To Install Tor Browser
WORKDIR /opt/tor
USER ${TOR_USER}

# Download, Check, And Install Tor Project Files
RUN curl -sSL -o /tmp/tor-browser-linux64-${TOR_VERSION}_en-US.tar.xz https://www.torproject.org/dist/torbrowser/${TOR_VERSION}/tor-browser-linux64-${TOR_VERSION}_en-US.tar.xz && \
  tar xf /tmp/tor-browser-linux64-${TOR_VERSION}_en-US.tar.xz && \
  rm -f /tmp/tor-browser-linux64-${TOR_VERSION}_en-US.tar.xz /opt/tor/tor-browser_en-US/Browser/Downloads && \
  ln -s /Downloads /opt/tor/tor-browser_en-US/Browser/Downloads

# Configure Volumes And Work Directory
VOLUME ["/Downloads"]
WORKDIR /home/${TOR_USER}

# Set The Start Command
CMD ["/opt/tor/tor-browser_en-US/Browser/start-tor-browser"]
