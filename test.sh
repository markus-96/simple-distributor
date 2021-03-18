#!/bin/bash
LOG=/run/user/$(id -u $USER)/hold_bounce.log

#   COUNT1 ist die aktuellste Zeile in mailq. Das anschließende "echo ist 
#   notwendig, da ansonsten die Formatierung anders ist als in der Logdatei.
COUNT=$(mailq |  grep "^[A-F0-9]" | grep -I "\!" | sort -k5n -k6 | tail -n 1)
COUNT=$(echo $COUNT)

var=$(cat $LOG | tail -n 1)

num=$(wc -l $LOG | awk '{ print $1 }')
if [ "$num" -eq 1 ]; then
    OLD=$COUNT
    #   wir brauchen die temp1.log, weil sonst "wc -l" nicht funktioniert..
    mailq | grep "^[A-F0-9]" | grep -I "\!" | sort -k5n -k6 > temp1.log
    #   da anscheinend die Logdatei leer ist und dieses Skript das erste Mal
    #   läuft, wird die erstmal geschrieben
    ja2=$(wc -l temp1.log | awk '{ print $1 }')
    z=$(echo 1)
    while [ "$z" -le "$ja2" ]; do
        y=$(($ja2 - $z + 1))
        a=$(cat temp1.log | tail -n $y | head -n 1)
        echo $a >> $LOG
        z=$(( z + 1 ))
    done
    rm temp1.log
    else
        OLD=$var
fi



#!!!!!!!!!!
#!!!!!!!!!! hier muss noch anhand der Uhrzeit gecheckt werden, ob nicht einfach eine released wurde. Dann sollte das funzen!
#!!!!!!!!!!
if [ "$OLD" != "$COUNT" ]; then
    echo $COUNT >> $LOG
    echo ich bin böse
fi
