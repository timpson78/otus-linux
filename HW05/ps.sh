#!/bin/bash

allproc=`ls /proc/ | grep -E *[0-9]| sort -n`

procArray=($allproc)
getProcInfo() {
	if [[ -f "/proc/$1/stat" ]];
	then
		echo `cat /proc/$1/stat`	
	fi			
}

printf  "%10s %5s %5s %5s %10s %10s %10s %10s %20s \n" PID  PPID  STATE  SID   NICE   PRI   RSS TIME  COMMAND
for ((i=0;i<${#procArray[*]};i++))
do
	procInfo=$(getProcInfo ${procArray[$i]})
	procInfoArray=($procInfo)
	if [[ $procInfo != "" ]];
	then	
		printf "%10s %5s %5s %5s %10s %10s %10s %10s %20s \n" ${procArray[$i]} ${procInfoArray[3]} ${procInfoArray[2]} ${procInfoArray[5]} \
						${procInfoArray[18]} ${procInfoArray[17]} ${procInfoArray[23]} ${procInfoArray[21]} ${procInfoArray[1]}  
	fi
done
