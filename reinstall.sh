#!/usr/bin/env bash

# Reinstall elateXam server and dependent projects
# completely on a locally running tomcat.

# ---------------------------------------------------------
# Configuration
# ---------------------------------------------------------

# Base directory of elateXam,
# e.g. your git clone's root 
BASE=$HOME/projects/ialt/elateXam

# Tomcat base directory
TOMCAT_HOME=$HOME/opt/apache-tomcat-5.5.26

# ---------------------------------------------------------
# Actions
# ---------------------------------------------------------

TASKMODEL_BASE=$BASE/taskmodel
TASKMODEL_SCHEMA_BASE=$BASE/taskmodel-schema
EXAMSERVER_BASE=$BASE/examServer

PWD=`pwd`

echo "Stopping Tomcat..."
$TOMCAT_HOME/bin/shutdown.sh

echo "Cleaning Tomcat..."
rm -rf $TOMCAT_HOME/webapps/taskmodel-core-view.war
rm -rf $TOMCAT_HOME/webapps/taskmodel-core-view
rm -rf $TOMCAT_HOME/webapps/examServer.war
rm -rf $TOMCAT_HOME/webapps/examServer

rm -rf $TOMCAT_HOME/work/Catalina/localhost/examServer
rm -rf $TOMCAT_HOME/work/Catalina/localhost/taskmodel-core-view
rm -rf $TOMCAT_HOME/conf/Catalina/localhost/examServer*
rm -rf $TOMCAT_HOME/conf/Catalina/localhost/taskmodel-core-view*

echo "Rebuild schema ..."
cd $TASKMODEL_SCHEMA_BASE
mvn clean install

echo "Deploying taskmodel-core-view..."
cd $TASKMODEL_BASE
mvn install -PdeployTomcat -Dtomcat.path=$TOMCAT_HOME

echo "Deploying examServer..."
cd $EXAMSERVER_BASE
mvn install -PdeployTomcat -Dtomcat.path=$TOMCAT_HOME

echo "Starting tomcat..."
$TOMCAT_HOME/bin/startup.sh

cd $PWD

# OS X
if [ "Darwin" == `uname -s` ]; then
	echo "Opening .. http://localhost:8080/examServer"
	sleep 3 && open "http://localhost:8080/examServer"
fi

