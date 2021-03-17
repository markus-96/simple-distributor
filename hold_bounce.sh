#!/bin/bash
LOG=/run/user/$(id -u $USER)/hold_bounce.log

#
#   Zunächst wird das Skript zum erstellen des Logs aufgerufen und erstmal 
#   5 Sekunden gewartet
#
sh log.sh &
sleep 5;

while inotifywait -e modify $LOG; do

    #   Verändert sich was im Log, wird folgendes ausgeführt:
    NEWENTRY=$(tail -n 1 $LOG)
    NEWID=$(echo $NEWENTRY | awk '{ print $1 }')
    SENDER=$(echo $NEWENTRY | awk '{ print $7 }')
    
    #   In mailq steht der Empfänger in der Zeile unter der ID. RECIPIENT1 und 
    #   RECIPIENT2 sind nur Hilfsvariablen.
    RECIPIENT1=$(mailq | grep -n $NEWID | awk -F: '{ print $1; }')
    RECIPIENT2=$((($RECIPIENT1)+1))
    RECIPIENT=$(mailq | head -n $RECIPIENT2 | tail -n 1 | awk '{ print $1 }')
    
    ##
    ##   Hier wird angegeben, welcher Text genau verschickt wird. SUBJECT gibt 
    ##   den Betreff an.
    ##
    MAILTEXT=$(echo -e "Dies ist eine automaitisch generierete Mail.\n\nSie haben eine Mail an $RECIPIENT geschrieben. Es handelt sich hierbei um einen Mailverteiler.\nDie Mail hat folgende ID: $NEWID und muss vom Administrator freigegeben werden, nachdem die Mail gesichtet wurde.\n\nFreundliche Grüße")
    SUBJECT=$(echo "[ T39 ] E-Mail an $RECIPIENT muss freigegeben werden!")
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
