#!/bin/bash

apache2_sites_enabled='/etc/apache2/sites-enabled'
apache2_sites_available='/etc/apache2/sites-available'
documentroot_default='/var/www'
default_reply_yes='Y'
default_reply_no='N'
default_errorlog_folder='${APACHE_LOG_DIR}/error.log'
default_customlog_folder='${APACHE_LOG_DIR}/access.log'

function newVhost(){
    clear
    read -p "Enter the server name (Example: domain.com or subdomain.domain.com | Default: $HOSTNAME) : " servername
    servername=${servername:-$HOSTNAME}
    tempcheck=$(ls /etc/apache2/sites-available | grep -w "^${servername}.conf")
    if [[ ! -z ${tempcheck} ]]
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
    errorlog=${default_errorlog_folder}
    customlog=${default_customlog_folder}
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        read -p "Enter the error log location ? (Default : $default_errorlog_folder) : " errorlog
        errorlog=${errorlog:-$default_errorlog_folder}
        read -p "Enter the custom log location ? (Default : $default_customlog_folder) : " customlog
        customlog=${customlog:-$default_customlog_folder}
    else
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
    PS3=""
    select userinput in ${availablevhosts};
    do
        break
    done
}

function listenabledVhosts(){
    clear
    echo "Listing sites-enabled"
    enabledvhosts=$(ls ${apache2_sites_enabled} | grep ".*\.conf$")
    PS3=""
    select userinput in ${enabledvhosts};
    do
        break
    done
}

function deleteVhost(){
    clear
    servername=""
    confirmation=''
    echo "Here is the list of sites of the sites you can delete"
    availablevhosts=$(ls ${apache2_sites_available} | grep ".*\.conf$" | grep -v ssl)
    PS3="Pick a site: "
    select userinput in ${availablevhosts};
    do
        if [[ ! -z ${userinput} ]]
        then
            read -p "Are you sure that you want to delete $userinput ? (Y/N) (default: N)" -n 1 confirmation
            echo
            confirmation=${confirmation:-$default_reply_no}
            if [[ ${confirmation} =~ ^[Yy]$ ]]
            then
                servername=${userinput}
                break
            fi
        fi
    done

    a2dissite ${servername}
    apache2ctl restart
    rm ${apache2_sites_available}/${servername}
    echo "Successfully removed $servername"
}

function enableVhost(){
    availablevhosts=$(ls ${apache2_sites_available} | grep ".*\.conf$" | grep -v ssl)
    enabledvhosts=$(ls ${apache2_sites_enabled} | grep ".*\.conf$")
    vhosttoenable=${availablevhosts//$enabledvhosts}
    select userinput in ${vhosttoenable};
    do
        if [[ ! -z ${userinput} ]]
        then
            a2ensite ${userinput}
            echo "Enabled site : ${userinput}"
            break
        fi
    done
}

function disableVhost(){
    enabledvhosts=$(ls ${apache2_sites_enabled} | grep ".*\.conf$")
    select userinput in ${enabledvhosts};
    do
        if [[ ! -z ${userinput} ]]
        then
            a2dissite ${userinput}
            echo "Disabled site : ${userinput}"
            break
        fi
    done
}




