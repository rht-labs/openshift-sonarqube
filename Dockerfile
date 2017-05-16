FROM sonarqube:latest
MAINTAINER Deven Phillips <deven.phillips@redhat.com>

RUN chgrp -R 0 /opt/sonarqube && chmod -R g+rwX /opt/sonarqube
RUN curl -L -o extensions/plugins/sonar-ldap-plugin.jar https://sonarsource.bintray.com/Distribution/sonar-ldap-plugin/sonar-ldap-plugin-2.1.0.507.jar
RUN curl -L -o extensions/plugins/sonar-github-plugin.jar https://sonarsource.bintray.com/Distribution/sonar-github-plugin/sonar-github-plugin-1.4.1.822.jar
RUN curl -L -o extensions/plugins/sonar-findbugs-plugin.jar https://github.com/SonarQubeCommunity/sonar-findbugs/releases/download/3.4.4/sonar-findbugs-plugin-3.4.4.jar
RUN curl -L -o extensions/plugins/sonar-pmd-plugin.jar https://github.com/SonarQubeCommunity/sonar-pmd/releases/download/2.6/sonar-pmd-plugin-2.6.jar
RUN curl -L -o extensions/plugins/sonar-gitlab-plugin.jar https://github.com/gabrie-allaigre/sonar-gitlab-plugin/releases/download/2.0.1/sonar-gitlab-plugin-2.0.1.jar
