all: image-linux

.PHONY: image-linux
image-linux:
	@DOCKER_BUILDKIT=1 docker build . --target bin --platform linux/amd64 -t studioetrange/serialize-env-json:${VERSION} -t ghcr.io/studioetrange/serialize-env-json:${VERSION} 
