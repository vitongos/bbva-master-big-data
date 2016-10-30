#!/bin/bash

sudo -i

cat << EOF > /etc/yum.repos.d/google-chrome.repo
[google-chrome]
name=google-chrome - \$basearch
baseurl=http://dl.google.com/linux/chrome/rpm/stable/\$basearch
enabled=1
gpgcheck=1
gpgkey=https://dl-ssl.google.com/linux/linux_signing_key.pub
EOF

yum install -y google-chrome-stable

cat << EOF > /etc/yum.repos.d/mongodb-org-3.2.repo
[mongodb-org-3.2]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/\$releasever/mongodb-org/3.2/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-3.2.asc
EOF

yum install -y mongodb-org

cat << EOF > /etc/security/limits.d/90-nproc.conf
mongod	soft	nproc	64000
EOF

cat << EOF > /etc/init.d/disable-transparent-hugepages
#!/bin/bash
### BEGIN INIT INFO
# Provides:          disable-transparent-hugepages
# Required-Start:    $local_fs
# Required-Stop:
# X-Start-Before:    mongod mongodb-mms-automation-agent
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Disable Linux transparent huge pages
# Description:       Disable Linux transparent huge pages, to improve
#                    database performance.
### END INIT INFO

case $1 in
  start)
    if [ -d /sys/kernel/mm/transparent_hugepage ]; then
      thp_path=/sys/kernel/mm/transparent_hugepage
    elif [ -d /sys/kernel/mm/redhat_transparent_hugepage ]; then
      thp_path=/sys/kernel/mm/redhat_transparent_hugepage
    else
      return 0
    fi

    echo 'never' > ${thp_path}/enabled
    echo 'never' > ${thp_path}/defrag

    re='^[0-1]+$'
    if [[ $(cat ${thp_path}/khugepaged/defrag) =~ $re ]]
    then
      # RHEL 7
      echo 0  > ${thp_path}/khugepaged/defrag
    else
      # RHEL 6
      echo 'no' > ${thp_path}/khugepaged/defrag
    fi

    unset re
    unset thp_path
    ;;
esac
EOF

chmod 755 /etc/init.d/disable-transparent-hugepages
/etc/init.d/disable-transparent-hugepages start

chkconfig --add disable-transparent-hugepages

chown centos:centos /opt -R
cd /opt/
wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u112-b15/jdk-8u112-linux-x64.tar.gz"
tar xzf jdk-8u112-linux-x64.tar.gz
cd /opt/jdk1.8.0_112/
alternatives --install /usr/bin/java java /opt/jdk1.8.0_112/bin/java 2
alternatives --config java
alternatives --install /usr/bin/jar jar /opt/jdk1.8.0_112/bin/jar 2
alternatives --install /usr/bin/javac javac /opt/jdk1.8.0_112/bin/javac 2
alternatives --set jar /opt/jdk1.8.0_112/bin/jar
alternatives --set javac /opt/jdk1.8.0_112/bin/javac

export JAVA_HOME=/opt/jdk1.8.0_112
export JRE_HOME=/opt/jdk1.8.0_112/jre
export PATH=$PATH:/opt/jdk1.8.0_112/bin:/opt/jdk1.8.0_112/jre/bin
cat << EOF > /etc/environment
JAVA_HOME=/opt/jdk1.8.0_112
JRE_HOME=/opt/jdk1.8.0_112/jre
EOF

cd /opt/
wget https://neo4j.com/artifact.php?name=neo4j-community-3.0.6-unix.tar.gz
tar xzf neo4j-community-3.0.6-unix.tar.gz
adduser neo4j -s /sbin/nologin
chown neo4j:centos /opt/neo4j-community-3.0.6 -R

cat << EOF > /lib/systemd/system/neo4j.service
[Unit] 
Description=Neo4j Management Service

[Service]
Type=forking
User=neo4j
ExecStart=/opt/neo4j-community-3.0.6/bin/neo4j start
ExecStop=/opt/neo4j-community-3.0.6/bin/neo4j stop
ExecReload=/opt/neo4j-community-3.0.6/bin/neo4j restart
RemainAfterExit=no
Restart=on-failure
PIDFile=/opt/neo4j-community-3.0.6/run/neo4j.pid
LimitNOFILE=60000
TimeoutSec=600

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable neo4j.service
service neo4j start

cd /opt
bunzip2 samples-database.tar.bz2
tar -xf samples-database.tar
rm samples-database.tar
wget http://ftp.fau.de/eclipse/technology/epp/downloads/release/mars/2/eclipse-jee-mars-2-linux-gtk-x86_64.tar.gz
tar xzf eclipse-jee-mars-2-linux-gtk-x86_64.tar.gz
ln -s /opt/eclipse/eclipse /usr/bin/eclipse

mkdir -p /data/Store
chown centos:centos /data -R
