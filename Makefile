CONTAINER_NAME=netbooter
WORKDIR:=$(shell pwd)

.PHONY: default
default: build run

.PHONY: build
build:
	docker build --force-rm --tag m1cr0man/netbooter:latest .

.PHONY: run
run:
	docker run --rm -d --net host --name=${CONTAINER_NAME} -v ${WORKDIR}/httproot:/netboot/httproot \
		-e DOMAINNAME=localdomain \
		-e DNSSERVERS=192.168.56.1 \
		-e NETPREFIX=192.168.56 \
		-e RANGESTART=50 \
		-e RANGEEND=100 \
		m1cr0man/netbooter:latest
