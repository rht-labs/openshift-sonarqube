FROM sonarqube:latest
MAINTAINER Deven Phillips <deven.phillips@redhat.com>

RUN cp -a /opt/sonarqube/data /opt/sonarqube/data-init
RUN cp -a /opt/sonarqube/extensions /opt/sonarqube/extensions-init
RUN chown 65534:0 /opt/sonarqube && chmod -R gu+rwX /opt/sonarqube
ADD run.sh /opt/sonarqube/bin/run.sh
CMD /opt/sonarqube/bin/run.sh
ENV SONAR_PLUGIN_LIST="findbug pmd gitlab github ldap buildbreaker"