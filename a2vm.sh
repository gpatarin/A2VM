#!/bin/bash
N_SITES=0
SITES_AVAILABLE=$(ls /etc/apache2/sites-available/ | grep ^000 | grep -v \\.save$ | sed -e 's/000-\(.*\)\.conf/\1/')

function newVhost(){
    echo "$1"
}

function deleteVhost(){
    listVhost
    selection=-1
    while [[ selection -lt 0 ]] || [[ selection -gt N_SITES ]] || [[ selection -eq 0 ]]
    do
        read -p "Select the site you want to delete (type exit if you want to go back): " selection
        if [[ selection -eq "exit" ]];then
            break
        fi
    done

}

function listVhost(){
    clear
    echo "List of available sites apache"
    echo "==============================="
    count=0
    for i in ${SITES_AVAILABLE}; do
        count=$((count+1))
        echo "$count:$i"
    done
    N_SITES=${count}
    echo "==============================="
}

listVhost
deleteVhost