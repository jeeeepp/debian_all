#!/bin/bash

# turn on bash's job control
set -m

# Start the primary process and put it in the background

/usr/sbin/apache2ctl -DFOREGROUND &

# Start the helper process
npm start &

/usr/bin/java -Djava.awt.headless=true -jar /usr/share/java/jenkins.war --webroot=/var/cache/jenkins/war --httpPort=8080 &

mongod --bind_ip_all

# the my_helper_process might need to know how to wait on the
# primary process to start before it does its work and returns
wait -n

# now we bring the primary process back into the foreground
# and leave it there
exit $?