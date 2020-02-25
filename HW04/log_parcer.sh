#!/bin/bash
lockfile='/tmp/lockfile.pid'
logfile='./access.log'
endatefile=./endate.file

if (set -o noclobber; echo "$$">"$lockfile")2>/dev/null
  then	
    trap 'rm -f "$lockfile";exit $?' INT TERM EXIT KILL	  
	if [[ -f $endatefile ]];
        	then
                	startdate=`cat $endatefile`;
        	else
a               		 startdate=`date +%d/%b/%Y:%H:%M:%S`;
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

	groupby_src_address=`awk -v startdate="$startdate" '$4>"["startdate' $logfile | awk '{a[$1]++;}END{for (i in a) print i"-"a[i]";"}' | sort -t'-'  -nk2 | tail -n $n` 
	groupby_dest_address=`awk -v startdate="$startdate" '$4>"["startdate' $logfile | awk 'match($15, /\/\/.*?\//){print substr($15, RSTART+2, RLENGTH-3)}' |  
		awk '{a[$1]++;}END{for (i in a) print i"-"a[i]";"}'| sort -t'-' -nk2 | tail -n $n`
	group_errors=`awk -v startdate="$startdate" '$4>"["startdate' $logfile | egrep -v '(200|301)' | wc -l`

	echo "LastDate:  $startdate"
	echo "The top src addresses: $groupby_src_address"
	echo "The top  dest addresses: $groupby_dest_address"
	echo "Errors: $group_errors"
	mail_text="The roportfrom date: $startdate The top src addresses: $groupby_src_address The top dest addresses: $groupby_dest_address Errors: $group_errors" 
	echo $mail_text | sendmail root@localhost
	trap "date +%d/%b/%Y:%H:%M:%S > ./$endatefile" SIGINT SIGHUP SIGKILL EXIT


      rm -f "$lockfile"
      trap - INT TERM EXIT
   else 
     echo "Logger is running"	   
fi     
