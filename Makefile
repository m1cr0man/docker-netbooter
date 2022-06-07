CONTAINER_NAME=netbooter
WORKDIR:=$(shell pwd)

.PHONY: default
default: build authoritative

.PHONY: build
build:
	docker build --force-rm --tag m1cr0man/netbooter:latest .

.PHONY: authoritative
authoritative:
	docker run --rm -it --cap-add NET_ADMIN --net host --name=${CONTAINER_NAME} -v ${WORKDIR}/httproot:/netboot/httproot \
		-e DHCPMODE=authoritative \
		-e DOMAINNAME=localdomain \
		-e NETPREFIX=192.168.56 \
		-e RANGESTART=50 \
		-e RANGEEND=100 \
		m1cr0man/netbooter:latest

.PHONY: proxy
proxy:
	docker run --rm -it --cap-add NET_ADMIN --net host --name=${CONTAINER_NAME} -v ${WORKDIR}/httproot:/netboot/httproot \
		-e DHCPMODE=proxy \
		-e NETPREFIX=192.168.14 \
		-e RANGESTART=1 \
		-e NETMASK=255.255.255.0 \
		m1cr0man/netbooter:latest

.PHONY: nodhcp
nodhcp:
	docker run --rm -it --cap-add NET_ADMIN --net host --name=${CONTAINER_NAME} -v ${WORKDIR}/httproot:/netboot/httproot \
		-e DHCPMODE=none \
		m1cr0man/netbooter:latest
