#!/bin/bash

function newVhost(){
    echo "$1"
}

function deleteVhost(){
    echo "$1"
}

function listVhost(){
    var=$(ls /etc/apache2/sites-available/ | grep ^000 | grep -v \\.save$ | sed -e 's/000-\(.*\)\.conf/\1/')
    for i in var; do
        echo "$1"
    done
}

listVhost
