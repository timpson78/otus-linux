#/bin/bash
logfile=./access.log
endatefile=./endate.file
if [[ -f $endatefile ]]; 
	then 
		startdate=`cat $endatefile`;
	else 
		startdate=`date +%d/%b/%Y:%H:%M:%S`;
fi	

if [[ $1 ]];
	then
		startdate=$1;
	fi	

if [[ -z $2 ]]; 
	then      	
		n=10;
	else	
		n=$2;
fi	

groupby_src_address=`awk -v startdate="$startdate" '$4>"["startdate' $logfile | awk '{a[$1]++;}END{for (i in a) print i" - "a[i]";" | "$2 sort -n";}' | tail -n $n`
groupby_dest_address=`awk -v startdate="$startdate" '$4>"["startdate' $logfile | awk 'match($15, /\/\/.*?\//){print substr($15, RSTART+2, RLENGTH-3)}' |  awk '{a[$1]++;}END{for (i in a) print i" - "a[i]";" | "$2 sort -n";}'` 
group_errors=`awk -v startdate="$startdate" '$4>"["startdate' $logfile | egrep -v '(200|301)' | wc -l`


echo $startdate
echo $groupby_src_address
echo $groupby_dest_address
echo "errors - $group_errors"
trap "date +%d/%b/%Y:%H:%M:%S > ./$endatefile" SIGINT SIGHUP SIGKILL EXIT 

#for i in $varlog  
#do 
#done
