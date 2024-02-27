#!/bin/bash

# Skapa en grupp för SSH-åtkomst
groupadd sshusers
echo "Gruppen 'sshusers' har skapats för SSH-åtkomst."

# Skapa en katalog för SSH-nycklar
mkdir /root/.ssh
chmod 700 /root/.ssh
echo "Katalogen '/root/.ssh' : tar nyckeln ifrån << id_rsa.pub >> och ge den till Adam  "

# Skapa SSH-nycklar för root-användaren
ssh-keygen -t rsa -b 4096 -f /root/.ssh/id_rsa -N ""
echo "SSH-nycklarna har skapats för root-användaren."

# Ändra rättigheterna för sudoers-filen
chmod 440 /etc/sudoers
echo "Rättigheterna för /etc/sudoers har ändrats."

# Uppdatera systemet
apt update && apt upgrade -y

# Installera fail2ban och logrotate för logganalys
apt install -y fail2ban logrotate

# Konfigurera fail2ban
cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
echo "
[sshd]
enabled = true
port = ssh
filter = sshd
logpath = /var/log/auth.log
maxretry = 5" >> /etc/fail2ban/jail.local

# Starta om fail2ban för att tillämpa ändringarna
service fail2ban restart

# Konfigurera logrotate för att rotera fail2ban-loggar
echo "/var/log/fail2ban.log {
    weekly
    missingok
    rotate 4
    compress
    delaycompress
    notifempty
}" >> /etc/logrotate.d/fail2ban

# Starta om logrotate för att tillämpa ändringarna
service logrotate restart

echo "Fail2ban har konfigurerats för att övervaka SSH-loggar och blockera misstänkta IP-adresser. Loggrotation har konfigurerats för fail2ban-loggar."
