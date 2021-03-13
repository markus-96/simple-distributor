#!/bin/bash
LOG=/run/user/$(id -u $USER)/hold_bounce.log
if [ -f $LOG ]; then
    echo "New Logfle created"
    else
        touch /run/user/$(id -u $USER)/hold_bounce.log
fi
startsoll=$(echo start)
startist=$(cat $LOG | head -n 1)
if [ "$startsoll" != "$startist" ]; then
    sed -i '1s/^/start\n/gm' $LOG
    x=$(cat $LOG)
    if [ -z "$x" ]; then
        echo start >> $LOG
    fi
fi

while true; do
    sh test.sh &
    echo ich lebe..
    sleep 5;
done
