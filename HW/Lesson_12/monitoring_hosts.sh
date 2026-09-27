#!/bin/bash

HOST_NAME=${1:-127.0.0.0}
INTERVAL=${2:-3}
LOG_FILE=${3:-/var/log/mon_hosts.log}
PING_TIMEOUT=3
PING_COUNT=4

#Checking if the script is running with root privileges
if [[ $EUID -ne 0 ]]; then
	echo "Error: script launch format"
	echo "sudo "./${0##*/}" ${1:-"[host_name]"} ${2:-"[interval]"} ${3:-"[log_file]"}"
	exit 1
fi

#Checking ping
command -v ping >/dev/null 2>&1 || {
	echo "Error: command ping not found" >&2
	exit 1
}	

#Create directory for log
LOG_DIR=$(dirname "$LOG_FILE") 
[ -d "$LOG_DIR" ] || sudo mkdir -p "$LOG_DIR"
#echo $LOG_DIR

#Starting message
{
	echo "[$(date "+%Y-%m-%d %H:%M:%S")] Start monitoring host: $HOST_NAME"
	echo "Directory for log: $LOG_FILE"
} | tee -a "$LOG_FILE"

while true; do
	TIMESTAMP="$(date "+%Y-%m-%d %H:%M:%S")"
	if ping -c $PING_COUNT -W $PING_COUNT $HOST_NAME >/dev/null 2>&1; then
		STATUS="OK"
		MESSAGE="[$TIMESTAMP] [$STATUS] $HOST_NAME available"
	else
		STATUS="FAIL"
		MESSAGE="[$TIMESTAMP] [$STATUS] $HOST_NAME unavailable"
	fi

	echo $MESSAGE | tee -a $LOG_FILE

	sleep $INTERVAL
done
