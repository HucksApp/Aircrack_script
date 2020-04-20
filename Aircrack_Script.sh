#! /bin/bash +x
clear
echo $'\e[32m \e[1m '"IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII"
echo "IIIIIIIIIIIIIIIIIIIIIhhHHHHHHHHHh    hhhh    hh   hhhhhhhh   hhhh        hh    hhhh   hh         hhhhhhhhhhhhhhIIIIIIIIIIIIIIII"
echo "IIIIIIIIIIIIIIIIIIIIIhhHHHHHHHHHh    hhhh    hh   hhhhhhhh   hhh  hhhhh  hh    hhhh   hh    hh   hhhhhhhhhhhhhhIIIIIIIIIIIIIIII"
echo "IIIIIIIIIIIIIIIIIIIIIhhHHHHHHHHHh    hhhh    hh   hhhhhhhh   hh   hhhhhhhhh    hhhh   hh    hhhhhhhhhhhhhhhhhhhIIIIIIIIIIIIIIII"
echo "IIIIIIIIIIIIIIIIIIIIIhhHHHHHHHHHh    hhhh    hh   hhhhhhhh   hh   hhhhhhhhh           hh    hhhhhhhhhhhhhhhhhhhIIIIIIIIIIIIIIII"
echo "IIIIIIIIIIIIIIIIIIIIIhhHHHHHHHHHh            hh   hhhhhhhh   hh   hhhhhhhhh    hhhhhhhhh    hhhhhhhhhhhhhhhhhhhIIIIIIIIIIIIIIII"
echo "IIIIIIIIIIIIIIIIIIIIIhhHHHHHHHHHh            hh   hhhhhhhh   hh   hhhhhhhhh    hhhhhhhhhh        hhhhhhhhhhhhhhIIIIIIIIIIIIIIII"
echo "IIIIIIIIIIIIIIIIIIIIIhhHHHHHHHHHh    hhhh    hh   hhhhhhhh   hh   hhhhhhhhh           hhhhhhh    hhhhhhhhhhhhhhIIIIIIIIIIIIIIII"
echo "IIIIIIIIIIIIIIIIIIIIIhhHHHHHHHHHh    hhhh    hh   hhhhhhhh   hh   hhhhhhhhh    hhhh   hh   hh    hhhhhhhhhhhhhhIIIIIIIIIIIIIIII"
echo "IIIIIIIIIIIIIIIIIIIIIhhHHHHHHHHHh    hhhh    hh   hhhhhhhh   hh   hhhhh  hh    hhhh   hh   hh    hhhhhhhhhhhhhhIIIIIIIIIIIIIIII"
echo "IIIIIIIIIIIIIIIIIIIIIhhHHHHHHHHHh    hhhh    hh              hhh         hh    hhhh   hh         hhhhhhhhhhhhhhIIIIIIIIIIIIIIII"
echo "IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII"
echo $'\e[34m'
echo "                                      +-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+-+"
echo "                                      |A|i|r|c|r|a|c|k| |A|u|t|o|m|a|t|e|d|"
echo "                                      +-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+-+"




# CREATE ALTERNATIVE TO CHANGE MAC ADDRESS ->> ETHER

set_alt () {
    
    echo $'\e[36m \e[49m Using Do You Wish To Change The Mac-Address of Your Interface'
    echo 'To Be Completely Undectectable'
    
    select option in 'Yes' 'No'
    do
        case $option in
            
            'No')
                echo $'\e[34m Using The Original Mac_Address of interface >>>>>>>>>'
            break;;
            
            'Yes')
                read -p  $'\e[34m Enter Ghost Mac-address In Format FF:FF:FF:FF:FF:FF: ' ghost_mac
                echo $password | sudo -S ifconfig $interface down
                ifconfig $interface hw ether $ghost_mac
                sleep 4
                ifconfig $interface up
            break;;
        esac
    done
    
}



# TAKE DOWN THE PASSWORD IF ADMIN PREVILEDGE IS NOT ENABLED

set_password(){
    echo $"DO YOU HAVE ADMIN PREVILEDGE, You Do Not Need Sudo To Initiate Aircrack-ng"
    select option in 'Yes' 'No'
    do
        case $option in
            'No')
                read -s -p $'\e[101m \e[97m Enter Password: ' password
            break;;
            'Yes')
                echo $'\e[97m => Option1 Saved'
            break;;
            *)
            echo $'\e[101m \e[97m No Not A Valid Option';;
        esac
    done
    
}


# NAME ALL THE FILES TO BE SORTED INTO

write_options(){
    echo -e $'\e[35m ' "WHAT WOULD YOU LIKE TO NAME THE OUTPUT APS FILE: \c"
    read aps_file
    
    echo -e $'\e[35m ' "WHAT WOULD YOU LIKE TO NAME THE OUTPUT STATIONS FILE: \c"
    read station_file
    
    read -p $'\e[33m Enter Interface Name: ' interface
}


# DRIVE AIRMON-NG TO START INTERFACE IN MONITOR MODE

airmon_handler () {
    echo $password | sudo -S ifconfig $interface down
    sudo airmon-ng check kill
    sudo airmon-ng start $interface
}



# DRIVE AIRODUMP-NG TO START CAPTURE AND WRITE IN SET INTERVAL

airodump_handler () {
    read -p $'Enter Monitor Mode Interface: ' mon ;
    read -p $'Enter Targeted BSSID: ' bid;
    read -p $'Enter Channel Of Target'chnl;
    
    sudo airodump-ng --bssid $bid --channel $chnl --write-interval 7 capt $mon
    
    if [ -f capt ] # CHECH IF THE FILE HAS BEEN CREATED I.E THE FIRST INTERVAL CAPTURE IS WRITTEN
    then
        cat capt | while read line
        do
            echo $line
        done
    else
        sleep 6
        con=true
        until [ con -eq false ]
        do
            if [ -f capt ]
            then
                cat capt | while read line
                do
                    echo $line
                    sleep 4
                done
            fi
        done
    fi
    
    echo "Here Now"
    
    
    
}






select is_mon in 'Yes' 'No' # CHECK TO SEE IF ITS BEEN INITIATED BEFORE
do
    if [$is_mon -eq yes ]
    then
        break
    else
        write_options
    fi
done

set_password
set_alt
airmon_handler
airodump_handler






