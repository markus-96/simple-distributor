#!/bin/bash
LOG=/run/user/$(id -u $USER)/hold_bounce.log

#
#   Zunächst wird das Skript zum erstellen des Logs aufgerufen und erstmal 
#   5 Sekunden gewartet
#
sh log.sh &
sleep 5;

#
#   Hier muss vmaildbpass entsprechend eurem Passwort für den Datenbankbenutzer
#   vmail angepasst werden:
#
user=$(echo vmail)
password=$(echo vmaildbpass)
hosts=$(echo "unix:/run/mysqld/mysqld.sock")
dbname=$(echo vmail)
query=$(echo "select distinct concat(destination_username, '@', destination_domain) as PROTECTED from hold where hold = true")

while inotifywait -e modify $LOG; do

    #   Verändert sich was im Log, wird folgendes ausgeführt:
    NEWENTRY=$(tail -n 1 $LOG)
    NEWID=$(echo $NEWENTRY | awk '{ print $1 }')
    
    #!!!!!!!!!!
    #!!!!!!!!!! Die Variable SENDER funktioniert noch nicht zuverlässig! Die muss man wohl
    #!!!!!!!!!! aus dem postfix-log extrahieren
    #!!!!!!!!!! 
    
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
    #   die Datenbankabfrage, die alle durch die Tabelle hold geschützten 
    #   Adressen ausgibt, wird an die "while"-Funktion weitergeleitet.
    #   Stimmt die Adresse der angekommenden Mail mit einer geschützten Adresse
    #   überein, wird eine Bounce-Mail versendet!
    echo $query | mysql -u$user -p$password -D$dbname |
    while IFS='\n' read PROTECTED; do
        if [ "$PROTECTED" = "$RECIPIENT" ]
            echo $MAILTEXT | mail -s $SUBJECT $SENDER
        fi
    done
	echo sendbpunce 
done
