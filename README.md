# Tor Project Browser Image #

<p align="center">
<img src="https://github.com/geoffh1977/docker-tor-browser/raw/main/images/tor_logo.png" width="50%" height="50%" text-align="center">
</p>

![Docker Cloud Automated build](https://img.shields.io/docker/cloud/automated/geoffh1977/tor-browser?style=plastic) ![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/geoffh1977/tor-browser?style=plastic) ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/geoffh1977/tor-browser/latest?style=plastic) ![Docker Pulls](https://img.shields.io/docker/pulls/geoffh1977/tor-browser?style=plastic) ![Circle CI Status](https://img.shields.io/circleci/build/github/geoffh1977/docker-tor-browser/main?label=cirecleci&style=plastic&token=29ad39274db889dc198cfebe664f65068191be10)

## Description ##
This docker image contains the Tor Browser Project. It allows for anonymous web browsing on any Linux instance running an X Desktop and Docker Daemon. As docker containers are ephemeral in nature, the container and associated browser files will be removed when the container is stopped and removed.

## Starting The Tor Browser ##
The docker container can be started with the following command - the X interface will be linked to the container so the software can run.

`docker run -it --rm --shm-size 2g -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix:ro geoffh1977/tor-browser`

_Note: This image has been successfully tested on Ubuntu (18.04 -> 20.04)_

## Making Downloads Persistent ##
In order to use data persistnce, the following criteria must be met:

* A directory for the downloads path.
* The directory needs the UID/GID of 1000:1000 as the tor browser is set to a non-root user.

The option of adding a persistent Downloads path to the container exists by mounting a host volume to the '/Downloads' path (e.g. `-v <host_path>:/Downloads`) if you wish to save downloads to the host operating system.

The host path used will need to have a UID and GID equal to 1000. This can be set with the command `chmod 1000:1000 -R <host_path>`

Pressing CTRL+C in the console or closing the browser window(s) will stop the container.

## Tags And Versioning ###

The _latest_ tag is supported as well as the major version numbers for each tor browser version released. Along with these are all the minor version tags. For example:

* *geoffh1977/tor-browser:latest* -- will release the absolute latest build created.
* *geoffh1977/tor-browser:10* -- will release the latest version of the 10 build series (e.g. 10.0.10 as of this writing)
* *geoffh1977/tor-browser:10.0.10* -- will lock the image to the version _10.0.10_

### Getting In Contact ###
If you find any issues with this container or want to recommend some improvements, fell free to get in contact with me or submit pull requests on github. Depending on the popularity of the image, I will consider adding more funcationality in the future as time allows.
