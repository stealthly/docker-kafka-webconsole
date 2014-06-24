#!/bin/bash
ZOOKEEPER=`docker ps -a | awk '{print $NF}'  | grep "zookeeper$"`
ZOOKEEPER_RUNNING=$?
if [ $ZOOKEEPER_RUNNING -eq 0 ] ;
then
    echo "Zookeeper is already running"
else
    echo "Starting Zookeeper"
    docker run -p 2181:2181  -h zkserver --name zkserver -d stealthly/docker-zookeeper
fi

ID=$1
PORT=$2
HOST_IP=$3

docker run --name=broker$ID -p $PORT:$PORT --link zkserver:zk -e BROKER_ID=$ID -e HOST_IP=$HOST_IP -e PORT=$PORT -d stealthly/docker-kafka
docker run --name=kafka-console -p 8080:8080 --link zkserver:localhost --link broker$ID:localhost -e PORT=$PORT -d stealthly/docker-kafka-webconsole
