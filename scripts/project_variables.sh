#!/bin/bash
# Variables Which Are Specific To This Project
# shellcheck disable=SC2154,SC2086

# Get Latest Tag Version From Docker Hub
LATEST_TAG=$(curl -s https://hub.docker.com/v2/repositories/${project_project_hub_owner}/${project_project_hub_image}/tags | jq -r '.results[].name' | grep -v "[a-z]" | sort -n -t "." -k1,1 -k 2,2 -k3,3 -r | head -n1)

# Get Software Version From Downloaded Information
DOWNLOAD_FILE=$(curl -s https://www.torproject.org/download/ | grep -o "tor-browser-linux64-.*_en-US.tar.xz" | head -1)
VERSION=$(echo "${DOWNLOAD_FILE}" | grep -Eo "[0-9]{1,2}\.[0-9]{1,2}(\.[0-9]{1,2})?")
SHORT_VERSION=$(echo "${VERSION}" | cut -d. -f1-2)

# Append Variables To Environment File
cat << EOF >> ./.env
# Latest Version Detected For Image On Docker Hub
DOCKER_HUB_VERSION=${LATEST_TAG}

# Latest Software Version Detected For Application
SOFTWARE_VERSION=${VERSION}
SOFTWARE_SHORT_VERSION=${SHORT_VERSION}

EOF
