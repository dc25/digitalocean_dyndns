#! /bin/bash  

# set an A record but first check to make sure we didn't just do this.

DIGITALOCEAN_DOMAIN=$1
IP=$2

SCRIPT="${BASH_SOURCE[0]}"
SCRIPT_DIR=${SCRIPT%/*}
SCRIPT_NAME=${SCRIPT##*/}

REPEAT_CHECK_DIR=$HOME/repeat_check
REPEAT_CHECK=$REPEAT_CHECK_DIR/$SCRIPT_NAME # file to save argument in if successful

# exit if previous successful call was with same argument
if [[ -e $REPEAT_CHECK ]]; then
    PREVIOUS_ARGUMENTS=`cat $REPEAT_CHECK`
    if [[ "$*" ==  "$PREVIOUS_ARGUMENTS" ]]; then
        echo previous call to $SCRIPT was also with arguments: \"$*\"  so exiting now to avoid duplicate work.
        exit
    fi
fi

if $SCRIPT_DIR/set_digitalocean_dns_a_record.bash $@; then
    # if successful then save arguments.
    echo call to $SCRIPT worked so saving arguments \"$*\" in $REPEAT_CHECK
    mkdir -p $REPEAT_CHECK_DIR
    echo "$*" > $REPEAT_CHECK
fi

