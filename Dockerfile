FROM alpine:3.16

RUN apk add --update --no-cache \
	dnsmasq lighttpd curl && \
	mkdir -p /netboot/tftproot /netboot/httproot && \
	curl -o /netboot/tftproot/undionly.kpxe https://boot.ipxe.org/undionly.kpxe && \
	curl -o /netboot/tftproot/ipxe.efi https://boot.ipxe.org/ipxe.efi && \
	apk del curl

COPY *.conf /etc/
COPY entrypoint.sh /opt/

EXPOSE 67/tcp 67/udp 69/udp 8069/tcp

CMD /opt/entrypoint.sh
