#!/bin/bash -xe

# Get Latests Docker Hub Tag
LATEST_TAG=$(curl -s https://hub.docker.com/v2/repositories/geoffh1977/tor-browser/tags | jq -r '.results[].name' | grep -v "[a-z]" | sort -rn | head -n1)

# Get Live Software Version
DOWNLOAD_FILE=$(curl -s https://www.torproject.org/download/ | grep -o "tor-browser-linux64-.*_en-US.tar.xz" | head -1)
VERSION=$(echo "${DOWNLOAD_FILE}" | grep -Eo "[0-9]{1,2}\.[0-9]{1,2}(\.[0-9]{1,2})?")

# Display Results
echo
echo "Latest Stored Docker Build Tag: ${LATEST_TAG}"
echo "Current Live Software Version: ${VERSION}"

echo
if [ "${LATEST_TAG}" == "${VERSION}" ]
then
  echo "Versions Match. No Rebuild Is Required."
  echo "export REBUILD_REQUIRED=false" >> "${BASH_ENV}"
else
  echo "Version MisMatch. A Rebuild Is Required."
  echo "export REBUILD_REQUIRED=true" >> "${BASH_ENV}"
fi
echo
