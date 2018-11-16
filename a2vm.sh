#!/bin/bash

apache2_sites_enabled='/etc/apache2/sites-enabled'
apache2_sites_available='/etc/apache2/sites-available'
documentroot_default='/var/www'
default_reply_yes='Y'
default_reply_no='N'
hostname=$(hostname)
default_errorlog_folder='${APACHE_LOG_DIR}/error.log'
default_customlog_folder='${APACHE_LOG_DIR}/access.log'

function newVhost(){
    clear
    read -p "Enter the server name (Example: domain.com or subdomain.domain.com | Default: $hostname) : " servername
    servername=${servername:-$hostname}
    tempcheck=$(ls /etc/apache2/sites-available | grep -w "^${servername}.conf")
    if [[ ! -z $tempcheck ]]
    then
        echo "---------------------------------------------------------------------"
        echo "Warning : $servername.conf existing in ${apache2_sites_available}"
        echo "If you continue you will erase it"
        echo "---------------------------------------------------------------------"
    fi
    read -p "Where are the website files ? (Default will be : $documentroot_default/$servername) : " documentroot
    documentroot=${documentroot:-$documentroot_default/$servername}
    read -p "Do you want to specify a log folder ? (Y/N) (default: N) : " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        read -p "Enter the error log location ? (Default : $default_errorlog_folder) : " errorlog
        errorlog=${errorlog:-$default_errorlog_folder}
        read -p "Enter the custom log location ? (Default : $default_customlog_folder) : " customlog
        customlog=${customlog:-$default_customlog_folder}
    else
        errorlog=${default_errorlog_folder}
        customlog=${default_customlog_folder}
        echo "Setting error log to : $errorlog"
        echo "Setting custom log to : $customlog"
    fi

    echo "Writing to ${apache2_sites_available}/${servername}.conf"

    echo "#Generated using A2VM - http://github.com/gpatarin/A2VM
    <VirtualHost *:80>
        ServerName ${servername}
        DocumentRoot ${documentroot}
        ErrorLog  ${errorlog}
        CustomLog ${customlog} combined
    </VirtualHost>" > ${apache2_sites_available}/${servername}.conf

    read -p "Do you want to enable the VirtualHost ? (Y/N) (default: Y)" -n 1 -r
    REPLY=${REPLY:-$default_reply_yes}
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        a2ensite ${servername}
        apache2ctl restart
    else
        read -p "Don't worry you can do this later via the menu of the script!"
    fi

    # TODO : ADD HOSTS FILE SUPPORT --> cat /etc/hosts | GREP ${servername}
    echo "----------------------------------------------------------------------------------"
    echo "REMEMBER TO ADD A LINE IN YOUR /etc/hosts FILE IF ITS NOT ALREADY DONE"
    echo "IF YOU DONT KNOW WHAT IS THE /etc/hosts FILE IS, LOOK HERE : https://goo.gl/8j17rt"
    echo "----------------------------------------------------------------------------------"
    read -p "Everything should be ok now ! You can go to http://${servername} (Press ENTER to go to the main menu)"
}

function listavailableVhosts(){
    clear
    echo "Listing sites-available"
    availablevhosts=$(ls ${apache2_sites_available} | grep ".*\.conf$" | grep -v ssl)
    count=0
    for i in ${availablevhosts}; do
     echo "${count}. ${i}"
     ((count=count+1))
    done
}

function listenabledVhosts(){
    clear
    echo "Listing sites-enabled"
    enabledvhosts=$(ls ${apache2_sites_enabled} | grep ".*\.conf$")
    count=0
    for i in ${enabledvhosts}; do
     echo "${count}. ${i}"
     ((count=count+1))
    done
}

function deleteVhost(){
    clear
    echo "Here is the list of sites of the sites you can delete :"
    enabledvhosts=$(ls ${apache2_sites_available} | grep ".*\.conf$")
    count=0
    for i in ${enabledvhosts}; do
     echo "${count}. ${i}"
     ((count=count+1))
    done

}







