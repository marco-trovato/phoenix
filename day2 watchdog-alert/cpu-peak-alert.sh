#!/bin/bash

#checking for peak cpu usage, not average but current
usage=$(vmstat 1 2 | tail -1 | awk "{ printf 100-\$15; }" )
if [[ "$usage" -gt 98 ]]
then
    echo "CPU peak: $usage" | mail -s "Peak CPU usage!" alert@claranet.com
fi

# Checking disk space
USE=`df -h |grep sda1 | awk '{ print $5 }' | cut -d'%' -f1`
echo Percentage disk used: $USE\%
if [ $USE -gt 90 ]; then
    echo "Percent disk used: $USE" | mail -s "Running out of disk space!" alert@claranet.com
fi
