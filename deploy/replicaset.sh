#!/bin/bash

cd /data/store
mkdir -p member1 member2 member3

mongod --port 30001 --dbpath /data/store/member1 --logpath /data/store/member1/mongo.log --fork --replSet myReplicaSet --smallfiles --oplogSize 128
mongod --port 30002 --dbpath /data/store/member2 --logpath /data/store/member2/mongo.log --fork --replSet myReplicaSet --smallfiles --oplogSize 128
mongod --port 30003 --dbpath /data/store/member3 --logpath /data/store/member3/mongo.log --fork --replSet myReplicaSet --smallfiles --oplogSize 128

cd /home/centos/big-data-src
mongo --port 30001 < data/replica-set-config.js
