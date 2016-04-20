#!/bin/bash

#Reads the ambari config properties from the property file
. ambari_config.properties


doServiceAction(){
	curl --user $username:$PASSWORD \
	     -i -k -H "X-Requested-By: ambari" \
	     -X PUT -d '{"RequestInfo": {"context" :"'$action' '$service' via REST"}, "Body": {"ServiceInfo":{"state":"'$state'"}}}' \
	     "http://$AMBARI_SERVER_HOST:$ambariPort/api/v1/clusters/$cluster/services/$service"
}

actionMenu(){
	echo " "
	echo "What action to perform on $service? "
	echo " 1. Start "
	echo " 2. Stop "
	echo " 3. Back "
	echo " "
}

serviceAction(){
	while true; do
		actionMenu
	    read -p "Select > " number
	    case $number in
	        1 ) state='STARTED'; action="Starting"; doServiceAction; break;;
	        2 ) state='INSTALLED'; action="Stopping"; doServiceAction; break;;
			3 ) break;;
	        * ) echo "Trying Again.";;
	    esac
	done
}

printMenu(){
	lineNum=1
	echo " "
	for i in `cat $SERVICE_FILE`; do
		echo $lineNum $i
	    ((lineNum++))
	done
	echo "$lineNum Start All Services" ; ((lineNum++))
	echo "$lineNum Stop All Services" ; ((lineNum++))
	echo "$lineNum (Q)uit"
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

startAll(){
	for i in `cat $SERVICE_FILE`; do
		echo "Starting $i"
		state='STARTED'; action="Starting"; service=$i; curlServices;
	done
	echo "Cluster is Starting..."
}

stopAll(){
	for i in `tail -r $SERVICE_FILE`; do
		echo "Stopping $i"
		state='INSTALLED'; action="Stopping"; service=$i; curlServices;
	done
	echo "Cluster is Stopping..."
}

menuCase(){
	while true; do
		printMenu
		echo " "
		read -p "Select Service: " value
		case $value in
			1 )  service="ZOOKEEPER"; serviceAction;;
			2 )  service="HDFS"; serviceAction;;
			3 )  service="YARN"; serviceAction;;
			4 )  service="MAPREDUCE2"; serviceAction;;
			5 )  service="HIVE"; serviceAction;;
			6 )  service="HBASE"; serviceAction;;
			7 )  service="OOZIE"; serviceAction;;
			8 )  service="FALCON"; serviceAction;;
			9 )  service="FLUME"; serviceAction;;
			10 ) service="SMARTSENCE"; serviceAction;;
			11 ) service="AMBARIMETRICS"; serviceAction;;
			12 ) service="RANGER"; serviceAction;;
			13 ) startAll;;
			14 ) stopAll;;
			15|[Qq][Uu][Ii][Tt]|q ) echo "Goodbye!"; exit;;
			* ) echo "Trying Again.";;
		esac
	done
}


uNamePass
menuCase