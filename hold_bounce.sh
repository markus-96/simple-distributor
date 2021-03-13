#!/bin/bash
LOG=/run/user/$(id -u $USER)/hold_bounce.log
sh log.sh &
sleep 5;
echo te

while inotifywait -e modify $LOG; do
    NEWENTRY=$(tail -n 1 $LOG)
    NEWID=$(echo $NEWENTRY | awk '{ print $1 }')
    SENDER=$(echo $NEWENTRY | awk '{ print $7 }')
    RECIPIENT1=$(mailq | grep -n $NEWID | awk -F: '{ print $1; }')
    RECIPIENT2=$((($RECIPIENT1)+1))
    RECIPIENT=$(mailq | head -n $RECIPIENT2 | tail -n 1 | awk '{ print $1 }')
    
    MAILTEXT=$(echo "Sie haben eine Mail an $RECIPIENT geschrieben. Die Mail hat folgende ID: $NEWID und muss vom Administrator freigegeben werden.")
    SUBJECT=$(echo "E-Mail muss freigegeben werden!")
	sendbounce () {
        RECIPIENT=$1
   
        case $RECIPIENT in
        username1@domain.net)
            echo $MAILTEXT | mail -s $SUBJECT $SENDER
            ;;
        username2@domain.net)
            echo $MAILTEXT | mail -s $SUBJECT $SENDER
            ;;
        username3@domain.net)
            echo $MAILTEXT | mail -s $SUBJECT $SENDER
            ;;
        esac
        echo sollte geklappt haben
    }   
    sendbounce $RECIPIENT
	echo sendbpunce 
done
