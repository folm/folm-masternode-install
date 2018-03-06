#!/bin/bash
clear

STRING1="Make sure you double check before hitting enter! Only one shot at these!"
STRING2="If you found this helpful, please donate to FLM Donation: "
STRING3="FWvWWY86dgor48Zf6sBiEFkKLSJdN3K5Th"
STRING4="Updating system and installing required packages."
STRING5="Switching to Aptitude"
STRING6="Some optional installs"
STRING7="Starting your masternode"
STRING8="Now, you need to finally start your masternode in the following order:"
STRING9="Go to your windows wallet and from the Control wallet debug console please enter"
STRING10="startmasternode alias false <mymnalias>"
STRING11="where <mymnalias> is the name of your masternode alias (without brackets)"
STRING12="once completed please return to VPS and press the space bar"
STRING13=""
STRING14="Please Wait a minimum of 5 minutes before proceeding, the node wallet must be synced"

echo $STRING1

read -e -p "Server IP Address : " ip
read -e -p "Masternode Private Key (e.g. 6zZnaSksyXEZTxwzwG1xed8thKBvpgE2LqUmcUwa3E9ELiDYedM # THE KEY YOU GENERATED EARLIER) : " key
read -e -p "Install Fail2ban? [Y/n] : " install_fail2ban
read -e -p "Install UFW and configure ports? [Y/n] : " UFW

clear
echo $STRING2
echo $STRING13
echo $STRING3
echo $STRING13
echo $STRING4
sleep 10

# update package and upgrade Ubuntu
sudo apt-get -y update
sudo apt-get -y upgrade
sudo apt-get -y autoremove
sudo apt-get install wget nano htop -y
sudo apt-get install build-essential && sudo apt-get install libtool autotools-dev autoconf automake && sudo apt-get install libssl-dev && sudo apt-get install libboost-all-dev && sudo apt install software-properties-common && sudo add-apt-repository ppa:bitcoin/bitcoin && sudo apt update && sudo apt-get install libdb4.8-dev && sudo apt-get install libdb4.8++-dev && sudo apt-get install libminiupnpc-dev && sudo apt-get install libqt4-dev libprotobuf-dev protobuf-compiler && sudo apt-get install libqrencode-dev && sudo apt-get install -y git && sudo apt-get install pkg-config
sudo apt-get -y install libzmq3-dev
clear
echo $STRING5
sudo apt-get -y install aptitude

#Generating Random Passwords
user=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
password=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)

echo $STRING6
if [[ ("$install_fail2ban" == "y" || "$install_fail2ban" == "Y" || "$install_fail2ban" == "") ]]; then
  cd ~
  sudo aptitude -y install fail2ban
  sudo service fail2ban restart
fi
if [[ ("$UFW" == "y" || "$UFW" == "Y" || "$UFW" == "") ]]; then
  sudo apt-get install ufw
  sudo ufw default deny incoming
  sudo ufw default allow outgoing
  sudo ufw allow ssh
  sudo ufw allow 52543/tcp
  sudo ufw enable -y
fi

#Install Folm Daemon
wget https://github.com/folm/folm/releases/download/v3.1.2/folm-3.1.2.ubuntu.16.04.zip
sudo unzip folm-3.1.2.ubuntu.16.04.zip
sudo rm folm
sudo cp ~/folm/folmd /usr/bin
sudo cp ~/folm/folmd /usr/bin
sudo cp ~/folm-masternode-install/folm/folmd /usr/bin
sudo cp ~/folm-masternode-install/folm/folm-cli /usr/bin
folmd -daemon
clear

#Setting up coin
clear
echo $STRING2
echo $STRING13
echo $STRING3
echo $STRING13
echo $STRING4
sleep 10

#Create folm.conf
echo '
rpcuser='$user'
rpcpassword='$password'
rpcallowip=127.0.0.1
listen=1
server=1
daemon=1
logtimestamps=1
maxconnections=256
externalip='$ip'
bind='$ip':52543
masternodeaddr='$ip'
masternodeprivkey='$key'
masternode=1
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

' | sudo -E tee ~/.folm/folm.conf >/dev/null 2>&1
sudo chmod 0600 ~/.folm/folm.conf

#Starting coin
(
  crontab -l 2>/dev/null
  echo '@reboot sleep 30 && folmd -daemon -shrinkdebugfile'
) | crontab
(
  crontab -l 2>/dev/null
  echo '@reboot sleep 60 && folm-cli startmasternode local false'
) | crontab
folmd -daemon

clear
echo $STRING2
echo $STRING13
echo $STRING3
echo $STRING13
echo $STRING4
sleep 10
echo $STRING7
echo $STRING13
echo $STRING8
echo $STRING13
echo $STRING9
echo $STRING13
echo $STRING10
echo $STRING13
echo $STRING11
echo $STRING13
echo $STRING12
echo $STRING14
sleep 5m

read -p "Press any key to continue... " -n1 -s
folm-cli startmasternode local false
folm-cli masternode status
