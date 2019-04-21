sed -i "s/DOMAINNAME/${DOMAINNAME}/g; s/DNSSERVERS/${DNSSERVERS}/g; s/NETPREFIX/${NETPREFIX}/g; s/RANGESTART/${RANGESTART}/g; s/RANGEEND/${RANGEEND}/g;" /etc/dhcpd.conf

lighttpd -D -f /etc/lighttpd.conf &
dhcpd -4 -f -d -cf /etc/dhcpd.conf &
in.tftpd -L --secure /netboot/tftproot
