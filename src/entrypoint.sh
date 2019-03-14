#!/bin/bash

REPO_DIR=/opt/repositories
CONFIG_DIR=/opt/config
BACKUP_DIR=/opt/backups
IMPORTS_DIR=/opt/imports

mkdir -p ${REPO_DIR} ${CONFIG_DIR} ${BACKUP_DIR} ${IMPORTS_DIR}
chown -R apache:apache ${REPO_DIR} ${CONFIG_DIR} ${BACKUP_DIR} ${IMPORTS_DIR}

touch ${CONFIG_DIR}/dav_svn.passwd
if [ ! -f ${CONFIG_DIR}/dav_svn.authz ]; then
    echo "[/]" >> ${CONFIG_DIR}/dav_svn.authz
    echo "* = rw" >> ${CONFIG_DIR}/dav_svn.authz
fi

pushd ${REPO_DIR}
for DUMP in `ls ${IMPORTS_DIR}`; do
    SVN=${DUMP%%.dump}

    if [ ! -d ${SVN} ]; then
        echo "Import ${DUMP}"
        svnadmin create ${SVN}
        svnadmin load ${SVN} < ${IMPORTS_DIR}/${DUMP}
    fi
done
popd

crond
exec /usr/sbin/apachectl -DFOREGROUND;
