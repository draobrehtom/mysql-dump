#!/usr/bin/bash

INFO="pull.sh -e [local|development|stage|production] -s [inspiradb|inspiradb_dev|inspiradb_stage| ... ] -a [pull|push]"

EXEC_DIRECTORY="`dirname $0`"
ENVIRONMENT="local"
SCHEMA="inspiradb_dev"

CONFIG_LOCAL="$EXEC_DIRECTORY/config/mysql_config_local.ini"
CONFIG_DEV="$EXEC_DIRECTORY/config/mysql_config_dev.ini"
CONFIG_STAGE="$EXEC_DIRECTORY/config/mysql_config_stage.ini"
CONFIG_LIVE="$EXEC_DIRECTORY/config/mysql_config_live.ini"

OUTPUT_DIRECTORY="$EXEC_DIRECTORY/dumps/"

CONFIG=$CONFIG_LOCAL

ACTION="pull"

while getopts "e:s:h:a:" opt; do
       case $opt in
	
	       h) echo -e "\n Using Example:\n  >> $INFO \n  -e  environment  \n  -t  table  \n  -h  help" >&2
		       ;;
	       e) ENVIRONMENT=${OPTARG}
		       ;;
	       s) SCHEMA=${OPTARG}
		       ;;
	       a) ACTION=${OPTARG}
		       ;;
	       \?) echo "invalid options: -$OPTARG" >&2	
		       ;;
       esac
done


case "$ENVIRONMENT" in
	live) CONFIG=${CONFIG_LIVE} 	;;
	stage) CONFIG=${CONFIG_STAGE} 	;;
	dev) CONFIG=${CONFIG_DEV} 	;;
	local) CONFIG=${CONFIG_LOCAL}	;;
	\?) echo -e "\nUndefined environment" >&2 ;;
esac

echo -e "\nSelected Schema - $SCHEMA"
echo -e "Selected Config - $CONFIG"
echo -e "Selected Action - $ACTION"
echo -e "\n"
read -p "Press Enter to continue ... "


pull="mysqldump --defaults-extra-file=$CONFIG --ignore-table=inspiradb.request_log $SCHEMA > $OUTPUT_DIRECTORY$SCHEMA.sql"
push="mysql --defaults-extra-file=$CONFIG $SCHEMA < $OUTPUT_DIRECTORY$SCHEMA.sql"

case "$ACTION" in
	pull) eval $pull ;;
	push) eval $push ;;
	\?) echo -e "undefined action"
esac


