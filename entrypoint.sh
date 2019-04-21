lighttpd -D -f /etc/lighttpd.conf &
dhcpd -4 -f -d -cf /etc/dhcpd.conf &
in.tftpd -L --secure /netboot/tftproot
