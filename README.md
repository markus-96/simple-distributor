# simple-distributor
This is a simple bounce-generator for messages beeing set to status "hold" by postfix.
It also provides an option to set every message beeing sent to a certain mailadress
to status 'hold'

**be carefull! This is still an Alpha-state!!!**
The Bounce-Mail sometimes still gets send to the wrong address.

For configuration, use phpmyadmin.

Simply add the destination mailadresses to the aliases table with the source mailadresses.
If you want that every mail to a certain mailadress has to be released by the admin,
simply add it to the hold table!

If you want the sender to be notified that the mail is set to status "hold", add the
mailadress to the function sendbounce in hold_bounce.sh!

## Prerequisites
You must have a functional mailserver with the database model provided by[Thomas Leister](https://github.com/ThomasLeister) 
in his awesome mailserver tutorial:
[Mailserver mit Dovecot, Postfix, MySQL und Rspamd unter Debian 10 Buster [v1.0]](https://thomas-leister.de/mailserver-debian-buster/)

## Deployment
Since the script uses inotifywait, you have to install it first:
```bash
sudo apt install inotify-tools
```
### The scripts
Put them anywhere you want, for example in /etc/postfix/sql, but they have to be in the same directory! Than, add a
autostart-option. You have to write the vmail-databaseuser-password into the hold_bounce.sh-file.
Because of that, you have to protect it somehow, for example change the user and usergroup of the file to root:vmail and change read-write permissions to 440.

### The table 'hold'
Simply add the table ```hold.sql``` to the database ```vmail```. It is a simple dump made
by phpmyadmin.

### Modifications to 'main.cf'
The table has do readable by postfix. For this, edit the file ```main.cf``` to look like this:

near smtpd_recipient_restrictions:
```bash
smtpd_recipient_restrictions =  check_recipient_access proxy:mysql:/etc/postfix/sql/hold-access.cf
                                check_recipient_access proxy:mysql:/etc/postfix/sql/recipient-access.cf
```

near proxy_read_maps:
```bash
proxy_read_maps =       proxy:mysql:/etc/postfix/sql/aliases.cf
                        proxy:mysql:/etc/postfix/sql/accounts.cf
                        proxy:mysql:/etc/postfix/sql/domains.cf
                        proxy:mysql:/etc/postfix/sql/recipient-access.cf
                        proxy:mysql:/etc/postfix/sql/sender-login-maps.cf
                        proxy:mysql:/etc/postfix/sql/tls-policy.cf
                        proxy:mysql:/etc/postfix/sql/hold-access.cf
```

### The file ```hold-access.cf```
You have to put in ```/etc/postfix/sql/``` and you have to alter the password.

## releasing held mails
Review the queue by typing in the shell:
```bash
mailq
```
find the certain ID of the mail and copy it without the "!".
Then, for "unholding" it, type the following where ID is the ID of the mail:
```bash
sudo postsuper -H ID
```
If you do not want to wait, you can flush the queue:
```bash
sudo postqueue -f
```

## Only put them hold without notification and log
Proceed from step [The table 'hold'](#the-table-hold), don't use sripts!

