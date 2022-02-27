all: image-linux

ROMVAULT_VERSION=latest
RVCMD_VERSION=latest

.PHONY: image-linux
image-linux:
	@DOCKER_BUILDKIT=1 docker build . --build-arg ROMVAULT_VERSION=${ROMVAULT_VERSION} --build-arg RVCMD_VERSION=${RVCMD_VERSION} --platform linux/amd64 -t studioetrange/docker-romvault:${ROMVAULT_VERSION} -t ghcr.io/studioetrange/docker-romvault:${ROMVAULT_VERSION} 



