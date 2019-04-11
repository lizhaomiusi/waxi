#!/bin/bash
rs_arr=( 
    10.0.0.11
    10.0.0.22
    10.0.0.33
    )

file_location=/var/html/test.html

function web_result {
    rs=`curl -I -s $1|awk 'NR==1{print $2}'`
    return $rs
}

function new_row {
cat >> $file_location <<eof
<tr>
<td bgcolor="$4">$1</td>
<td bgcolor="$4">$2</td>
<td bgcolor="$4">$3</td>
</tr>

eof
}

function auto_html {
    web_result $2
    rs=$?
    if [ $rs -eq 200 ]
    then
	new_row $1 $2 up green
    else
	new_row $1 $2 down red
    fi

}


main(){
while true
do

cat >> $file_location <<eof
<h4>he Status Of RS :</h4>
<meta http-equiv="refresh" content="1">
<table border="1">
<tr> 
<th>NO:</th>
<th>IP:</th>
<th>Status:</th>
</tr>

eof

for ((i=0;i<${#rs_arr[*]};i++)); do
    auto_html $i ${rs_arr[$i]}
done

cat >> $file_location <<eof
</table>
eof

sleep 2
> $file_location
done
}
main


