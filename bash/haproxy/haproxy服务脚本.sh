#!/bin/bash
#
#	haproxy :
#
# chkconfig 2345 85 15
# description: haproxy
#

DAEMON=haproxy
PROG_DIR=/usr/local/haproxy
PIDFILE=/var/run/haproxy.pid

state(){
	STAT=$(netstat -tlnp | grep $DAEMON)
	if [ -n  "$STAT" ];then
		return 1
	else
		return 0
	fi
}

start (){
	state
	code=$?
	if [ $code -eq 1 ];then
		echo "$DAEMON is aready started."
	else
		${PROG_DIR}/sbin/$DAEMON -f ${PROG_DIR}/conf.d/${DAEMON}.cfg
		echo -e "$DAEMON start \t\t\t \e[32;1m[OK]\e[0m"
	fi
}

stop () {
	state
	if [ $? -eq 1 ];then
		kill $(pidof $DAEMON)
		echo -e "$DAEMON stop \t\t\t \e[32;1m[OK]\e[0m"
	else
		echo "$DAEMON is aready stoped."
	fi
}

restart (){
	${PROG_DIR}/sbin/$DAEMON -f ${PROG_DIR}/conf.d/${DAEMON}.cfg -st $(cat $PIDFILE)
	if [ $? -eq 0 ];then
		echo -e  "$DAEMON restart \t\t\t \e[32;1m[OK]\e[0m"
	fi
}

status () {
	state
	if [ $? -eq 0 ];then
		echo "$DAEMON is stoped."
	else
		echo "$DAEMON is running."
	fi
}

case "$1" in
start)
	start
	;;
stop)
	stop
	;;
restart)
	restart
	;;
status)
	status
	;;
*)
	echo "Usage: $DAEMON {start|stop|restart|status}"
esac