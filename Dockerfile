FROM nimmis/java-centos:oracle-8-jdk
# Get the version of DSE we're installing from the build argument
ARG DSE_VERSION
ENV DSE_VERSION ${DSE_VERSION}

# Upgrading system
RUN yum -y upgrade

COPY datastax.repo /etc/yum.repos.d/
RUN rpm --import https://rpm.datastax.com/rpm/repo_key && \
    curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/1.2/gosu-amd64" && \
    chmod +x /usr/local/bin/gosu
    
RUN yum -y  update && \
    yum -y  install dse-full-$DSE_VERSION && \
    yum -y  install datastax-agent 

# Volumes for Cassandra and Spark data
VOLUME /var/lib/cassandra /var/lib/spark /var/lib/dsefs /var/log/cassandra /var/log/spark

# Volume for configuration files in resources
VOLUME /etc/dse

# Entrypoint script for launching
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]

# Cassandra
EXPOSE 7000 9042 9160

# Solr
EXPOSE 8983 8984

# Spark
EXPOSE 4040 7080 7081 7077

# Hadoop
EXPOSE 8012 50030 50060 9290

# Hive/Shark
EXPOSE 10000

CMD [ "dse", "cassandra", "-f" ]
