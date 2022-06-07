# Docker Alpine Netboot Server

![Docker Automated build](https://img.shields.io/docker/automated/m1cr0man/netbooter.svg)
![Docker Pulls](https://img.shields.io/docker/pulls/m1cr0man/netbooter.svg)

Provides everything you need to PXE boot any machine (BIOS/UEFI).

Non-iPXE booting machines will be "upgraded" to iPXE.

Contains a TFTP, DHCP and HTTP server. The HTTP server runs on port 8069
by default for safe usage with other services using port 80.

Supports running a DHCP server in authoritative, proxy and disabled modes.

## Example usage

- Create a folder to store your boot images and `menu.ipxe` file. There is
an [example menu.ipxe](https://github.com/m1cr0man/docker-netbooter/blob/master/httproot/menu.ipxe) in the repo.
- Run the container:

```bash
docker run --rm -d --net host --cap-add NET_ADMIN --name=netbooter -v /path/to/httproot:/netboot/httproot \
  -e DHCPMODE=authoritative \
  -e DOMAINNAME=localdomain \
  -e DNSSERVERS="1.1.1.1,192.168.56.1" \
  -e GATEWAY=192.168.56.1 \
  -e NETMASK=255.255.255.0 \
  -e NETPREFIX=192.168.56 \
  -e RANGESTART=50 \
  -e RANGEEND=100 \
  m1cr0man/netbooter:latest
```

For more examples, check out the [Makefile](./Makefile).

## Which DHCP mode is right for you?

When configuring netboot for the first time, DHCP configuration can
be very confusing. There are a lot of different ways to configure it
and all of them depend on your particular situation.

### Authoritative DHCP

Use this mode if you want the DHCP server in this container to serve leases
in the configured network. For example, if you are trying to netboot a virtual
machine or physical machine on a network interface with no other DHCP servers
configured.

Environment variables:

- `DHCPMODE`: Must be set to `authoritative`.
- `DOMAINNAME`: Domain to pass to clients via DHCP.
- `DNSSERVERS`: (Optional) Comma separated list of DNS servers.
- `GATEWAY`: (Optional) Network gateway to provide to clients. Will default to server's IP.
- `NETMASK`: (Optional) Netmask to provide to clients. Defaults to `255.255.255.0`.
- `NETPREFIX`: The first 3 digits of the IPv4 address range you want to serve. No trailing dot.
- `RANGESTART`: The first IP address to serve. Prefixed with the `NETPREFIX`.
- `RANGEEND`: The last IP address to serve. Prefixed with the `NETPREFIX`.

### Proxy DHCP

Use this mode if there is another DHCP server on your network which you cannot
reconfigure to support network booting. For example, you want to netboot a host
on your home network and the router already serves DHCP leases itself.

Environment variables:

- `DHCPMODE`: Must be set to `proxy`.
- `NETPREFIX`: The first 3 digits of the IPv4 address range you want to serve. No trailing dot.
- `RANGESTART`: The first address of the network to serve requests on. Usually `1`.
- `NETMASK`: (Optional) Netmask to serve requests on. Defaults to `255.255.255.0`.

### No DHCP

You can disable the DHCP feature of this image entirely if you already have
a DHCP server on your network and can configure it to serve the correct PXE
boot options. For example, you have another Linux/Windows DHCP server that
you have root/administrator access to, and you just need a TFTP + IPXE server.

In this case, you can exclude all environment variables except for `DHCPMODE`.

Environment variables:

- `DHCPMODE`: Must be set to `none`.

## Example docker-compose.yml

```yml
version: '3.4'
services:
  netbooter:
    image: m1cr0man/netbooter:latest
    restart: always
    network: host
    cap_add:
      - NET_ADMIN
    environment:
      DHCPMODE: authoritative
      DOMAINNAME: localdomain
      DNSSERVERS: 1.1.1.1,192.168.56.1
      GATEWAY: 192.168.56.1
      NETMASK: 255.255.255.0
      NETPREFIX: 192.168.56
      RANGESTART: 50
      RANGEEND: 100
    volumes:
      - ./path/to/httproot:/netboot/httproot:ro
```

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
