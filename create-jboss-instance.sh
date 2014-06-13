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

mkdir -p $INSTANCE_HOME
mkdir -p $INSTANCE_HOME/data
mkdir -p $INSTANCE_HOME/deployments
mkdir -p $INSTANCE_HOME/lib

mkdir -p $JBOSS_ETC_HOME/$INSTANCE_NAME
mkdir -p $JBOSS_LOG_HOME/$INSTANCE_NAME
mkdir -p $JBOSS_TMP_HOME/$INSTANCE_NAME

cp -fr $JBOSS_ETC_HOME/standalone/*properties $JBOSS_ETC_HOME/$INSTANCE_NAME/

ln -s  $JBOSS_ETC_HOME/$INSTANCE_NAME $INSTANCE_HOME/configuration
ln -s  $JBOSS_LOG_HOME/$INSTANCE_NAME $INSTANCE_HOME/log
ln -s  $JBOSS_TMP_HOME/$INSTANCE_NAME $INSTANCE_HOME/tmp
ln -s  $INSTANCE_HOME                 $JBOSS_HOME/$INSTANCE_NAME

# Create standalone-* files and name them after $INSTANCE_NAME
cp  $JBOSS_ETC_HOME/standalone/standalone.xml $JBOSS_ETC_HOME/$INSTANCE_NAME/$INSTANCE_NAME.xml
cp  $JBOSS_ETC_HOME/standalone/standalone.xml $JBOSS_ETC_HOME/$INSTANCE_NAME/standalone.xml
for file in $(ls $JBOSS_ETC_HOME/standalone/standalone-*xml); do
  suffix=$(echo $file | cut -f2- -d-)
  cp $file $JBOSS_ETC_HOME/$INSTANCE_NAME/$INSTANCE_NAME-$suffix
done

# Copy files in bin/standalone.* and name them after $INSTANCE_NAME
for file in $(ls $JBOSS_BIN_HOME/standalone.*); do
  extension=$(echo $file | cut -f2- -d.)
  cp  $file $JBOSS_BIN_HOME/$INSTANCE_NAME.$extension
done
# Modify startup files to reference the new configuration
sed -i s/standalone.conf/$INSTANCE_NAME.conf/g $JBOSS_BIN_HOME/$INSTANCE_NAME.sh
sed -i s/JBOSS_HOME\\/standalone/JBOSS_HOME\\/$INSTANCE_NAME/g $JBOSS_BIN_HOME/$INSTANCE_NAME.sh

# Copy sysconfig file according to sysV conventions and replaces configuration inside with instance values
cp $SYSCONFIG_DIR/jbossas $SYSCONFIG_DIR/$SERVICE_NAME
sed -i s/#\ JBOSSCONF=\"standalone\"/JBOSSCONF=\\\"$INSTANCE_NAME\\\"/g $SYSCONFIG_DIR/$SERVICE_NAME

# Another value to replace
sed -i s/#\ JBOSS_SERVER_CONFIG=\"\"/JBOSS_SERVER_CONFIG=\\\"$INSTANCE_NAME.xml\\\"/g  $SYSCONFIG_DIR/$SERVICE_NAME

# Link the original startup script with our own (see /etc/init.d/jbossas for documentation)
ln -s $INITD_SERVICES_DIR/jbossas $INITD_SERVICES_DIR/$SERVICE_NAME

# Adds the service, reads the  sysV config in /etc/sysconfig/$SERVICE_NAME
chkconfig --add $SERVICE_NAME


chown -R jboss $JBOSS_ETC_HOME/$INSTANCE_NAME
chown -R jboss $JBOSS_LOG_HOME/$INSTANCE_NAME
chown -R jboss $JBOSS_TMP_HOME/$INSTANCE_NAME
chown -R jboss $JBOSS_HOME/$INSTANCE_NAME
chown -R jboss $INSTANCE_HOME


