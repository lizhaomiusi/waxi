#!/bin/sh

port=80
conf_path="/application/nginx/conf"
conf_file="nginx.conf"
html_path="/application/nginx/html"
html_file="monitor.html"
RS=($(grep WEB-A "$conf_path/$conf_file"|grep -v '#'|awk -F"[ :]+" '{print $2}'))


function proxy_delRs()
{  
	local ip=$1
	sed -i '/'$ip'/s/\(.*\);/\1 down;/g' "$conf_path/$conf_file" &> /dev/null
	[ $? -eq 0 ] && return 0 || return 1
}

function proxy_addRs()
{
	local ip=$1
	sed -i '/'$ip'/s/\(.*\)down;/\1;/g' "$conf_path/$conf_file" &> /dev/null
	[ $? -eq 0 ] && return 0 || return 1
}

function proxy_getWebServerType()
{
	local ip=$1
	local srvType=$(curl -I -s $ip|awk '/^Server/{print $2}'|cut -b1-5)

	if [ "$srvType" == "Apach" ];then
		return 1
	elif [ "$srvType" == "nginx" ];then
		return 0
	else
		return 2
	fi

}

function proxy_getRsStatus()
{
	local ip=$1
	if cat $conf_path/$conf_file|grep "$ip:$port\(.*\)down;" &>/dev/null;then
		return 0
	else
		return 1
	fi

}

function proxy_checkRsHealth()
{
	local ip=$1
	if [ "$(nmap $ip -p $port|awk '/80/{print $2}')" == "open" ];then
		return 0
	else 
		return 1
	fi

}

function proxy_checkHtml()
{
	
	if [ ! -f "$html_path/$html_file" ];then
		proxy_htmlInit
	fi
}

function proxy_sendStatToHtml()
{
	local rs=$1
	local string=$2


	if [ $string == "Good" ];then
	 sed -i /'<td id='${rs}'_stat'/s#.*#'				<td id='$rs'_stat align="center" bgcolor="green"> Good </td>'#g $html_path/$html_file  &>/dev/null
	else
	 sed -i /'<td id='${rs}'_stat'/s#.*#'				<td id='$rs'_stat align="center" bgcolor="red"> Bad </td>'#g $html_path/$html_file &>/dev/null
	fi
	
	proxy_getWebServerType $rs
	case $? in
	0)
	 sed -i /'<td id='${rs}'_type'/s#.*#'				<td id='${rs}'_type align="center"> Nginx </td>'#g $html_path/$html_file  &>/dev/null
	;;
	1)
	 sed -i /'<td id='${rs}'_type'/s#.*#'				<td id='${rs}'_type align="center"> Apache </td>'#g $html_path/$html_file  &>/dev/null
	;;
	2)
	 sed -i /'<td id='${rs}'_type'/s#.*#'				<td id='${rs}'_type align="center"> Unknow </td>'#g $html_path/$html_file  &>/dev/null
	;;
	*)
	;;
	esac
}

function proxy_htmlInit()
{

	echo  '<html>
	<head><h4 align="center"><font size="14"  style="color:grey"> Cluster Web Service Health Check</front></h4> 
	<meta http-equiv="refresh" content="1"> 
		<style> 
		tr,td{font-size:28px; 
		} 
		</style> 
	</head>
	<body>
		<table border=1 align="center">
			<tr size=20>
				<td bgcolor="Cyan" align="center"> Real Server Type </td>
				<td bgcolor="Cyan" > Real Server Host </td>
				<td bgcolor="Cyan" align="center"> Real Server Status </td>
			</tr>' > $html_path/$html_file 
	for rs in ${RS[@]}
	do

	proxy_getWebServerType $rs
	case $? in
	0)
	echo '			<tr size=20>
						<td id='${rs}_type' align="center"> Nginx </td>
						<td align="center"> '$rs' </td>' >> $html_path/$html_file
	;;
	1)
	echo '			<tr size=20>
						<td id='${rs}_type' align="center"> Apache </td>
						<td align="center"> '$rs'</td>' >> $html_path/$html_file
	;;
	2)
	echo '			<tr size=20>
						<td id='${rs}_type' align="center"> Unknow </td>
						<td align="center"> '$rs'</td>' >> $html_path/$html_file
	;;
	*)
	;;
	esac
	
	if proxy_checkRsHealth $rs;then
	echo '			<td id='${rs}_stat' align="center" bgcolor="green"> Good </td>
			</tr>' >> $html_path/$html_file
	else
	echo '			<td id='${rs}_stat' align="center" bgcolor="red"> Bad </td>
			</tr>' >> $html_path/$html_file
	fi
	done


	echo '		</table>
	</body>
</html>' >> $html_path/$html_file

}

function proxy_checkHealthHandler()
{
	proxy_checkHtml

	for rs in ${RS[@]}
	do
		if proxy_checkRsHealth $rs;then
			if proxy_getRsStatus $rs;then
				proxy_addRs $rs
				proxy_sendStatToHtml $rs "Good"
			fi 
		else
			if ! proxy_getRsStatus $rs;then
				proxy_delRs $rs
				proxy_sendStatToHtml $rs "Bad"
			fi 
		fi
	done
}

function main()
{
	proxy_htmlInit
	while true
	do
		proxy_checkHealthHandler
		sleep 1
	done
}

main
