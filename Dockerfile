FROM sonarqube:latest
MAINTAINER Deven Phillips <deven.phillips@redhat.com>

ADD sonar.properties /opt/sonarqube/conf/sonar.properties
ADD run.sh /opt/sonarqube/bin/run.sh
CMD /opt/sonarqube/bin/run.sh
ADD https://update.sonarsource.org/update-center.properties /tmp/pluginList.txt
RUN cp -a /opt/sonarqube/data /opt/sonarqube/data-init && \
	cp -a /opt/sonarqube/extensions /opt/sonarqube/extensions-init && \
	chown 65534:0 /opt/sonarqube && chmod -R gu+rwX /opt/sonarqube
ADD plugins.sh /opt/sonarqube/bin/plugins.sh
RUN /opt/sonarqube/bin/plugins.sh findbugs pmd buildbreaker gitlab github ldap