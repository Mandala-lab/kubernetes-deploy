#!/bin/bash

set -x

cd /home/kubernetes/ || exit
mkdir -p redis
cd redis/ || exit



cat> redis_cluster.yaml <<EOF
apiVersion: v1
kind: ConfigMap
metadata:
  name: redis-cluster-config
data:
  redis-cluster-0.conf: |
    port 7111
    cluster-announce-bus-port 17111
    pidfile /data/redis-7111.pid
    logfile /data/redis-7111.log
    dbfilename dump-7111.rdb
    appendfilename "appendonly-7111.aof"
    cluster-config-file nodes-7111.conf
    protected-mode no
    tcp-backlog 511
    timeout 0
    tcp-keepalive 300
    daemonize no
    supervised no
    loglevel notice
    databases 1
    always-show-logo yes
    save 900 1
    save 300 10
    save 60 10000
    stop-writes-on-bgsave-error yes
    rdbcompression yes
    rdbchecksum yes
    dir /data
    masterauth redis#cluster#test
    slave-serve-stale-data yes
    slave-read-only yes
    replica-serve-stale-data yes
    replica-read-only yes
    repl-diskless-sync no
    repl-diskless-sync-delay 5
    repl-disable-tcp-nodelay no
    replica-priority 100
    requirepass redis#cluster#test
    lazyfree-lazy-eviction no
    lazyfree-lazy-expire no
    lazyfree-lazy-server-del no
    replica-lazy-flush no
    appendonly yes
    appendfsync everysec
    no-appendfsync-on-rewrite no
    auto-aof-rewrite-percentage 100
    auto-aof-rewrite-min-size 64mb
    aof-load-truncated yes
    aof-use-rdb-preamble yes
    lua-time-limit 5000
    cluster-enabled yes
    cluster-node-timeout 15000
    cluster-migration-barrier 1
    cluster-require-full-coverage yes
    slowlog-log-slower-than 10000
    slowlog-max-len 128
    latency-monitor-threshold 0
    notify-keyspace-events ""
    hash-max-ziplist-entries 512
    hash-max-ziplist-value 64
    list-max-ziplist-size -2
    list-compress-depth 0
    set-max-intset-entries 512
    zset-max-ziplist-entries 128
    zset-max-ziplist-value 64
    hll-sparse-max-bytes 3000
    stream-node-max-bytes 4096
    stream-node-max-entries 100
    activerehashing yes
    client-output-buffer-limit normal 0 0 0
    client-output-buffer-limit replica 256mb 64mb 60
    client-output-buffer-limit pubsub 32mb 8mb 60
    hz 10
    dynamic-hz yes
    aof-rewrite-incremental-fsync yes
    rdb-save-incremental-fsync yes
  redis-cluster-1.conf: |
    port 7112
    cluster-announce-bus-port 17112
    pidfile /data/redis-7112.pid
    logfile /data/redis-7112.log
    dbfilename dump-7112.rdb
    appendfilename "appendonly-7112.aof"
    cluster-config-file nodes-7112.conf
	...
  redis-cluster-2.conf: |
    port 7113
    cluster-announce-bus-port 17113
    pidfile /data/redis-7113.pid
    logfile /data/redis-7113.log
    dbfilename dump-7113.rdb
    appendfilename "appendonly-7113.aof"
    cluster-config-file nodes-7113.conf
	...
  redis-cluster-3.conf: |
    port 7114
    cluster-announce-bus-port 17114
    pidfile /data/redis-7114.pid
    logfile /data/redis-7114.log
    dbfilename dump-7114.rdb
    appendfilename "appendonly-7114.aof"
    cluster-config-file nodes-7114.conf
	...
  redis-cluster-4.conf: |
    port 7115
    cluster-announce-bus-port 17115
    pidfile /data/redis-7115.pid
    logfile /data/redis-7115.log
    dbfilename dump-7115.rdb
    appendfilename "appendonly-7115.aof"
    cluster-config-file nodes-7115.conf
	...
  redis-cluster-5.conf: |
    port 7116
    cluster-announce-bus-port 17116
    pidfile /data/redis-7116.pid
    logfile /data/redis-7116.log
    dbfilename dump-7116.rdb
    appendfilename "appendonly-7116.aof"
    cluster-config-file nodes-7116.conf
	...
EOF

set +x
