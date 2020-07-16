#!/bin/bash

script_name=$0 #${BASH_SOURCE[0]}
script_path="$( cd "$( dirname "${script_name}" )" >/dev/null 2>&1 && pwd )"

. ${script_path}/../conf/env

ln -s ${INSTALL_PATH}/conf/systemd/system/smbpasswd-web.service /etc/systemd/system/smbpasswd-web.service
systemctl enable smbpasswd-web.service
systemctl daemon-reload
