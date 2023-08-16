#!/bin/sudo bash

create_user() {
    local server="$1"
    local username="$2"
    conn_ssh "$server" 
    useradd "$username"
}

conn_ssh() {
    local server="$1"
    if grep -q "^$server," "$inventory_file"; then
       ssh_info=$(grep "^$server," $inventory_file)
       IFS=',' read -r server user ip pem <<< "$ssh_info"
	ssh -n -i $pem "$user"@"$ip"
     else
        echo "[ERROR]: Server information is not available, please add the server first."
    fi
}

delete_user() {
    local server="$1"
    local username="$2"
    conn_ssh "$server" 
    userdel "$username"
}

modify_user() {
    
    local server="$1"
    local username="$4"
    local property="$2"
    local value="$3"
    case "$property" in
        group)
        	conn_ssh "$server"
            usermod -g "$value" "$username"
            ;;
        shell)
        	conn_ssh "$server"
           	usermod -s "$value" "$username"
            ;;
        *)
            echo "Invalid action: $property"
            exit 1
            ;;
    esac
}

create_group() {
    local server="$1"
    local groupname="$2"
    conn_ssh "$server"
    groupadd "$groupname"
}

delete_group() {
    local server="$1"
    local groupname="$2"
    conn_ssh "$server"
    groupdel "$groupname"
}

add_user_to_group() {
    local server="$1"
    local username="$2"
    local groupname="$3"
    conn_ssh "$server"
    usermod -g "$groupname" "$username"
}

install_package() {
    local server="$1"
    local package="$2"
    local os_type
    os_type=$(get_os_type "$server")
    case "$os_type" in
        debian)
            conn_ssh "$server"
            apt-get install -y "$package"
            ;;
        redhat)
            conn_ssh "$server"
            yum install -y "$package"
            ;;
        "rhel fedora")
            conn_ssh "$server"
            yum install -y "$package"
            ;;
        *)
            echo "Unsupported OS type: $os_type"
            exit 1
            ;;
    esac
}

uninstall_package() {
    local server="$1"
    local package="$2"
    local os_type
    os_type=$(get_os_type "$server")
    case "$os_type" in
        debian)
            conn_ssh "$server"
            apt-get remove -y "$package"
            apt-get -y autoremove
            ;;
        redhat)
            conn_ssh "$server"
            yum remove -y "$package"
            yum autoremove
            ;;
        "rhel fedora")
            conn_ssh "$server"
            yum remove -y "$package"
            yum autoremove
            ;;
        *)
            echo "Unsupported OS type: $os_type"
            exit 1
            ;;
    esac
}

update_packages() {
    local server="$1"
    local os_type
    os_type=$(get_os_type "$server")
    case "$os_type" in
        debian)
            conn_ssh "$server"
            apt-get update
            ;;
        redhat)
            conn_ssh "$server"
            yum update -y
            ;;
        "rhel fedora")
            conn_ssh "$server"
            yum update -y
            ;;
        *)
            echo "Unsupported OS type: $os_type"
            exit 1
            ;;
    esac
}

get_os_type() {
    local server="$1"
    local os_type
    if grep -q "^$server," "$inventory_file"; then
        ssh_info=$(grep "^$server," "$inventory_file")
        IFS=',' read -r server user ip pem<<< "$ssh_info"
        os_type=$(ssh -i $pem "$user"@"$ip" cat /etc/os-release | awk -F'=' '$1 == "ID_LIKE" {print $2}')
        echo "$os_type"
    else
        echo "[ERROR]: Server information is not available, please add the server first."
    fi
}

create_file() {
    local server="$1"
    local filepath="$2"
    conn_ssh "$server"
    touch "$filepath"
}

modify_file() {
    local server="$1"
    local filepath="$2"
    local content="$3"
    conn_ssh "$server"
    echo "$content" | cat >> "$filepath"
}

delete_file() {
    local server="$1"
    local filepath="$2"
    conn_ssh "$server"
    rm -rf "$filepath"
}

