#!/bin/sh

if [ "$1" = 'redis-cluster' ]; then
    for port in `seq 30001 30006`; do
      mkdir -p /redis-conf/${port}
      mkdir -p /redis-data/${port}

      if [ -e /redis-data/${port}/nodes.conf ]; then
        rm /redis-data/${port}/nodes.conf
      fi
    done

    for port in `seq 30001 30006`; do
      PORT=${port} envsubst < /redis-conf/redis-cluster.tmpl > /redis-conf/${port}/redis.conf
    done

    supervisord -c /etc/supervisor/supervisord.conf
    sleep 3

    IP=`hostname -i`
    echo "yes" | ruby /redis/src/redis-trib.rb create --replicas 1 ${IP}:30001 ${IP}:30002 ${IP}:30003 ${IP}:30004 ${IP}:30005 ${IP}:30006
    tail -f /var/log/supervisor/redis*.log
else
  exec "$@"
fi
