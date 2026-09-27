#!/bin/bash

#SERVICE_NAME="nginx"
SERVICE_NAME=$1
COUNT_ATTEMPTS=0 #Counter attempts
MAX_ATTEMPTS=5	 #Max attempts

#Checking if the script is running with root privileges
if [[ $EUID -ne 0 || -z $1 ]]; then
	echo "Error: script launch format"
	echo "sudo "./${0##*/}" ${1:-"<service_name>"}"
	exit 1
fi

#Checking service status and starting if service is inactive
while ((COUNT_ATTEMPTS != MAX_ATTEMPTS)) && ! systemctl --quiet is-active $SERVICE_NAME; do
		COUNT_ATTEMPTS=$((COUNT_ATTEMPTS+1))
		echo "Attempt $COUNT_ATTEMPTS $SERVICE_NAME restarting..."
		systemctl restart $SERVICE_NAME
		sleep 5
done

if systemctl --quiet is-active $SERVICE_NAME; then
	echo "$SERVICE_NAME is active"
else	
	echo "$SERVICE_NAME is not active! Help me fixiki)"
fi	
