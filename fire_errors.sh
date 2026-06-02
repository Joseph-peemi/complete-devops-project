#!/usr/bin/env bash
# Hammer the app homepage to probabilistically trigger the error condition
# Press Ctrl-C to stop the script when you have seen enough errors in the logs

URL="http://a885f9baacfae4b4696ae6aac20926a8-52893137.us-east-1.elb.amazonaws.com:8080"
COUNT=${1:-100}

echo "Hitting ${URL} ${COUNT} times to trigger errors..."
for i in $(seq 1 $COUNT); do
  code=$(curl -s -o /dev/null -w "%{http_code}" $URL)
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $i: -> HTTP $code"
  sleep 0.3
done