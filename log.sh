#!/bin/bash
LOG=/run/user/$(id -u $USER)/hold_bounce.log

#
#   Es wird die Logdatei erstellt und am Anfang soll "start" stehen (Sonst 
#   funktioniert "wc -l" nicht.)
#
if [ -f $LOG ]; then
    startsoll=$(echo start)
    startist=$(cat $LOG | head -n 1)
    if [ "$startsoll" != "$startist" ]; then
        sed -i '1s/^/start\n/gm' $LOG
    fi
    else
        touch $LOG
        echo start >> $LOG
        echo "New Logfile created"

#
#   Es wird alle 5 Sekunden geprüft, ob neue Mails im Status "hold" sind.
#
while true; do
    sh test.sh &
    sleep 5;
done
