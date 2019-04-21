FROM alpine:3.9

RUN apk add --update --no-cache \
	dhcp tftp-hpa lighttpd curl && \
	mkdir -p /netboot/tftproot /netboot/httproot && \
	touch /netboot/dhcpd.leases && \
	curl -o /netboot/tftproot/undionly.kpxe http://boot.ipxe.org/undionly.kpxe && \
	curl -o /netboot/tftproot/ipxe.efi http://boot.ipxe.org/ipxe.efi

COPY *.conf /etc/
COPY entrypoint.sh /opt/

EXPOSE 67/tcp 67/udp 69/udp 8069/tcp

CMD /opt/entrypoint.sh
