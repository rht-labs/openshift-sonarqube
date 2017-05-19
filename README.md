# SonarQube For Red Hat Open Innovation Labs
This is a modified Docker image based on the public sonarqube:latest
image, but it has been modified to allow permissions to be run in an
OpenShift environment.

## Overview
This image repository builds on the public Docker image for SonarQube. It adds a capability to automatically install
plugins the first time the container is run. It also supports persistent volumes for configuration and plugins. The
plugins will only be automatically installed on the first run with a new volume. The container image is also 
configurable. You can provide no environment variables for configuration and the container will run with the built-in
H2 DB and local authentication, but you can pass in configuration properties as listed below to customize the runtime.

## Plugin Installation
When the container is run, the environment variable "SONAR_PLUGIN_LIST" should contain a space separated list of 
plugins which should be installed on the container's first startup.

## Configuration
Some configuration settings are well defined, but you can always pass additional configuration using the catchall
`SONARQUBE_WEB_JVM_OPTS`. Any Java properties placed in this environment variable will be passed to the SonarQube 
application. The format of the Java properties is like `-Dsome.java.property=someValue`, so you can add an environment
variable like `SONARQUBE_WEB_JVM_OPTS="-Dsonar.auth.google.allowUsersToSignUp=false -Dsonar.auth.google.enabled=true"`

### Pre-defined Configuration Variables

* Variable: **SONARQUBE_WEB_JVM_OPTS**
  * Description: Extra startup properties for SonarQube (in the form of "-Dsonar.someProperty=someValue")
  * Default Value:
* Variable: **SONARQUBE_JDBC_USERNAME**
  * Description: Username used for SonarQube database authentication (leave blank to use ephemeral database)
  * Default Value:
* Variable: **SONARQUBE_JDBC_PASSWORD**
  * Description: Password used for SonarQube database authentication (leave blank to use ephemeral database)
  * Default Value:
* Variable: **SONARQUBE_JDBC_URL**
  * Description: Password used for SonarQube database authentication (leave blank to use ephemeral database)
  * Default Value:
* Variable: **SONARQUBE_LDAP_BINDDN**
  * Description: Bind DN for LDAP authentication (leave blank for local authentication)
  * Default Value:
* Variable: **SONARQUBE_LDAP_BINDPASSWD**
  * Description: Bind password for LDAP authentication (leave blank for local authentication)
  * Default Value:
* Variable: **SONARQUBE_LDAP_URL**
  * Description: LDAP URL for authentication (leave blank for local authentication)
  * Default Value:
* Variable: **SONARQUBE_LDAP_REALM**
  * Description: LDAP Realm
  * Default Value:
* Variable: **SONARQUBE_LDAP_CONTEXTFACTORY**
  * Description: JNDI ContextFactory class to be used
  * Default Value: com.sun.jndi.ldap.LdapCtxFactory
* Variable: **SONARQUBE_LDAP_STARTTLS**
  * Description: Enable StartTLS for the LDAP connection
  * Default Value: "false"
* Variable: **SONARQUBE_LDAP_AUTHENTICATION**
  * Description:  LDAP authentication method (simple | CRAM-MD5 | DIGEST-MD5 | GSSAPI)
  * Default Value: simple
* Variable: **SONARQUBE_LDAP_USER_BASEDN**
  * Description: LDAP BaseDN under which to search for user objects
  * Default Value:
* Variable: **SONARQUBE_LDAP_USER_REQUEST**
  * Description: LDAP filter to select user objects
  * Default Value: (&(objectClass=inetOrgPerson)(uid={login}))
* Variable: **SONARQUBE_LDAP_USER_REAL_NAME_ATTR**
  * Description: LDAP attribute which holds the user's full name
  * Default Value: cn
* Variable: **SONARQUBE_LDAP_USER_EMAIL_ATTR**
  * Description: LDAP attribute which holds the user's e-mail address
  * Default Value: mail
* Variable: **SONARQUBE_LDAP_GROUP_BASEDN**
  * Description: LDAP BaseDN under which to search for group objects
  * Default Value:
* Variable: **SONARQUBE_LDAP_GROUP_REQUEST**
  * Description: LDAP filter to select group objects
  * Default Value: (&(objectClass=groupOfUniqueNames)(uniqueMember={dn}))
* Variable: **SONARQUBE_LDAP_GROUP_ID_ATTR**
  * Description: LDAP attribute which holds the group's ID
  * Default Value: cn
* Variable: **SONARQUBE_BUILDBREAKER_MAX_ATTEMPTS**
  * Description: Build Break plugin - Max number of poll attempts
  * Default Value: "30"
* Variable: **SONARQUBE_BUILDBREAKER_INTERVAL**
  * Description: Build Breaker plugin - Interval to wait between poll requests
  * Default Value: "20000"
* Variable: **SONARQUBE_BUILDBREAKER_THRESHOLD**
  * Description: Build Breaker plugin - Threshold at which a build will instantly break
  * Default Value: "CRITICAL"
* Variable: **SONAR_BUILDBREAKER_DISABLE**
  * Description: Build Breaker plugin - Disable the build breaker plugin for all builds
  * Default Value: "true"
