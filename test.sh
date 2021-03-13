#!/bin/bash
LOG=/run/user/$(id -u $USER)/hold_bounce.log
startsoll=$(echo start)
echo $LOG
    COUNT1=$(mailq |  grep "^[A-F0-9]" | grep -I "\!" | sort -k5n -k6 | tail -n 1)
    COUNT=$(echo $COUNT1)
    > temp.log
    echo $COUNT >> temp.log
    COUNT=$(cat temp.log | tail -n 1)
    if [ -z "$OLD" ]; then
        var=$(cat $LOG | tail -n 1)
        case "$var" in
            "$startsoll")
                echo "hat geklappt!"
                OLD=$COUNT
                echo $OLD
        esac
        num=$(wc -l $LOG | awk '{ print $1 }')
        if [ "$num" -eq 1 ]; then
            OLD=$COUNT
            mailq | grep "^[A-F0-9]" | grep -I "\!" | sort -k5n -k6 > temp1.log
            ja2=$(wc -l temp1.log | awk '{ print $1 }')
            echo $ja2
            z=$(echo 1)
            while [ "$z" -le "$ja2" ]; do
                echo hanlo
                > temp.log
                y=$(($ja2 - $z + 1))
                a=$(cat temp1.log | tail -n $y | head -n 1)
                echo $a >> $LOG
                z=$(( z + 1 ))
            done
            #"$ja1" | cat >> temp.log
            echo 3
            else
                OLD=$var
                
                echo 1
        fi
        else
            OLD=$var
            echo 2
    fi
    if [ "$OLD" != "$COUNT" ]; then
        if [ -z "$OLD" ]; then
        echo
        else
            echo $COUNT >> $LOG
            echo ich bin böse        
        fi
    fi
    echo ich auch--

