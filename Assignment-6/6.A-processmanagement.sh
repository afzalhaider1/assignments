#!/bin/bash

action="$1"

case $action in

topprocess)
	line="$2"
	unit="$3"
	if [ $3 == "memory" ];then
                ps -eo pid,ppid,user,cmd,%mem --sort=-%mem | head -n "$((line+1))"
        elif [ $3 == "cpu" ];then
                ps -eo pid,ppid,user,cmd,%cpu --sort=-%cpu | head -n "$((line+1))"
        else
                echo "Parameter is wrong: use memory or cpu."
        fi
 	;;
 	
killleastpriorityprocess)
	process=$(ps -eo pid,ni --sort=ni | tail -n 1 | awk '{print $1}')
		read -p "Are you sure you want to kill process with PID $process? (y/n): " answer
	if [ "$answer" == "y" ]; then
  		sudo kill -9 $process
  		echo "Least priority process with PID $pid has been killed."
  	else
            	echo "Kill process cancelled!!!"
	fi
		
 	;;
 	
runningdurationprocess)
	process="$2"
	if [[ "$2" =~ [^0-9] ]]; then
  		duration=$(ps -C "$process" -o etime=)
  		if [[ -n "$duration" ]]; then
  		echo "Process with $process has been running for: $duration."
  		else
  		echo "Process $process not found or is not running."
  		fi
  		
	else
  		duration=$(ps -p "$process" -o etime=)
  		if [[ -n "$duration" ]]; then
  		echo "Process with PID $process has been running for: $duration."
  		else
  		echo "Process with PID $process not found or is not running."
  		fi
	fi
	;;
 	
listorphanprocess)
	orphan=$(ps --ppid 1 -o pid,ppid,comm | awk '$2 == 1')
	if [[ -n "$orphan" ]]; then
	        echo "$orphan"
        else
                echo "Orphan process not found."
        fi
 	;;
 	
listzoombieprocess)
	zoombie=$(ps -eo pid,ppid,stat,comm | awk '$3 ~ /^Z/')
	if [[ -n "$zoombie" ]]; then
	        echo $zoombie
        else
                echo "Zoombie process not found."
        fi
 	;;
 		
killprocess)
	pid="$2"
	if [[ "$2" =~ [^0-9] ]]; then
    			read -p "Are you sure you want to kill process $pid? (y/n): " answer
   		 if [ "$answer" == "y" ]; then
       			 if pkill -9 "$pid" 2>/dev/null; then
                		echo "Process $pid has been killed."
           		 else
                		echo "Process $pid could not be killed or does not exist."
            		fi
        	else
            		echo "Kill process cancelled!!!"
        	fi
        	
	elif [ -n "$pid" ]; then
 			read -p "Are you sure you want to kill process with PID $pid? (y/n): " answer
   		 if [ "$answer" == "y" ]; then
        		if kill -9 "$pid" 2>/dev/null; then
                		echo "Process with PID $pid has been killed."
           		else
               			 echo "Process with PID $pid could not be killed or does not exist."
            		fi
        	else
            		echo "Kill process cancelled!!!"
        	fi
        fi	
	;;
	
listwaitingprocess)
	orphan=$(ps -eo pid,ppid,stat,comm | awk '$3 ~ /^D/')
	if [[ -n "$orphan" ]]; then
	        echo "$orphan"
        else
                echo "Waiting process not found."
        fi
 	;;
	
*)
         echo "Invalid action: Use action topprocess, killleastpriorityprocess, runningdurationprocess, listorphanprocess, listzoombieprocess, killprocess and listwaitingprocess"
         exit 1
     ;;
esac