create_directory() {
    local server="$1"
    local dirpath="$2"
    conn_ssh "$server"
    mkdir -p "$dirpath"
}

delete_directory() {
    local server="$1"
    local dirpath="$2"
    conn_ssh "$server"
    sudo rm -rf "$dirpath"
}

copy_file() {
    local server="$1"
    local action="$2"
    local destination="$3"
    conn_ssh "$server"
    cp -r "$action" "$destination"
}

start_service() {
    local server="$1"
    local service_name="$2"
    conn_ssh "$server"
    systemctl start "$service_name"
}

stop_service() {
    local server="$1"
    local service_name="$2"
    conn_ssh "$server"
    systemctl stop "$service_name"
}

restart_service() {
    local server="$1"
    local service_name="$2"
    conn_ssh "$server"
    systemctl restart "$service_name"
}

reload_daemon() {
    local server="$1"
    conn_ssh "$server"
    systemctl daemon-reload
}

execute_tasks() {
    
    local inventory_file="$1"
    local task_file="$2"
    while IFS=, read -r server resource action rest; do
    
   	if [[ "$server" =~ ^\s*# ]]; then
            continue
        fi
        case "$resource" in
            user)
                case "$action" in
                    create)
                        create_user "$server" "$rest"
                        ;;
                    delete)
                        delete_user "$server" "$rest"
                        ;;
                    modify)
                        IFS=',' read -r property value username <<< "$rest"
                        modify_user "$server" "$property" "$value" "$username"
                        ;;
                esac
                ;;
            group)
                case "$action" in
                    create)
                        create_group "$server" "$rest"
                        ;;
                    delete)
                        delete_group "$server" "$rest"
                        ;;
                    user)
                    	IFS=',' read -r username groupname <<< "$rest"
                        add_user_to_group "$server" "$username" "$groupname"
                        ;;
                esac
                ;;
            file)
                case "$action" in
                    create)
                        create_file "$server" "$rest"
                        ;;
                    delete)
                        delete_file "$server" "$rest"
                        ;;
                    modify)
                    	IFS=',' read -r filepath content <<< "$rest" 
                        modify_file "$server" "$filepath" "$content"
                        ;;
                esac
                ;;
            directory)
                case "$action" in
                    create)
                        create_directory "$server" "$rest"
                        ;;
                    delete)
                        delete_directory "$server" "$rest"
                        ;;
                esac
                ;;
            copy)
                copy_file "$server" "$action" "$rest"
                ;;
            install)
                install_package "$server" "$action"
                ;;
            uninstall)
                uninstall_package "$server" "$action"
                ;;
            update)
                update_packages "$server"
                ;;
            service)
                IFS=',' read -r command <<< "$rest"
                if [[ $action == daemon-reload ]];then
                        reload_daemon "$server"
                fi
                case "$command" in
                    start)
                        start_service "$server" "$action"
                        ;;
                    stop)
                        stop_service "$server" "$action"
                        ;;
                    restart)
                        restart_service "$server" "$action"
                        ;;
                esac
                ;;
            *)
                echo "Invalid resource: $resource"
                exit 1
                ;;
        esac
    done < "$task_file"
}

# Main script starts here
while getopts ":i:t:" opt; do
    case "$opt" in
        i)
            inventory_file="$OPTARG"
            ;;
        t)
            task_file="$OPTARG"
            ;;
        *)
            echo "Invalid option: -$OPTARG" >&2
            exit 1
            ;;
    esac
done


if [ -z "$inventory_file" ] || [ -z "$task_file" ]; then
    echo "Invalid action: Use -i <inventory_file> -t <task_file>"
    exit 1
fi

if [ ! -f "$inventory_file" ]; then
    echo "Inventory file not found"
    exit 1
fi
if [ ! -f "$task_file" ]; then
    echo "Task file not found"
    exit 1
fi

execute_tasks "$inventory_file" "$task_file"
