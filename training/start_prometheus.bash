#!/bin/bash
cp prometheus.yml /tmp/prometheus.yml
docker run --network rs-net --ip 172.1.0.181 -p 9090:9090 -v /tmp/prometheus.yml:/etc/prometheus/prometheus.yml prom/prometheus
