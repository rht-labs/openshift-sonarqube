FROM sonarqube:latest
MAINTAINER Deven Phillips <deven.phillips@redhat.com>

RUN chgrp -R 0 /opt/sonarqube && chmod -R g+rwX /opt/sonarqube
