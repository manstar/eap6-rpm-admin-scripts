#!/bin/sh
if [ $# -ne 1 ]; then
  echo "Usage: $0 instance_name"
  exit 1
fi

INSTANCE_NAME=$1

JBOSS_INSTANCES_HOME=/var/lib/jbossas
JBOSS_HOME=${JBOSS_HOME:-"/usr/share/jbossas"}

JBOSS_BIN_HOME=$JBOSS_HOME/bin
JBOSS_ETC_HOME=/etc/jbossas
JBOSS_LOG_HOME=/var/log/jbossas
JBOSS_LIB_HOME=
JBOSS_TMP_HOME=/var/cache/jbossas

INSTANCE_HOME=$JBOSS_INSTANCES_HOME/$INSTANCE_NAME
SERVICE_NAME=jbossas-$INSTANCE_NAME
INITD_SERVICES_DIR=/etc/init.d
SYSCONFIG_DIR=/etc/sysconfig


rm -fr $INSTANCE_HOME
rm -fr $JBOSS_ETC_HOME/$INSTANCE_NAME
rm -fr $JBOSS_LOG_HOME/$INSTANCE_NAME
rm -fr $JBOSS_TMP_HOME/$INSTANCE_NAME
rm -fr $JBOSS_HOME/bin/$INSTANCE_NAME.*

rm -f $INITD_SERVICES_DIR/$SERVICE_NAME
rm -f $SYSCONFIG_DIR/$SERVICE_NAME
