#!/bin/bash

set -e

## If the mounted extensions volume is empty, populate it from the default data
if [[ "$(ls -A /opt/sonarqube/extensions)" ]]; then
	cp -a /opt/sonarqube/extensions-init /opt/sonarqube/extensions
fi

## If the mounted data volume is empty, populate it from the default data
if [[ "$(ls -A /opt/sonarqube/data)" ]]; then
	cp -a /opt/sonarqube/data-init /opt/sonarqube/data
fi

if [ "${1:0:1}" != '-' ]; then
  exec "$@"
fi

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
