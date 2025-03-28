#!/bin/bash

groupadd ftpgroup
useradd -g ftpgroup -d /dev/null -s /etc/ftpuser
pure-pw useradd root -u ftpuser -d /ftphome 
pure-pw mkdb
cd /etc/pure-ftpd/auth/
ln -s ../conf/pureDB60pdb
mkdir -p /ftphome
chown -R ftpuser:ftpgroup /ftphome/
/etc/init.d/pure-ftpd restart
