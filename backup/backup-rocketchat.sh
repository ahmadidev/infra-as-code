#! /bin/bash
set -x

# There is no official doc on backup. Seems mongodb backup is enough.
# https://docs.mongodb.com/database-tools/mongodump/#mongodb-binary-bin.mongodump

TIMESTAMP=$(date -d "today" +"%Y-%m-%d-%H%M")
POD=$(kubectl get pods -l release=ocketchat,app=mongodb -o=name)
DUMP_FILENAME=rocketchat-mongodump-$TIMESTAMP.gz.tar
DUMP_PATH=/bitnami/mongodb/$DUMP_FILENAME
ZIP_FILENAME=rocketchat-mongodump-$TIMESTAMP.zip

kubectl exec $POD -- mongodump --gzip \
--username=ROCKETCHAT_USER --password=$ROCKETCHAT_PASS --authenticationDatabase=rocketchat \
--archive=$DUMP_PATH

kubectl cp rocketchat-mongodb-primary-0:$DUMP_PATH $DUMP_FILENAME

kubectl exec $POD -- rm $DUMP_PATH

sudo zip --password $ZIP_PASS -r $ZIP_FILENAME $DUMP_FILENAME

curl -T "$ZIP_FILENAME" $FTP_SERVER --user $FTP_USER:"$FTP_PASS"

rm $DUMP_FILENAME
rm $ZIP_FILENAME
