#!/bin/bash

script_name=$0 #${BASH_SOURCE[0]}
script_path="$( cd "$( dirname "${script_name}" )" >/dev/null 2>&1 && pwd )"

. ${script_path}/../conf/env

SSL=
FQDN=

pushd ${INSTALL_PATH} 2>/dev/null 1>&2

if [ ${GENTOKEN_SSL} -eq 1 ]; then
    SSL="--ssl"
fi
if [ ${GENTOKEN_FQDN} ]; then
    FQDN="--fqdn ${GENTOKEN_FQDN}"
fi

echo "Executing ./app.py gen-token ${SSL} ${FQDN} $1"
./app.py gen-token ${SSL} ${FQDN} $1

popd 2>/dev/null 1>&2
