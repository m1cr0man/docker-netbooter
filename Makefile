CONTAINER_NAME=netbooter
WORKDIR:=$(shell pwd)

.PHONY: default
default: build run

.PHONY: build
build:
	docker build --force-rm --tag redbrick/netbooter:latest .

.PHONY: run
run:
	docker run -d --net host --rm -it --name=${CONTAINER_NAME} -v ${WORKDIR}/httproot:/netboot/httproot redbrick/netbooter:latest
