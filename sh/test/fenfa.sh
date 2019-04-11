
if [ $# -ne 1 ]
  then
   echo "USAGE:/bin/sh $0 arg1"
   exit 1
fi

for n  in 8 9
do
	scp -P52113 -rp $1 oldgirl@10.0.0.$n:~
done
