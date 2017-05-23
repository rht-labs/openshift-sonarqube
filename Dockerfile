FROM sonarqube:latest
MAINTAINER Deven Phillips <deven.phillips@redhat.com>

ADD sonar.properties /opt/sonarqube/conf/sonar.properties
RUN cp -a /opt/sonarqube/data /opt/sonarqube/data-init
RUN cp -a /opt/sonarqube/extensions /opt/sonarqube/extensions-init
RUN chown 65534:0 /opt/sonarqube && chmod -R gu+rwX /opt/sonarqube
ADD plugins.sh /opt/sonarqube/bin/plugins.sh
ADD run.sh /opt/sonarqube/bin/run.sh
CMD /opt/sonarqube/bin/run.sh
ARG SONAR_PLUGINS_LIST
ENV SONAR_PLUGINS_LIST 'findbugs pmd buildbreaker gitlab github ldap'
RUN echo $SONAR_PLUGINS_LIST
RUN /opt/sonarqube/bin/plugins.sh $SONAR_PLUGINS_LIST