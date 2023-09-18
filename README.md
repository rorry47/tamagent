# tamagent

BASH monitoring server and alert in Telegram

---
**Install**

1. Create folder: 

```bash
mkdir /usr/local/tamagent
```

2. Create file tamagent.sh:
```bash
nano /usr/local/tamagent/tamagent.sh
```

3. Write the data from the repository to the file.

4. Fill in the following variables with your data:
```bash
#VARIABLES
ID_USER="XXXXXXX" # ID USER in TELEGRAM
TOKEN_BOT="XXXXXXX:XXXXXXXXXXXXXXXXXXXX" # TOKEN BOT in TELEGRAM

#LIST SERVICES []
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
```

5. Create service file:
```bash
nano /lib/systemd/system/tamagent.service
```

6. Write the data from the repository to the file.

7. Turn on the service:
```bash
systemctl daemon-reload
systemctl enable tamagent.service
systemctl start tamagent.service
```

Done!
