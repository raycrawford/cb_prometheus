#!/bin/bash

END=10
for ((i=1;i<=END;i++)); do
    echo $i
    curl http://192.168.54.21/json/1.2.3.4
    if [ $i -eq 9 ] 
    then
            i=0
            # sleep 1
    fi
done
