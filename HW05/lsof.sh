#/bin/bash

printf "%10s %5s %10s %5s %10s %10s %10s %10s %15s\n" COMMAND PID USER FD TYPE DEVICE SIZE NODE NAME


getCommandInfo() {
        echo `cat /proc/$1/comm`
}

getReadlink() {
	echo `readlink /proc/$1/fd/$2`
}

getFileType() {
	if [[ $1 =~ ^\/ ]];
	then
		echo "file"
	else	
		echo `echo $1 | awk -F ':' '{print $1}'`	
	fi	
}

getFileSize() {
	if [[ $1 =~ ^\/ ]];
	then
		echo `stat -c %s $1`
	else	
		echo '-'
	fi	
}

getInode() {
	if [[ $1 =~ ^\/ ]];
	then
		echo `stat -c %i $1`
	else	
		echo `echo $1 | awk -F ':' '{print $2}' | tr -d '[]'`
	fi	
}

getProcUser(){
	uid=`grep Uid /proc/$1/status |  awk -F ':' '{print $2}' | awk '{print $1}'`
	echo `awk -F ':' -v uid="$uid" '$3 == uid {print $1}' /etc/passwd` 
}       	

getFileName() {
	if [[ $1 =~ ^\/ ]];
	then
		echo $1
	else	
		echo '-'
	fi	
}

getDevice() {
	devid=`grep mnt_id  /proc/$1/fdinfo/$2 | awk '{print $2}'`
	echo   `awk -v devid="$devid" '$1 == devid {print $3}' /proc/$1/mountinfo`
}


if [[ $# -eq 2 ]]; 
then
	if [[ "$1" -eq "-p" ]];
	then
		if [[ "$2" -gt 0 ]];
		then
			pid=$2 
			command=$(getCommandInfo $pid)
			allFd=`ls /proc/$pid/fd`	
			allFdArray=($allFd)
			for ((i=0;i<${#allFdArray[*]};i++))
			do
				rdlink=$(getReadlink $pid ${allFdArray[$i]})
				printf "%10s %5s %10s %5s %10s %10s %10s %10s %15s\n" $command $pid $(getProcUser $pid) ${allFdArray[$i]} $(getFileType $rdlink) $(getDevice $pid ${allFdArray[$i]}) $(getFileSize $rdlink) $(getInode $rdlink) $(getFileName $rdlink)
			done

		else
			echo "Process is a  number"
		fi	
	else
		echo "Please, type --help command"
	fi
else
	echo "false"
fi

