#!/bin/bash

# A Script That Is Run By The CI Server To Check And Update The Build Version

# Get The Online Version Of the Software
DOWNLOAD_FILE=$(curl -s https://www.torproject.org/download/download-easy.html.en | grep -o "tor-browser-linux64-.*_en-US.tar.xz" | head -1)
SITE_VERSION=$(echo "${DOWNLOAD_FILE}" | grep -Eo "[0-9]{1,2}\.[0-9]{1,2}\.[0-9]{1,2}")
[ "${SITE_VERSION}" == "" ] && SITE_VERSION=$(echo "${DOWNLOAD_FILE}" | grep -Eo "[0-9]{1,2}\.[0-9]{1,2}")
[ "${SITE_VERSION}" == "" ] && echo "Unable To Get Version From Site!" && exit 1

# Get The Local Version Of The Software
[ ! -f assets/VERSION ] && echo "0.0.0" > assets/VERSION
LOCAL_VERSION=$(cat assets/VERSION)

# Check Versions And Perform Update Actions
if [ "$SITE_VERSION" != "$LOCAL_VERSION" ]
then
  echo " -- Not Matched - Begining Update Process..."
  echo
  git fetch --tags
  git tag | grep -q "${SITE_VERSION}"
  [ $? -eq 0 ] && echo "Version ${SITE_VERSION} Already Exists In Repository - No Action" && exit 1
  echo " -- Version ${SITE_VERSION} Not Found. Updating Build..."
  echo
  git checkout master > /dev/null
  echo "${SITE_VERSION}" > assets/VERSION
  git add -A :/ > /dev/null
  git commit -m "Automated: Updating ${LOCAL_VERSION} To ${SITE_VERSION}" > /dev/null
  git tag -a "${SITE_VERSION}" -m "Firefox ESR and Tor Browser Version ${SITE_VERSION}" > /dev/null
  echo " -- Pushing To Upstream..."
  echo
  git push origin master > /dev/null
  git push --tags origin > /dev/null
  echo " -- Update Process Complete."
  echo
else
  echo " -- Versions Match - No Action Required"
fi

exit 0
