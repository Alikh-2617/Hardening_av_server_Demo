#!/bin/bash

# Uppdatera systemet
apt update && apt upgrade -y

# Installera saker
apt install -y ufw openssh-server fail2ban rsync wget git htop unzip nano vim bash-completion iftop sudo software-properties-common tcpdump curl apache2-utils 
echo "installation om vertyg som behövs är klar !"

# Konfigurera brandvägg för att tillåta endast HTTP, HTTPS och SSH
ufw default deny incoming
ufw default allow outgoing
ufw allow ssh
ufw allow http
ufw allow https
ufw --force enable
echo "installation om ufw är klar !"

# Konfigurera SSH för säker åtkomst
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config
echo "installation om SSH är klar ocg SSH kommer restarta !"
service ssh restart

# Installera säkerhetskopieringsverktyg
# Exempel: Rsync-kommando för att säkerhetskopiera /etc-katalogen till en annan plats
# Exempel: Använd gpg för att kryptera säkerhetskopian

apt install -y rsync
rsync -av /etc /säkerhetskopiering
gpg --output /säkerhetskopiering.tar.gz.gpg --symmetric /säkerhetskopiering.tar.gz
echo "säkerhetskopiera /etc-katalogen kommer krypteras till /säkerhetskopiering.tar.gz"


# Konfigurera fail2ban för att skydda mot brute-force attacker
cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
sed -i 's/bantime  = 10m/bantime  = 1h/' /etc/fail2ban/jail.local
echo "installation om fail2ban är klar path = /etc/fail2ban/jail.local !"
service fail2ban restart

# Avsluta scriptet
echo "Konfigurationen är klar. Endast portarna för HTTP, HTTPS och SSH är öppna och åtkomst till servern tillåts endast via SSH. Fail2ban har konfigurerats för att skydda mot brute-force attacker. Säkerhetskopiering har skapats och krypterats."
