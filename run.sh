#!/bin/bash

set -x
set -e

if ! [[ "${CA_CERT_URL}X" == "X" ]]; then
    curl "${CA_CERT_URL}" > /tmp/ca_cert
fi

cp /etc/ssl/certs/java/cacerts /opt/sonarqube/cacerts
chmod 775 /opt/sonarqube/cacerts

if [[ -f /tmp/ca_cert ]]; then
    keytool -importcert -keystore /opt/sonarqube/cacerts -storepass changeit -alias ocp_root -file /tmp/ca_cert
fi

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

java -jar lib/sonar-application-$SONAR_VERSION.jar \
    -Djavax.net.ssl.trustStore=/opt/sonarqube/cacerts -Djavax.net.ssl.trustStorePassword=changeit \
    -Dsonar.web.javaAdditionalOpts="${SONARQUBE_WEB_JVM_OPTS} -Djava.security.egd=file:/dev/./urandom" \
    "$@"
