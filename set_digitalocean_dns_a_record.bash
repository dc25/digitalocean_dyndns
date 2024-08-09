#! /bin/bash 
SCRIPT="${BASH_SOURCE[0]}"
SCRIPT_DIR=${SCRIPT%/*}

DIGITALOCEAN_DOMAIN=$1
IP=$2

DIGITALOCEAN_TOKEN=`cat $SCRIPT_DIR/DO_TOKEN`

get_a_record_ids() {
    curl -X GET \
      -H "Content-Type: application/json" \
      -H "Authorization: Bearer $DIGITALOCEAN_TOKEN" \
      "https://api.digitalocean.com/v2/domains/$DIGITALOCEAN_DOMAIN/records" 2> /dev/null | jq '.domain_records |  map(select(.type == "A" and .name == "@")) | map(.id) | .[]'
}

add_a_record() {
    echo adding new A record for $DIGITALOCEAN_DOMAIN with value : $IP
    curl -X POST \
      -H "Content-Type: application/json" \
      -H "Authorization: Bearer $DIGITALOCEAN_TOKEN" \
      -d "{\"type\":\"A\"         \
          ,\"name\":\"@\"         \
          ,\"data\":\"$IP\"       \
          ,\"priority\":null      \
          ,\"port\":null          \
          ,\"ttl\":1800           \
          ,\"weight\":null        \
          ,\"flags\":null         \
          ,\"tag\":null           \
          }"                      \
      "https://api.digitalocean.com/v2/domains/$DIGITALOCEAN_DOMAIN/records" > /dev/null 2>&1
}

delete_record_by_id() {
    echo deleting existing A record for $DIGITALOCEAN_DOMAIN
    curl -X DELETE \
      -H "Content-Type: application/json" \
      -H "Authorization: Bearer $DIGITALOCEAN_TOKEN" \
      "https://api.digitalocean.com/v2/domains/$DIGITALOCEAN_DOMAIN/records/$1" > /dev/null 2>&1
}

for s in `get_a_record_ids`; do
    delete_record_by_id $s
done

add_a_record
