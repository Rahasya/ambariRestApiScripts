#!/bin/bash

#Reads the ambari config properties from the property file
. ambari_config.properties

doAddHostAction(){
	curl --user $username:$PASSWORD \
	     -i -k -H "X-Requested-By: ambari" \
	     -X POST "http://$AMBARI_SERVER_HOST:$ambariPort/api/v1/clusters/$cluster/hosts/$NEW_HOST_FQDN"
}

uNamePass(){
	read -p "Ambari Username: " -t 5 username
	if [ $username == "" ]; then
		exit;
	else
		read -s -p "Ambari Password: " PASSWORD
	fi
	echo " "
}

uHostNamePass(){
	read -p "New Host FQDN : " -t 5 $NEW_HOST_FQDN
	if [ $username == "" ]; then
		exit;
	fi
	echo " "
}

uNamePass
uHostNamePass