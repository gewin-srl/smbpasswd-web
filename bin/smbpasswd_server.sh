#!/bin/bash

script_name=$0 #${BASH_SOURCE[0]}
script_path="$( cd "$( dirname "${script_name}" )" >/dev/null 2>&1 && pwd )"

. ${script_path}/../conf/env

SERVICE_PATH=${INSTALL_PATH}
SERVICE_NAME=app.py

ADDRESS=
PORT=
SAMBA_TOOL=
SSL=
SSL_PROTOCOL=
SSL_CERT=
SSL_KEY=

if [ ${SERVER_ADDRESS} ]; then
    ADDRESS="--address ${SERVER_ADDRESS}"
fi
if [ ${SERVER_PORT} ]; then
    PORT="--port ${SERVER_PORT}"
fi
if [ ${SERVER_SAMBA_TOOL} -eq 1 ]; then
    SAMBA_TOOL="--samba-tool"
fi
if [ ${SERVER_SSL} -eq 1 ]; then
    SSL="--ssl"
fi
if [ ${SERVER_SSL_PROTOCOL} ]; then
    SSL_PROTOCOL="--ssl-protocol ${SERVER_SSL_PROTOCOL}"
fi
if [ ${SERVER_SSL_CERT} ]; then
    SSL_CERT="--ssl-cert ${SERVER_SSL_CERT}"
fi
if [ ${SERVER_SSL_KEY} ]; then
    SSL_KEY="--ssl-key ${SERVER_SSL_KEY}"
fi

SERVICE_PARAMS="server ${ADDRESS} ${PORT} ${SAMBA_TOOL} \
${SSL} ${SSL_PROTOCOL} ${SSL_CERT} ${SSL_KEY}"
SERVICE_PROCESS="${SERVICE_NAME} ${SERVICE_PARAMS}"

script_name=$0
function usage() {
    echo "usage : "
    echo "$(basename ${script_name}) { start | stop | restart }"
    echo ""
}

if [[ $# != 1 || ( "$1" != "start" && "$1" != "stop" && "$1" != "restart" )]]; then
    usage
    exit 1
fi

function start() {
    pgrep -f "${SERVICE_PROCESS}" 2>/dev/null 1>&2
    #0 if found, 1 if not found
    if [ $? -eq 0 ]; then
	echo "Already started"
	exit 1
    fi

    pushd ${SERVICE_PATH} 2>/dev/null 1>&2;
    ./${SERVICE_PROCESS} &
    popd 2>/dev/null 1>&2;

    sleep 1
    pgrep -f "${SERVICE_PROCESS}" 2>/dev/null 1>&2
    #0 if found, 1 if not found
    if [ $? -eq 1 ]; then
	echo "Failed to start"
	exit 1
    fi

    echo "Server started"
    echo
}

function stop() {
    #echo "${SERVICE_PROCESS}"

    pgrep -f "${SERVICE_PROCESS}" 2>/dev/null 1>&2
    #0 if found, 1 if not found
    if [ $? -eq 1 ]; then
	echo "Server not running"
	return 1
    fi

    pkill -SIGTERM -f "${SERVICE_PROCESS}"
    echo "Server stopped"
    return 0
}

function restart() {
    stop
    sleep 2
    start
}

case $1 in
    "start" )
	start
	;;
    "stop" )
	stop
	;;
    "restart" )
	restart
esac

echo "Done."