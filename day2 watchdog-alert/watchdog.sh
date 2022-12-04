#!/bin/bash

PIDOF=`which pidof`  # exact match
DATE=`date +%Y-%m-%d_%H-%M`

#if it gets no pids, service is not running
if [ ! "$(pidof www)" ]
then
  echo "[$DATE] Running tmux rtorrent..." >> /var/logs/cloud-phoenix-kata.log
  ~/cloud-phoenix-kata/www
else
  echo "[$DATE] www is running." >> /var/logs/cloud-phoenix-kata.log
fi
