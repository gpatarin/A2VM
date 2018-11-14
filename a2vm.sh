#!/bin/bash

function newVhost(){
    echo "$1"
}

function deleteVhost(){
    listVhost
    read -ep "Select the site you want to delete: " -i Default answer ANSWER
    echo "$ANSWER"
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
    echo "======================="
}

listVhost
deleteVhost