validate_ip() {
    local ip=$1

    if [[ $ip =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
        IFS='.' read -r -a octets <<< "$ip"
        
        for octet in "${octets[@]}"; do
            if (( octet > 255 )); then
                echo "Invalid IP address."
                exit 1
            fi
        done
        
        echo "Valid IP address."
    else
        echo "Invalid IP address."
        exit 1 
    fi
}

ip=$1
validate_ip "$ip"

