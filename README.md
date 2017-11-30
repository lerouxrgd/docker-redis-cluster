# Docker Redis Cluster

Largely based on [docker-redis-cluster](https://github.com/tommy351/docker-redis-cluster).

## Build the image

```sh
docker build -t redis-cluster .
```

## Run the image in background

```sh
docker run -d --rm --name redis-cluster \
 -p 30001:30001 -p 30002:30002 -p 30003:30003 \
 -p 30004:30004 -p 30005:30005 -p 30006:30006 \
 redis-cluster
```

## Routing local traffic

```sh
REDIS_HOST_IP=`docker exec -it redis-cluster hostname -i`
INTERFACE=en0 # depends on which interface you are, change it accrodingly
sudo ifconfig $INTERFACE inet $REDIS_HOST_IP netmask 255.255.255.255 up
```

## Stop the image

```sh
docker kill redis-cluster
```