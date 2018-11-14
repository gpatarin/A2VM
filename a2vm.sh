#!/bin/bash

function newVhost(){

}

function deleteVhost(){
    
}

function listVhost(){
    var=$(ls /etc/apache2/sites-available/ | grep ^000 | grep -v \\.save$ | sed -e 's/000-\(.*\)\.conf/\1/')
    for i in var; do
        echo "$1"
    done
}

listVhost
