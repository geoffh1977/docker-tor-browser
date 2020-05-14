#!/bin/bash

# Download Current Version From Website
DOWNLOAD_FILE=$(curl -s https://www.torproject.org/download/ | grep -o "tor-browser-linux64-.*_en-US.tar.xz" | head -1)
VERSION=$(echo "${DOWNLOAD_FILE}" | grep -Eo "[0-9]{1,2}\.[0-9]{1,2}\.[0-9]{1,2}")

# Download Current Docker Hub Repository Tags
REPO_TAGS=$(curl -s https://registry.hub.docker.com/v1/repositories/geoffh1977/tor-browser/tags  | sed -e 's/[][]//g' -e 's/"//g' -e 's/ //g' | tr '}' '\n'  | awk -F: '{print $3}')

# Check if Current Version Is In Docker Hub
RESULT=$(echo "${REPO_TAGS}" | grep "${VERSION}")
if [ "x${RESULT}" == "x" ]
then
  # Update Version - Triggers Docker Hub Build
  echo
  echo "${VERSION}" > VERSION
  git add VERSION
  git commit -m "Update To Version: ${VERSION}"
  git push origin master
  echo
  echo "Updated Software To Version ${VERSION}"
else
  # No New Updates
  echo
  echo "Version ${VERSION} Already Exists In Docker Hub."
fi
