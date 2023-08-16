#!/bin/bash

FILE="/home/afzal/git/services.txt"

process_manager() {
    local operation="$1"

    case "$operation" in
        register)
            local alias=""
            local path=""
            while [[ $# -gt 0 ]]; do
                case "$1" in
                    -s)
                        path="$2"
                        shift 2
                        ;;
                    -a)
                        alias="$2"
                        shift 2
                        ;;
                    *)
                        shift
                        ;;
                esac
            done

            if [ -z "$alias" ] || [ -z "$path" ]; then
                echo "Invalid arguments: Use -o register -s <path> -a <alias>"
                exit 1
            fi

            echo "$alias:$path" >> "$FILE"
            echo "Registered the service with alias '$alias'."
            ;;

        start)
            local alias=""
            while [[ $# -gt 0 ]]; do
                case "$1" in
                    -a)
                        alias="$2"
                        shift 2
                        ;;
                    *)
                        shift
                        ;;
                esac
            done

            if [ -z "$alias" ]; then
                echo "Invalid arguments: Use -o start -a <alias>"
                exit 1
            fi

            local service=$(grep -w "$alias" "$FILE" | cut -d':' -f2)
            if [ -z "$service" ]; then
               echo "Service '$alias' is not registered." 
            else
            	nohup bash "$service" > /dev/null 2>&1 &
                echo "Service '$alias' has been started."               
            fi
            ;;

        status)
            local alias=""
            while [[ $# -gt 0 ]]; do
                case "$1" in
                    -a)
                        alias="$2"
                        shift 2
                        ;;
                    *)
                        shift
                        ;;
                esac
            done

            if [ -z "$alias" ]; then
                echo "Invalid arguments: use -o status -a <alias>"
                exit 1
            fi

            local pid=$(pgrep -f "$(grep -w "$alias" "$FILE" | cut -d':' -f2)")
            if [ -z "$pid" ]; then
                echo "Service '$alias' is not running."
            else
            	echo "Service '$alias' (PID: $pid) is running."               
            fi
            ;;

        kill)
            local alias=""
            while [[ $# -gt 0 ]]; do
                case "$1" in
                    -a)
                        alias="$2"
                        shift 2
                        ;;
                    *)
                        shift
                        ;;
                esac
            done

            if [ -z "$alias" ]; then
                echo "Invalid arguments: use -o kill -a <alias>"
                exit 1
            fi

            local pid=$(pgrep -f "$(grep -w "$alias" "$FILE" | cut -d':' -f2)")
            if [ -z "$pid" ]; then
                echo "Service '$alias' is not running."
            else
            	kill "$pid"
                echo "Service '$alias' (PID: $pid) has been killed."
                
            fi
            ;;

        priority)
            local alias=""
            local priority=""
            while [[ $# -gt 0 ]]; do
                case "$1" in
                    -p)
                	priority="$2"
                	shift 2
                ;;
           	   -a)
                	alias="$2"
                	shift 2
                ;;
                    *)
                        shift
                        ;;
                esac
            done

            if [ -z "$alias" ] || [ -z "$priority" ]; then
                echo "Invalid arguments: use -o priority -p <low/med/high> -a <alias>"
                exit 1
            fi

            local pid=$(pgrep -f "$(grep -w "$alias" "$FILE" | cut -d':' -f2)")

            case "$priority" in
                "low")
                    sudo renice 10 "$pid"
                    ;;
                "med" | "medium")
                    sudo renice 0 "$pid"
                    ;;
                "high")
                    sudo renice -n -10 -p "$pid"
                    ;;
                *)
                    echo "Invalid priority option: Use 'low', 'med', or 'high'."
                    exit 1
                    ;;
            esac

            echo "Service '$alias' priority set to $priority."
            ;;

        list)
            awk -F ':' '{ print $1 }' "$FILE"
            ;;

        top)
            local alias=""
            while [[ $# -gt 0 ]]; do
                case "$1" in
                    -a)
                        alias="$2"
                        shift 2
                        ;;
                    *)
                        shift
                        ;;
                esac
            done
            
    		if [ -z "$alias" ]; then
       			echo "Invalid arguments: use -o top -a <alias>"
        		exit 1
   		fi

   		local service=$(grep -w "$alias" "$FILE" | cut -d':' -f2)
    		if [ -z "$service" ]; then
       			echo "No service found with alias '$alias'."
        	exit 1
    		fi
    		local pid=$(pgrep -f "$service")
    		if [ -z "$pid" ]; then
        		echo "No running service found with alias '$alias'."
    		else
    		        echo "ALIAS PID   STAT PRI  NI CMD"
        		ps -p "$pid" -o "pid,stat,priority,nice,cmd" --no-headers | sed "s/^/$alias /"
    		fi
   		;;
    esac
}

if [ "$1" == "-o" ]; then
    process_manager "$2" "${@:3}"
else
    echo "Invalid operation: use -o "
    exit 1
fi

