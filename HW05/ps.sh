#!/bin/bash

allproc=`ls /proc/ | grep -E *[0-9]| sort -n`
#echo $allproc

#array=$('echo ${allproc'})
procArray=($allproc)
#IFS=' ' read -a array <<< "$allproc"
#array=$(echo $allproc | tr " " "\n")
getProcInfo() {
	echo `cat /proc/$1/stat`	
}

printf  "%10s %5s %5s %5s %10s %10s %10s %10s %20s \n" PID  PPID  STATE  SID   NICE   PRI   RSS TIME  COMMAND
for ((i=0;i<${#procArray[*]};i++))
do
	procInfo=$(getProcInfo ${procArray[$i]})
	procInfoArray=($procInfo)
	printf "%10s %5s %5s %5s %10s %10s %10s %10s %20s \n" ${procArray[$i]} ${procInfoArray[3]} ${procInfoArray[2]} ${procInfoArray[5]} ${procInfoArray[18]} ${procInfoArray[17]} ${procInfoArray[23]} ${procInfoArray[21]} ${procInfoArray[1]}  
done


#for s in "${procArray}"; do 
#    echo "_  $s"
#done

