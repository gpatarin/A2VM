#!/bin/bash
documentroot_default='/var/www'
hostname=$(hostname)
default_errorlog_folder='\${APACHE_LOG_DIR}/error.log'
default_customlog_folder='\${APACHE_LOG_DIR}/access.log'

function newVhost(){
    clear
    read -p "Enter the server name (Example: domain.com or subdomain.domain.com | Default: $hostname) : " servername
    servername=${servername:-$hostname}
    tempcheck=$(ls /etc/apache2/sites-available | grep -w "^${servername}.conf")
    if [[ ! -z $tempcheck ]]
    then
        echo "---------------------------------------------------------------------"
        echo "Warning : $servername.conf existing in /etc/apache2/sites-available/"
        echo "If you continue you will erase it"
        echo "---------------------------------------------------------------------"
    fi
    read -p "Where are the website files ? (Default will be : $documentroot_default/$servername) : " documentroot
    documentroot=${documentroot:-$documentroot_default/$servername}
    read -p "Do you want to specify a log folder ? (Y/N) : " -n 1 -r
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

    echo "Writing to /etc/apache2/sites-available/${servername}.conf"

    echo "#Generated using A2VM - http://github.com/gpatarin/A2VM
    <VirtualHost *:80>
        ServerName ${servername}
        DocumentRoot ${documentroot}
        ErrorLog  \${APACHE_LOG_DIR}/error.log
        CustomLog \${APACHE_LOG_DIR}/access.log combined
    </VirtualHost>" > /etc/apache2/sites-available/${servername}.conf

}

newVhost
