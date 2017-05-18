#!/bin/bash

set -e

## If the mounted data volume is empty, populate it from the default data
## The plugins.txt file lists plugins which should be installed.
if ! [[ "$(ls -A /opt/sonarqube/data)" ]]; then
    cp -a /opt/sonarqube/data-init /opt/sonarqube/data
fi

## If the mounted extensions volume is empty, populate it from the default data
if ! [[ -d /opt/sonarqube/data/plugins ]]; then
	cp -a /opt/sonarqube/extensions-init/plugins /opt/sonarqube/data/plugins
	curl -s https://update.sonarsource.org/update-center.properties | grep downloadUrl > /tmp/pluginList.txt
	printf "Downloading additional plugins\n"
    for PLUGIN in $(echo $PLUGIN_LIST)
    do
        printf "\t${PLUGIN}..."
        DOWNLOAD_URL=$(cat /tmp/pluginList.txt | grep ${PLUGIN} | sort -V | tail -n 1 | awk -F"=" '{print $2}' | sed 's@\\:@:@g')
        curl -Ls -o /opt/sonarqube/data/plugins/${PLUGIN}.jar ${DOWNLOAD_URL}
        printf "\n"
    done
fi

rm -rf /opt/sonarqube/extensions/plugins
ln -s /opt/sonarqube/data/plugins /opt/sonarqube/extensions/plugins

if [ "${1:0:1}" != '-' ]; then
  exec "$@"
fi

chown -R 0:65534 /opt/sonarqube && chmod -R g+rwX /opt/sonarqube

exec java -jar lib/sonar-application-$SONAR_VERSION.jar \
  -Dsonar.log.console=true \
  -Dsonar.jdbc.username="$SONARQUBE_JDBC_USERNAME" \
  -Dsonar.jdbc.password="$SONARQUBE_JDBC_PASSWORD" \
  -Dsonar.jdbc.url="$SONARQUBE_JDBC_URL" \
  -Dldap.bindDn="$SONARQUBE_LDAP_BINDDN" \
  -Dldap.bindPassword="$SONARQUBE_LDAP_BINDPASSWD" \
  -Dldap.url="$SONARQUBE_LDAP_URL" \
  -Dldap.realm="$SONARQUBE_LDAP_REALM" \
  -Dldap.contextFactoryClass="$SONARQUBE_LDAP_CONTEXTFACTORY" \
  -Dldap.StartTLS="$SONARQUBE_LDAP_STARTTLS" \
  -Dldap.authentication="$SONARQUBE_LDAP_AUTHENTICATION" \
  -Dldap.user.naseDn="$SONARQUBE_LDAP_USER_BASEDN" \
  -Dldap.user.request="$SONARQUBE_LDAP_USER_REQUEST" \
  -Dldap.user.realNameAttribute="$SONARQUBE_LDAP_USER_REAL_NAME_ATTR" \
  -Dldap.user.emailAttribute="$SONARQUBE_LDAP_USER_EMAIL_ATTR" \
  -Dldap.group.baseDn="$SONARQUBE_LDAP_GROUP_BASEDN" \
  -Dldap.group.request="$SONARQUBE_LDAP_GROUP_REQUEST" \
  -Dldap.group.idAttribute="$SONARQUBE_LDAP_GROUP_ID_ATTR" \
  -Dsonar.buildbreaker.skip=$SONAR_BUILDBREAKER_DISABLE \
  -Dsonar.buildbreaker.queryMaxAttempts=$SONARQUBE_BUILDBREAKER_MAX_ATTEMPTS \
  -Dsonar.buildbreaker.queryInterval=$SONARQUBE_BUILDBREAKER_INTERVAL \
  -Dsonar.buildbreaker.preview.issuesSeverity=$SONARQUBE_BUILDBREAKER_THRESHOLD \
  -Dsonar.web.javaAdditionalOpts="$SONARQUBE_WEB_JVM_OPTS -Djava.security.egd=file:/dev/./urandom" \
  "$@"
