#!/bin/bash
rm -rf /tmp/history.json 
dunstctl history >> /tmp/history.json 
jq  '.data.[0][].id.data' /tmp/history.json | while read -r id; do
dunstctl history-pop $id
done
sleep 3
dunstctl close-all
