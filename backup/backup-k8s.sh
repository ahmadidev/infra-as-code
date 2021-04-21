#! /bin/bash
set -x

# https://elastisys.com/backup-kubernetes-how-and-why/

TIMESTAMP=$(date -d "today" +"%Y-%m-%d-%H%M")
POD=$(kubectl -n kube-system get pod -l component=etcd,tier=control-plane -o name)
ZIP_FILENAME=etcd-$TIMESTAMP.zip
ZIP_PATH=/var/lib/etcd/$ZIP_FILENAME
SNAPSHOT_PATH=/var/lib/etcd/etcd-snapshot-$TIMESTAMP

kubectl -n kube-system exec $POD -- sh -c "ETCDCTL_API=3 etcdctl  \
  --cert=/etc/kubernetes/pki/etcd/server.crt \
  --key=/etc/kubernetes/pki/etcd/server.key \
  --cacert=/etc/kubernetes/pki/etcd/ca.crt \
  snapshot save $SNAPSHOT_PATH"

sudo zip --password $ZIP_PASS -r $ZIP_PATH $SNAPSHOT_PATH /etc/kubernetes/pki /etc/kubernetes/admin.conf $(echo /etc/ssh/ssh_host_*)

sudo curl -T "$ZIP_PATH" $FTP_SERVER --user $FTP_USER:'$FTP_PASS'

sudo rm $SNAPSHOT_PATH
sudo rm $ZIP_PATH
