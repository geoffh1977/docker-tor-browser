# A Simple Makefile To Execute The First Script.  This will need more work at a later date.

# Makefile Variables
ifneq ("$(wildcard .env)","")
  include .env
  export $(shell sed 's/=.*//' .env)
endif

SHELL:=/usr/bin/env bash

.SILENT: all build-environment build-image commands check-version clean push-image

## all - Will Check Software Versions And Build/Push If Necessary
all:
	echo
	echo "Latest Stored Docker Build Tag: ${DOCKER_HUB_VERSION}"
	echo "Current Live Software Version: ${SOFTWARE_VERSION}"
	echo
	[ "${SOFTWARE_VERSION}" != "${DOCKER_HUB_VERSION}" ] && make push-image || echo "No Rebuild Required"
	echo

## check-version - Check Latest Versions Of Software
check-version:
	echo
	echo "Latest Stored Docker Build Tag: ${DOCKER_HUB_VERSION}"
	echo "Current Live Software Version: ${SOFTWARE_VERSION}"
	echo
	[ "${SOFTWARE_VERSION}" != "${DOCKER_HUB_VERSION}" ] && echo "Rebuild Required" || echo "No Rebuild Required"
	echo

## build-image - Build Docker Image
build-image:
	docker build --build-arg VERSION="${SOFTWARE_VERSION}" -f "Dockerfile" -t "${DOCKER_LATEST_IMAGE}" "${PROJECT_ROOT_DIR}"
	docker tag "${DOCKER_LATEST_IMAGE}" "${DOCKER_REPO}:${SOFTWARE_VERSION}"
	docker tag "${DOCKER_LATEST_IMAGE}" "${DOCKER_REPO}:${SOFTWARE_SHORT_VERSION}"

## push-image - Push Docker Image To Docker Hub
push-image: build-image
	docker push "${DOCKER_LATEST_IMAGE}"
	docker push "${DOCKER_REPO}:${SOFTWARE_VERSION}"
	docker push "${DOCKER_REPO}:${SOFTWARE_SHORT_VERSION}"

## commands - Displays This List Of Commands In The Makefile
commands:
	echo " ---------------------------------------"
	echo " Current Makefile Commands And Functions"
	echo " ---------------------------------------"
	echo
	grep "^## " Makefile | sed -e 's/^## //g' -e 's/\ -\ /;/' | sort | column -t -s ';' | sed 's/^/\ /'
	echo
	echo " ---------------------------------------"
	echo

## build-environment - Build/Rebuild The Environment File For The Project
build-environment:
	echo " Building The Environment File..."
	chmod 0755 ./scripts/build_environment_file.sh
	chmod 0755 ./scripts/project_variables.sh
	./scripts/build_environment_file.sh

## clean-environment - Removes The Development Environment File
clean-environment:
	rm -f ./.env
