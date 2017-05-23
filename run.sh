#!/bin/bash

set -e

## If the mounted data volume is empty, populate it from the default data
if ! [[ "$(ls -A /opt/sonarqube/data)" ]]; then
    cp -a /opt/sonarqube/data-init /opt/sonarqube/data
fi

## If the mounted extensions volume is empty, populate it from the default data
if ! [[ -d /opt/sonarqube/data/plugins ]]; then
	cp -a /opt/sonarqube/extensions-init/plugins /opt/sonarqube/data/plugins
fi

## Link the plugins directory from the mounted volume
rm -rf /opt/sonarqube/extensions/plugins
ln -s /opt/sonarqube/data/plugins /opt/sonarqube/extensions/plugins

if [ "${1:0:1}" != '-' ]; then
  exec "$@"
fi

#chown -R 0:0 /opt/sonarqube && chmod -R g+rwX /opt/sonarqube

set

java -jar lib/sonar-application-$SONAR_VERSION.jar \
    -Dsonar.web.javaAdditionalOpts="${env:SONARQUBE_WEB_JVM_OPTS} -Djava.security.egd=file:/dev/./urandom" \
    "$@"
