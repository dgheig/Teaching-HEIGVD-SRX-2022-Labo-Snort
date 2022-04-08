#!/bin/bash

docker exec -i Client /bin/bash <<- EOF
ip route del default
ip route add default via 192.168.220.2
ip route
EOF

docker exec -i firefox /bin/bash <<- EOF
ip route del default
ip route add default via 192.168.220.2
ip route
EOF

docker exec -i IDS /bin/bash <<- EOF
nft add table nat
nft 'add chain nat postrouting { type nat hook postrouting priority 100 ; }'
nft add rule nat postrouting meta oifname "eth0" masquerade
nft list ruleset
EOF

docker exec -i IDS /bin/bash <<- EOF
apt update && apt install -y snort
snort --help
EOF

## Essayer Snort


docker exec -i IDS /bin/bash <<- EOF
snort -v -i eth0
EOF


docker exec -i IDS /bin/bash <<- EOF
echo 'include /etc/snort/rules/icmp2.rules' > '/etc/snort/mysnort.conf'
echo 'alert icmp any any -> any any (msg:"ICMP Packet"; sid:4000001; rev:3;)' > '/etc/snort/rules/icmp2.rules'
EOF

docker exec -i IDS /bin/bash <<- EOF
snort -c /etc/snort/mysnort.conf
EOF

# From another terminal
# docker exec -i Client ping IDS


# docker exec -i IDS /bin/bash & <<- EOF
# timeout -k 5 30 snort -c /etc/snort/mysnort.conf
# EOF
# sleep 2
# docker exec -i Client ping -c 5 IDS

docker exec -i IDS cat /var/log/snort/alert