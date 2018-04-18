# Build Tor Browser Docker Image
FROM debian:stable-slim
MAINTAINER geoffh1977 <geoffh1977@gmail.com>

# Set Variables For Docker Image
ARG TOR_VERSION="7.5.3"
ARG TOR_USER="user"

# Install Packages For Tor Browser and Firefox ESR
RUN export DEBIAN_FRONTEND=noninteractive && \
  sed -i.bak 's/stable main/stable main contrib/g' /etc/apt/sources.list && \
  apt-get update && \
  apt-get install --no-install-recommends -y curl xz-utils gpg dirmngr locales ca-certificates firefox-esr && \
  apt-get clean autoclean && apt-get autoremove -y && rm -rf /var/lib/{apt,dpkg,cache,log}/ && \
  localedef -v -c -i en_US -f UTF-8 en_US.UTF-8 2> /dev/null || :

# Add The User And Create The Directories
RUN useradd -m -d /home/${TOR_USER} ${TOR_USER} && \
  mkdir -p /home/${TOR_USER}/Downloads /opt/tor /Downloads && \
  ln -s /Downloads /home/${TOR_USER}/Downloads && \
  chown ${TOR_USER}:${TOR_USER} -R /home/${TOR_USER} /opt/tor /Downloads

# Configure WorkDir And User
WORKDIR /home/${TOR_USER}
USER ${TOR_USER}

# Download, Check, And Install Tor Project Files
RUN cd /opt/tor && \
  curl -sSL -o /tmp/tor-browser-linux64-${TOR_VERSION}_en-US.tar.xz https://www.torproject.org/dist/torbrowser/${TOR_VERSION}/tor-browser-linux64-${TOR_VERSION}_en-US.tar.xz && \
  curl -sSL -o /tmp/tor-browser-linux64-${TOR_VERSION}_en-US.tar.xz.asc https://www.torproject.org/dist/torbrowser/${TOR_VERSION}/tor-browser-linux64-${TOR_VERSION}_en-US.tar.xz.asc && \
  gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "EF6E 286D DA85 EA2A 4BA7  DE68 4E2C 6E87 9329 8290" && \
  gpg --verify /tmp/tor-browser-linux64-${TOR_VERSION}_en-US.tar.xz.asc && \
  tar xvf /tmp/tor-browser-linux64-${TOR_VERSION}_en-US.tar.xz && \
  rm -f /tmp/tor-browser-linux64-${TOR_VERSION}_en-US.tar.xz /tmp/tor-browser-linux64-${TOR_VERSION}_en-US.tar.xz.asc /opt/tor/tor-browser_en-US/Browser/Downloads && \
  ln -s /Downloads /opt/tor/tor-browser_en-US/Browser/Downloads

# Set The Start Command
CMD ["/opt/tor/tor-browser_en-US/Browser/start-tor-browser"]
