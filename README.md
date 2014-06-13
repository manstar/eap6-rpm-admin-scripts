#A comprehensive set of shell scripts used to perform administration action on JBoss EAP 6

## Installing JBoss EAP 6 RPM
    yum install jbossas-standalone

## Creating a JBoss EAP 6 instance which respect sysV conventions

    create-jboss-instance.sh instance_name

The instance home will be created under /var/lib/jbossas/instance_name and all the other directories and configuration will follow the sysV convention.
- A /etc/sysconfig/jbossas-instance_name service configuration is created pointing the JBOSSCONF to /etc/jbossas/instance_name/`
- A link from /etc/init.d/jboss to /etc/init.d/jbossas-instance_name is created
- A service called jbossas-instance_name is added
- Logs are in /var/log/jbossas/instance_name/
 
## Dropping a JBoss EAP 6 instance

    drop-jboss-instance.sh instance_name

Drops the created instance by doing rm -fr ! So be careful when using it.

## TODO
Add other scripts to do other usefull stuff. Please fork !!!!


