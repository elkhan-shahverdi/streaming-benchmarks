#!/usr/bin/env bash

KAFKA_STREAM_VERSION=${KAFKA_STREAM_VERSION:-"3.6.1"}
KAFKA_VERSION=${KAFKA_VERSION:-"3.6.1"}
REDIS_VERSION=${REDIS_VERSION:-"7.2.4"}
SCALA_BIN_VERSION=${SCALA_BIN_VERSION:-"2.13"}
SCALA_SUB_VERSION=${SCALA_SUB_VERSION:-"13"}
STORM_VERSION=${STORM_VERSION:-"1.2.1"}
FLINK_VERSION=${FLINK_VERSION:-"1.18.1"}
SPARK_VERSION=${SPARK_VERSION:-"3.5.0"}
HAZELCAST_VERSION=${HAZELCAST_VERSION:-"0.6"}

        <flink.kafka.connector.version>3.0.2-1.18</flink.kafka.connector.version>
        <scala.binary.version>2.13</scala.binary.version>
        <scala.version>2.11.11</scala.version>


STORM_DIR="apache-storm-$STORM_VERSION"
REDIS_DIR="redis-$REDIS_VERSION"
KAFKA_DIR="kafka_$SCALA_BIN_VERSION-$KAFKA_VERSION"
KAFKA_STREAM_DIR="kafka_$SCALA_BIN_VERSION-$KAFKA_STREAM_VERSION"
FLINK_DIR="flink-$FLINK_VERSION"
SPARK_DIR="spark-$SPARK_VERSION-bin-hadoop2.6"
HAZELCAST_DIR="hazelcast-jet-$HAZELCAST_VERSION"

#Get one of the closet apache mirrors
APACHE_MIRROR="https://archive.apache.org/dist"

ZK_HOST="localhost"
ZK_PORT="2181"
ZK_CONNECTIONS="$ZK_HOST:$ZK_PORT"
TOPIC=${TOPIC:-"ad-events"}
PARTITIONS=${PARTITIONS:-1}

CONF_FILE=./conf/localConf.yaml

TPS=${TPS:-10}
TEST_TIME=${TEST_TIME:-60}

SPARK_MASTER_HOST="stream-node01"
BATCH="3000"
