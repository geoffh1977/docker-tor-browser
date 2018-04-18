# Tor Project Browser Container #

![alt text](https://raw.githubusercontent.com/geoffh1977/tor-browser/master/images/docker-tor.png)

## Description ##
This docker image is providing an ephemeral image which can be used for anonymous web browsing on any machine running the docker daemon. It contains the Tor Browser project and an installation of Firefox-ESR.

## Starting The Web Browser ##

The docker container can be started with the following command - the X interface will be linked to the container so the software can run.

`docker run -it --rm -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix:ro geoffh1977/tor-browser`

### Saving Downloads ###

You also have the option of adding `-v /tmp/Downloads:/Downloads` if you wish to save downloads to the host operating system.

Note: The host path used will need to have a UID and GID equal to 1000. This can be set with the command `chmod 1000:1000 -R <host_path>`

Pressing CTRL+C in the console or closing the browser window(s) will stop the container.

### Getting In Contact ###
If you find any issues with this container or want to recommend some improvements, fell free to get in contact with me or submit pull requests on github.
