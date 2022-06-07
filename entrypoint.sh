DHCP_SERVER_CONFIG_SOURCE="/etc/dnsmasq.conf"
DHCP_SERVER_CONFIG="/etc/dnsmasq.compiled.conf"

# Set default netmask
if [ -z "${NETMASK}" ]; then
    NETMASK=255.255.255.0
fi

SED_REPLACE_VARS="s/DOMAINNAME/${DOMAINNAME}/g; s/DNSSERVERS/${DNSSERVERS}/g; s/GATEWAY/${GATEWAY}/g; s/NETPREFIX/${NETPREFIX}/g; s/RANGESTART/${RANGESTART}/g; s/RANGEEND/${RANGEEND}/g; s/NETMASK/${NETMASK}/g"
SED_REMOVE_AUTHORITATIVE='/BEGIN authoritative DHCP/,/END authoritative DHCP/{//!d}'
SED_REMOVE_PROXY='/BEGIN proxy DHCP/,/END proxy DHCP/{//!d}'

cp "${DHCP_SERVER_CONFIG_SOURCE}" "${DHCP_SERVER_CONFIG}"

if [ "${DHCPMODE}" == "proxy" ]; then
    printf "%s\n" "Configuring dnsmasq for proxy DHCP"
    sed -i "${SED_REMOVE_AUTHORITATIVE}; ${SED_REPLACE_VARS}" "${DHCP_SERVER_CONFIG}"

elif [ "${DHCPMODE}" == "none" ]; then
    printf "%s\n" "Configuring dnsmasq without DHCP"
    sed -i "${SED_REMOVE_AUTHORITATIVE}; ${SED_REMOVE_PROXY}; ${SED_REPLACE_VARS}" "${DHCP_SERVER_CONFIG}"

else
    # Assume authoritative as the default mode
    printf "%s\n" "Configuring dnsmasq for authoritative DHCP"

    # For legacy config support, remove gateway if not specified
    if [ -z "${GATEWAY}" ]; then
        sed -i "/GATEWAY/d" "${DHCP_SERVER_CONFIG}"
    fi

    # Support no dns-server too
    if [ -z "${DNSSERVERS}" ]; then
        sed -i "/DNSSERVERS/d" "${DHCP_SERVER_CONFIG}"
    fi

    sed -i "${SED_REMOVE_PROXY}; ${SED_REPLACE_VARS}" "${DHCP_SERVER_CONFIG}"
fi

exec 3>&1
lighttpd -D -f /etc/lighttpd.conf &
dnsmasq -k --log-facility=- -C "${DHCP_SERVER_CONFIG}"
