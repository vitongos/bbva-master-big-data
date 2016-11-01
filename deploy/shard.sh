#!/bin/bash

cd /data/store
mkdir -p shard1 shard2 shard3

mongod --port 30101 --dbpath /data/store/shard1 --logpath /data/store/shard1/mongo.log --fork --smallfiles --oplogSize 128
mongod --port 30102 --dbpath /data/store/shard2 --logpath /data/store/shard2/mongo.log --fork --smallfiles --oplogSize 128
mongod --port 30103 --dbpath /data/store/shard3 --logpath /data/store/shard3/mongo.log --fork --smallfiles --oplogSize 128

mkdir -p confsvr1
mongod --configsvr --port 30201 --dbpath /data/store/confsvr1 --logpath /data/store/confsvr1/mongo.log --fork 

mkdir -p mongos1
mongos --configdb localhost:30201 --port 30202 --logpath /data/store/mongos1/mongo.log --fork 

cd /home/centos/big-data-src
mongo --port 30202 < scripts/shard-config.js
