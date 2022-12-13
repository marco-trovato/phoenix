#!/bin/bash

NOW=$(date +"%m-%d-%Y-%T")
DB_NAME="phoenix-db"
BACKUP_DIR="/var/backups/mongodb"
mkdir -p $BACKUP_DIR
mongodump -d $DB_NAME -o $BACKUP_DIR/$DB_NAME-$NOW

#backup rotation
RETENTION_DAYS=7
find $BACKUP_DIR/* -mtime +$RETENTION_DAYS -exec rm {} \;
