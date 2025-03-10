#!/bin/bash

while :
do
    tim=`date +"%Y-%m-%d %H:%M:%S"`
    oid=`echo $(($RANDOM % 10))`
    lat=`echo $(($RANDOM % 90))`
    dec1=`echo $(($RANDOM % 10000))`
    lon=`echo $(($RANDOM % 90))`
    dec2=`echo $(($RANDOM % 10000))`
    #sql="INSERT INTO sensor(oid, lat, lon, tim) VALUES ($oid, $lat, $lon, '$tim');"
    #echo $sql
    #psql -U and -d sensors -c "$sql"
    data="$oid\t${lat}.${dec1}\t${lon}.${dec2}\t$tim"
    echo -e $data
    sleep 1
done
