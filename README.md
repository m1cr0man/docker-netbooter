# Docker Alpine Netboot Server

![Docker Automated build](https://img.shields.io/docker/automated/m1cr0man/netbooter.svg)
![Docker Pulls](https://img.shields.io/docker/pulls/m1cr0man/netbooter.svg)

Provides everything you need to PXE boot any machine (BIOS/UEFI).

Non-iPXE booting machines will be "upgraded" to iPXE.

Contains a TFTP, DHCP and HTTP server. The HTTP server runs on port 8069
by default for safe usage with other services using port 80. The DHCP server
can be disabled.

## Example usage

- Create a folder to store your boot images and `menu.ipxe` file. There is
an [example menu.ipxe](https://github.com/m1cr0man/docker-netbooter/blob/master/httproot/menu.ipxe) in the repo.
- Run the container:

```
docker run --rm -d --net host --name=${CONTAINER_NAME} -v ${WORKDIR}/httproot:/netboot/httproot \
	-e DOMAINNAME=localdomain \
	-e DNSSERVERS="8.8.8.8 192.168.56.1" \
	-e NETPREFIX=192.168.56 \
	-e RANGESTART=50 \
	-e RANGEEND=100 \
	m1cr0man/netbooter:latest
```

**Note**: If you want to use your own DHCP server just don't specify the environment variables.

## Configuration options

Environment variables:

- `DOMAINNAME`: Domain to pass to clients via DHCP
- `DNSSERVERS`: Space separated list of DNS servers
- `NETPREFIX`: The first 3 digits of the IPv4 address range you want to serve. No trailing dot.
- `RANGESTART`: The first IP address to serve. Prefixed with the `NETPREFIX`
- `RANGEEND`: The last IP address to serve. Prefixed with the `NETPREFIX`

Leave these settings out to disable the DHCP server.

## Adding images

- Download the necessary netboot files for the image you want to use (e.g. initrd + vmlinuz)
- Copy these files to your `httproot` folder
- Add a section to your `menu.ipxe` to provide an option to select this OS. The example
menu.ipxe includes a section for Rancher OS installer which you can copy/edit.

For more information on writing the `menu.ipxe` see [the iPXE docs](https://ipxe.org/scripting)

## Usage from Github

A Makefile is provided for conveniently building + running the container.
Simply run `make` to do both, or run `make [build|run]` for the individual parts.

It is recommended to edit the `run` target to suit your own environment/needs.
