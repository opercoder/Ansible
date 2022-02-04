#!/bin/bash
dirBack="/home/user/backup/data/data"
if [ ! -d "$dirVol" ]; then mkdir -p $dirVol
fi
cp -r /data $dirBack
tar -czf "/home/user/backup/data/container-server_data_$(date '+%Y-%m-%d').tar.gz" $dirBack
rm -r $dirBack
