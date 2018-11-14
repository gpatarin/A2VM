#!/bin/bash
N_SITES=0

function newVhost(){
    echo "$1"
}

function deleteVhost(){
    listVhost
    selection=-1
    while ((selection<0 || selection>N_SITES || selection==0))
    do
        read -p "Select the site you want to delete (type exit if you want to go back): " selection
        if ((selection=="exit"))
        then 
            break
        fi
    done

}

function listVhost(){
    clear
    var=$(ls /etc/apache2/sites-available/ | grep ^000 | grep -v \\.save$ | sed -e 's/000-\(.*\)\.conf/\1/')
    echo "List of available sites"
    echo "======================="
    count=0
    for i in $var; do
        count=$((count+1))
        echo "$count:$i"
    done
    N_SITES=$count
    echo "======================="
}

listVhost
deleteVhost