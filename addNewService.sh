#!/bin/bash

#Reads the ambari config properties from the property file
. ambari_config.properties

doAddServiceAction(){
	curl --user $username:$PASSWORD \
	     -i -k -H "X-Requested-By: ambari" \
	     -X POST "http://$AMBARI_SERVER_HOST:$ambariPort/api/v1/clusters/$cluster/hosts/$NEW_SERVICE"

	curl --user $username:$PASSWORD \
    	     -i -k -H "X-Requested-By: ambari" \
    	     -X PUT -d '{"RequestInfo": {"context" :"Installing '$NEW_SERVICE' via REST"}, "Body": {"ServiceInfo":{"state":"INSTALLED"}}}' \
    	     "http://$AMBARI_SERVER_HOST:$ambariPort/api/v1/clusters/$cluster/services/$NEW_SERVICE"

    curl --user $username:$PASSWORD \
    	     -i -k -H "X-Requested-By: ambari" \
    	     -X PUT -d '{"RequestInfo": {"context" :"Starting '$NEW_SERVICE' via REST"}, "Body": {"ServiceInfo":{"state":"STARTED"}}}' \
    	     "http://$AMBARI_SERVER_HOST:$ambariPort/api/v1/clusters/$cluster/services/$NEW_SERVICE"
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
	read -p "New Service: " -t 5 $NEW_SERVICE
	if [ $username == "" ]; then
		exit;
	fi
	echo " "
}

uNamePass
uHostNamePass