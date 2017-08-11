FROM sonarqube:latest
MAINTAINER Deven Phillips <deven.phillips@redhat.com>

USER root
ADD sonar.properties /opt/sonarqube/conf/sonar.properties
ADD run.sh /opt/sonarqube/bin/run.sh
RUN cp -a /opt/sonarqube/data /opt/sonarqube/data-init && \
	cp -a /opt/sonarqube/extensions /opt/sonarqube/extensions-init
ADD plugins.sh /opt/sonarqube/bin/plugins.sh
RUN /opt/sonarqube/bin/plugins.sh pmd gitlab github ldap
RUN chown root:root /opt/sonarqube -R
RUN chmod 775 /opt/sonarqube -R
CMD /opt/sonarqube/bin/run.sh
USER 1001