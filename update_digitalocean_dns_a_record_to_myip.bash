#! /bin/bash  
SCRIPT="${BASH_SOURCE[0]}"
SCRIPT_DIR=${SCRIPT%/*}

DIGITALOCEAN_DOMAIN=$1
IP=`curl -4 icanhazip.com 2> /dev/null` 

# thank you for regular expression to : https://tecadmin.net/shell-script-validate-ipv4-addresses/
if [[ $IP =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
    $SCRIPT_DIR/update_digitalocean_dns_a_record.bash $DIGITALOCEAN_DOMAIN $IP
fi



