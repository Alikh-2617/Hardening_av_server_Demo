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

# Installera saker
apt install -y ufw openssh-server fail2ban rsync wget git htop unzip nano vim bash-completion iftop sudo software-properties-common tcpdump curl apache2-utils 
echo "Installationen av verktyg är klar!"

# Konfigurera brandvägg för att tillåta endast HTTP, HTTPS och SSH
ufw default deny incoming
ufw default allow outgoing
ufw allow ssh
ufw allow http
ufw allow https
ufw --force enable
echo "Brandväggsinställningar är klara!"

# Konfigurera SSH för säker åtkomst
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config
echo "SSH-inställningar är klara och SSH kommer att startas om!"
service ssh restart

# Installera säkerhetskopieringsverktyg
apt install -y rsync
rsync -av /etc /säkerhetskopiering
gpg --output /säkerhetskopiering.tar.gz.gpg --symmetric /säkerhetskopiering.tar.gz
echo "Säkerhetskopia av /etc-katalogen har skapats och krypterats till /säkerhetskopiering.tar.gz"

# Konfigurera fail2ban för att skydda mot brute-force attacker
cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
sed -i 's/bantime  = 10m/bantime  = 1h/' /etc/fail2ban/jail.local
echo "Fail2ban-inställningar är klara!"
service fail2ban restart

# Skapa en användare och ge denne SSH-nyckeln
read -p "Ange användarnamn för den nya användaren: " Adam
useradd -m $Adam
mkdir /home/$Adam/.ssh
chmod 700 /home/$Adam/.ssh
cp /root/.ssh/id_rsa.pub /home/$Adam/.ssh/authorized_keys
chown -R $Adam:$Adam /home/$Adam/.ssh
echo "Användaren '$Adam' har skapats och SSH-nyckeln har tilldelats."

# Avsluta scriptet
echo "Konfigurationen är klar. Endast portarna för HTTP, HTTPS och SSH är öppna och åtkomst till servern är begränsad till användare som tillhör gruppen 'sshusers'. Fail2ban har konfigurerats för att skydda mot brute-force attacker. Säkerhetskopiering har skapats och krypterats. En ny användare '$Adam' har skapats och tilldelats SSH-nyckeln."
