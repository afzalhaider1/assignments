#!/bin/bash

file="/home/afzal/ssh-assignment/test/ssh_file.txt"

add_ssh() {
    if grep -q "^$name:" "$file"; then
    echo "'$name' already exists."
    else
    echo "$name: ssh $port $pem_file $user@$host" >> "$file"
    echo "Added SSH connection '$name'."
    fi
}

list_ssh() {
        if [ -s "$file" ]; then
        if [ "$1" = true ]; then
            cat "$file"
        else
            awk '{print $1}' $file
        fi
    else
        echo "No SSH connections found."
    fi
}

upt_ssh() {
    if grep -q "^$name:" "$file"; then
        sed -i "s|^$name:.*$|$name: ssh $port $pem_file $user@$host|" "$file"
        echo "Updated SSH connection '$name'."
    else
        echo "Connection '$name' not found."
    fi

}

del_ssh() {
    if [ -z "$server_name" ]; then
        echo "Error: server name is required for delete operation."
        exit 1
    fi

    if grep -q "^$server_name:" "$file"; then
        sed -i "/^$server_name:/d" "$file"
        echo "Deleted SSH connection '$server_name'."
    else
        echo "Connection '$server_name' not found."
    fi
}

conn_ssh() {
 local server=$1
    if grep -q "^$server:" "$file"; then
       ssh_info=$(grep "^$server:" $file | awk '{$1=""; $2=""; sub("  ", " "); print $0}')
       read -r _ port _ pem user <<< "$ssh_info"
        echo "Connecting to $server on $port port as ${user%%@*} via $pem"
       ssh $ssh_info
    else
        echo "[ERROR]: Server information is not available, please add the server first."
    fi
}

while getopts ":an:h:u:p:i:r:ldm" opt; do
    case $opt in
        a) add_connection=true ;;
        n) name=$OPTARG ;;
        h) host=$OPTARG ;;
        u) user=$OPTARG ;;
        p) port=$OPTARG ;;
        i) pem_file=$OPTARG ;;
        r) delete_ssh=true; server_name=$OPTARG ;;
        l) list_connection=true ;;
        d) list_details=true ;;
	m) update_ssh=true ;;
        ?) echo "Invalid option: " ;;
    esac
done

if [ "$add_connection" = true ]; then
    if [ -z "$name" ] || [ -z "$host" ] || [ -z "$user" ]; then
        echo "Error: -n, -h, and -u options are required."
     exit 1
    fi

    if [ -z "$port" ]; then
	    port=''
	else port="-p $port"
    fi

    if [ -z "$pem_file" ]; then
            pem_file=''
	else pem_file="-i $pem_file"
    fi

    add_ssh
fi

if [ "$list_connection" = true ] || [ "$list_details" = true ]; then
    list_ssh "$list_details"
fi

if [ "$update_ssh" = true ]; then
    if [ -z "$name" ] || [ -z "$host" ] || [ -z "$user" ]; then
        echo "Error: -n, -h, and -u options are required."
        exit 1
    fi

     if [ -z "$port" ]; then
            port=''
        else port="-p $port"
    fi
    
    if [ -z "$pem_file" ]; then
            pem_file=''
        else pem_file="-i $pem_file"
    fi
    upt_ssh
fi

if [ "$delete_ssh" = true ]; then
    del_ssh 
fi

if [ -z "$add_connection" ] && [ -z "$delete_ssh" ] && [ -z "$list_connection" ] && [ -z "$list_details" ] && [ -z "$update_ssh" ]; then
    conn_ssh "$1"
fi

