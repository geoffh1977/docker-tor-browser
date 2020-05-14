# Tor Project Browser Image #

## Description ##
This docker image contains the Tor Browser Project. It allows for anonymous web browsing on any Linux instance running an X Desktop and Docker Daemon. As docker containers are ephemeral in nature, the container and associated browser files will be removed when the container is stopped and removed.

## Starting The Tor Browser ##

The docker container can be started with the following command - the X interface will be linked to the container so the software can run.

`docker run -it --rm --shm-size 2g -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix:ro geoffh1977/tor-browser`

_Note: This image has been successfully tested on Ubuntu (18.04 -> 20.04)_

### Making Downloads Persistent ###

The option of adding a persistent Downloads path to the container exists by mounting a host volume to the '/Downloads' path (e.g. `-v <host_path>:/Downloads`) if you wish to save downloads to the host operating system.

The host path used will need to have a UID and GID equal to 1000. This can be set with the command `chmod 1000:1000 -R <host_path>`

Pressing CTRL+C in the console or closing the browser window(s) will stop the container.
