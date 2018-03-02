#!/bin/bash
clear

folm-cli stop

sleep 10

rm -rf ~/.folm/blocks
rm -rf ~/.folm/database
rm -rf ~/.folm/chainstate
rm -rf ~/.folm/peers.dat

cp ~/.folm/folm.conf ~/.folm/folm.conf.backup
sed -i '/^addnode/d' ~/.folm/folm.conf
cat <<EOL >>  ~/.folm/folm.conf

addnode=207.148.27.114:53656
addnode=47.93.62.127:53656
addnode=39.106.114.12:53656
addnode=45.32.41.90:53656
addnode=45.77.87.216:53656
addnode=52.59.131.102:53656
addnode=35.176.241.58:53656
addnode=35.173.42.127:53656
addnode=35.185.146.123:53656
addnode=47.93.253.248:53656
addnode=194.87.97.198:53656
addnode=18.194.114.24:53656
addnode=114.113.229.218:53656
addnode=146.66.182.66:53656
addnode=91.222.164.220:53656
addnode=62.63.84.28:53656
addnode=213.14.82.124:53656
addnode=13.81.9.14:53656
addnode=85.105.143.77:53656
addnode=46.164.163.207:53656
addnode=91.214.117.26:53656
addnode=31.148.21.122:53656
addnode=85.29.233.40:53656
addnode=45.77.229.2:53656
addnode=189.49.238.40:53656
addnode=46.242.45.200:53656
addnode=86.125.115.165:53656
addnode=82.77.149.113:53656
addnode=79.102.194.204:53656
addnode=213.14.82.125:53656
addnode=91.201.40.153:53656
EOL

folmd -daemon
