# Cassandra
#
# VERSION               1.0

FROM centos:centos7

# Add source repositories
ADD src/epel7.repo /etc/yum.repos.d/epel7.repo
ADD src/datastax.repo /etc/yum.repos.d/datastax.repo

# Install Java, Install packages (sshd + supervisord + monitoring tools + cassandra)
RUN yum install -y wget tar openssh-server openssh-clients supervisor sysstat sudo which openssl hostname
RUN yum install -y java-1.8.0-openjdk-headless
RUN yum install -y cassandra
RUN yum clean all

# Configure SSH server
# Create OpsCenter account
RUN mkdir -p /var/run/sshd && chmod -rx /var/run/sshd && \
	ssh-keygen -t rsa -N '' -f /etc/ssh/ssh_host_rsa_key && \
	sed -ri 's/#PermitRootLogin yes/PermitRootLogin yes/g' /etc/ssh/sshd_config && \
	sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config && \
	sed -ri 's/#UsePAM no/UsePAM no/g' /etc/ssh/sshd_config && \
	useradd -m -G users,root -p $(openssl passwd -1 "opscenter") opscenter && \
	echo "%root ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Configure supervisord
ADD src/supervisord.conf /etc/supervisord.conf
RUN mkdir -p /var/log/supervisor

# Deploy startup script
ADD src/start.sh /usr/local/bin/start

# Necessary since cassandra is trying to override the system limitations
# See https://groups.google.com/forum/#!msg/docker-dev/8TM_jLGpRKU/dewIQhcs7oAJ
RUN rm -f /etc/security/limits.d/cassandra.conf

#install graphite support
COPY src/graphite.yaml /etc/cassandra/conf/
RUN echo "JVM_OPTS=\"\$JVM_OPTS -Dcassandra.metricsReporterConfigFile=/etc/cassandra/conf/graphite.yaml\"" \
   >> /etc/cassandra/conf/cassandra-env.sh
COPY metrics-graphite-3.1.0.jar /usr/share/cassandra/lib/
RUN chmod +x /usr/share/cassandra/lib/metrics-graphite-3.1.0.jar && chown cassandra:cassandra /usr/share/cassandra/lib/metrics-graphite-3.1.0.jar && chmod +x /etc/cassandra/conf/graphite.yaml && chown cassandra:cassandra /etc/cassandra/conf/graphite.yaml

EXPOSE 7199 7000 7001 9160 9042
EXPOSE 22 8012 61621
USER root
CMD start
