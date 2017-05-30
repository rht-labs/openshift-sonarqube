#!/usr/bin/env bash

set -e

printf "Downloading additional plugins\n"
for PLUGIN in "$@"
do
    DOWNLOAD_URL=$(cat /tmp/pluginList.txt | grep ${PLUGIN} | sort -V | tail -n 1 | awk -F"=" '{print $2}' | sed 's@\\:@:@g')

    ## Check to see if plugin exists, attempt to download the plugin if it does exist.
    if ! [[ -z "${DOWNLOAD_URL}" ]]; then
        printf "\t%-15s" ${PLUGIN}
        curl -k -Ls -o /opt/sonarqube/extensions-init/plugins/${PLUGIN}.jar ${DOWNLOAD_URL} >> /dev/null 2>&1 && printf "%10s" "DONE" || printf "%10s" "FAILED"
        printf "\n"
    else
        ## Plugin was not found in the plugin inventory
        printf "\t%-15s%10s\n" "${PLUGIN}" "NOT FOUND"
    fi
done
