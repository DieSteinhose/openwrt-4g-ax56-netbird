#!/bin/sh

# Modem Watchdog Script
# Checks internet connectivity and attempts to reconnect the modem if down.

TARGET="9.9.9.9"
INTERFACE="LTE"

if ping -c 1 -W 5 $TARGET > /dev/null; then
    exit 0
fi

logger -t modem-watchdog "Internet connection lost. Attempting recovery..."

# Check if modem is present
if ! mmcli -m 0 > /dev/null 2>&1; then
    logger -t modem-watchdog "Modem not found. Restarting ModemManager..."
    /etc/init.d/modemmanager restart
    sleep 20
fi

# Check connection status
STATUS=$(mmcli -m 0 --output-keyvalue | grep "modem.generic.state" | awk '{print $3}')

if [ "$STATUS" != "connected" ]; then
    logger -t modem-watchdog "Modem state is $STATUS. Attempting to connect..."
    
    # Try to connect existing bearer
    if mmcli -b 1 > /dev/null 2>&1; then
        mmcli -b 1 --connect
    else
        mmcli -m 0 --simple-connect="apn=internet"
    fi
    
    sleep 10
    
    if ping -c 1 -W 5 $TARGET > /dev/null; then
        logger -t modem-watchdog "Reconnection successful."
    else
        logger -t modem-watchdog "Reconnection failed."
    fi
else
    logger -t modem-watchdog "Modem is connected but internet is unreachable. Check routing/APN."
fi
