#!/bin/bash

#########################
#GLOBAL VARIABLES
ID_USER="XXXXXXX" # ID USER in TELEGRAM
TOKEN_BOT="XXXXXXX:XXXXXXXXXXXXXXXXXXXX" # TOKEN BOT in TELEGRAM

#LIST SERVICES [EDIT LIST, register your services]
SERVICES_LIST='
wg-crypt-wg0
openvpn
sshd
postgres
nginx
docker-proxy
fail2ban-server
node
'
#########################




SERVER=$(hostname -I | cut -f1 -d" ")
HOSTNAME=$(hostname)
NAME_SERVER="$HOSTNAME [$SERVER]
"
TOP_CPU="80"
TOP_MEMORY="80"
TOP_DISK="90"
TOP_BOOT="90"
TOP_LA="3"
TOP_INODES="90"
DISK=$(df / | grep / | awk '{ print $5}' | sed 's/%//g')
BOOT=$(df /boot | grep / | awk '{ print $5}' | sed 's/%//g')
INODES=$(df -i / | grep / | awk '{ print $5}' | sed 's/%//g')
CPU=$(grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {print usage ""}' | cut -f1 -d'.')
MEMORY=$(free -m | awk 'NR==2{printf "%s/%sMB %.2f\n", $3,$2,$3*100/$2 }' | cut -f2 -d" " | cut -f1 -d '.')
loadavg=`uptime | awk '{print $10+0}'`
thisloadavg=`echo $loadavg|awk -F \. '{print $1}'`
APT=$(apt update 2>/dev/null | tail -n1 | cut -f1 -d" ")


#CHECK SERVICES
for i in $SERVICES_LIST; do
ps cax | grep $i > /dev/null
if [ $? -eq 0 ]; then
  echo "[OK] - $i"
else
  echo "$NAME_SERVER - [WARNING] - $i"
curl -s -X POST "https://api.telegram.org/bot"$TOKEN_BOT"/sendMessage" -F chat_id=$ID_USER -F text="$NAME_SERVER $i DOWN!"
fi
done

#LOAD AVERAGE
if [ "$thisloadavg" -ge "$TOP_LA" ]; then
curl -s -X POST "https://api.telegram.org/bot"$TOKEN_BOT"/sendMessage" -F chat_id=$ID_USER -F text="$NAME_SERVER WARNING - Load Average $loadavg ($thisloadavg) "
else
echo "[OK] - Load Average $loadavg ($thisloadavg) "
fi

#DISK QUOTA
if [ "$DISK" -ge "$TOP_DISK" ]; then
curl -s -X POST "https://api.telegram.org/bot"$TOKEN_BOT"/sendMessage" -F chat_id=$ID_USER -F text="$NAME_SERVER WARNING - Disk quota is $DISK% full"
else
echo "[OK] - Disk quota"
fi

#DISK INODES
if [ "$INODES" -ge "$TOP_INODES" ]; then
curl -s -X POST "https://api.telegram.org/bot"$TOKEN_BOT"/sendMessage" -F chat_id=$ID_USER -F text="$NAME_SERVER WARNING - Disk inodes is $INODES% full"
else
echo "[OK] - Disk inodes"
fi

#CPU LOAD
if [ "$CPU" -ge "$TOP_CPU" ]; then
curl -s -X POST "https://api.telegram.org/bot"$TOKEN_BOT"/sendMessage" -F chat_id=$ID_USER -F text="$NAME_SERVER WARNING - CPU load $INODES%"
else
echo "[OK] - CPU load"
fi

#BOOT
if [ "$BOOT" -ge "$TOP_BOOT" ]; then
curl -s -X POST "https://api.telegram.org/bot"$TOKEN_BOT"/sendMessage" -F chat_id=$ID_USER -F text="$NAME_SERVER WARNING - BOOT is $INODES% full"
else
echo "[OK] - BOOT"
fi

#MEMORY
if [ "$MEMORY" -ge "$TOP_MEMORY" ]; then
curl -s -X POST "https://api.telegram.org/bot"$TOKEN_BOT"/sendMessage" -F chat_id=$ID_USER -F text="$NAME_SERVER WARNING - MEMORY load $INODES%"
else
echo "[OK] - Memory load"
fi

#CHECK UPDATES
if echo $APT | grep -v '^[0-9][0-9]*$' >/dev/null 2>&1 ; then
echo "[OK] - NO UPDATES"
else
curl -s -X POST "https://api.telegram.org/bot"$TOKEN_BOT"/sendMessage" -F chat_id=$ID_USER -F text="$NAME_SERVER WARNING - NEW UPDATES"
fi


sleep 20
