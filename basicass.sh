#!/usr/bin/env bash
########################################################################
# IndianZ Quick and Dirty Basic Network Assessment                     #
# Version 2.0, 2014-08-29, 17:00 GMT+1                                 #
# https://www.indianz.ch/ - indianz<at>indianz<dot>ch                  #
########################################################################
# This program is free software: you can redistribute it and/or modify #
# it under the terms of the GNU General Public License as published by #
# the Free Software Foundation, either version 3 of the License, or    #
# (at your option) any later version. This program is distributed in   #
# the hope that it will be useful, but WITHOUT ANY WARRANTY; without   #
# even the implied warranty of MERCHANTABILITY or FITNESS FOR A        #
# PARTICULAR PURPOSE. See the GNU General Public License for more      #
# details: http://www.gnu.org/licenses/                                #
########################################################################
# Description: Automatisation of some basic network assessment tasks.  #
# Needs tcpdump, host, dig, whois, nmap, unicornscan, amap, hping2,    #
# nikto, curl, openssl, ruby19, whatweb, nessus, wget as well as some  #
# linux-internal tools                                                 #
########################################################################
# Functionality:                                                       #
# - checks for supported tcp/ip protocols (ip, ipv6, tcp, udp, icmp)   #
# - checks for common open ports tcp/udp                               #
# - download of nmap stylesheet (if connectivity available)            #
# - checks services (dns, whois, http/s)                               #
# - checks for vulnerabilities with nessus                             #
# - dumps network traffic with tcpdump                                 #
########################################################################
# Tested with Bash 4.3.24 on Arch Linux 3.16.1-1-ARCH x86_64 GNU/Linux #
########################################################################

# configure variables
VERSION=1.2
YOURUSER=username
NESSUSHOST=127.0.0.1
NESSUSUSER=user
NESSUSPASS=pass
NESSUSPORT=1241
NETINTERFACE=eth0
LOG=basicass_$1.txt
PROTOCOLS=1,4,6,17,41
PORTSTCP=22,111,443,723,813,849,1443,1556,3998,3999,5556,6481,7001,7203,8234,13724,13782,15997,21162,30051,30053,30100,30185,30686,32819,35799,40110,43358,48434,49534,52770,60453
PORTSUDP=111,123,162,810,811,846,5353,34829,37341,38977,39606,48412
DMZPORTS=20,21,22,23,25,53,80,110,113,143,161,443,445,587,989,990,993,995

# backup of port lists
#PROTOCOLS=1,4,6,17,41
#PORTSTCP=1,7,8,11,13,15,19,20,21,22,23,25,26,37,42,43,53,79,80,81,88,98,106,109,110,111,113,119,135,137,138,139,143,144,179,199,264,389,423,427,443,444,445,464,465,512,513,514,515,540,543,544,548,554,587,593,631,636,646,666,706,777,873,900,993,994,995,1025,1026,1027,1028,1029,1080,1110,1234,1241,1352,1433,1434,1494,1521,1526,1541,1701,1720,1723,1755,1900,1999,2000,2001,2049,2121,2301,2381,2401,2433,2638,2717,3128,3286,3269,3306,3372,3389,4110,4242,4321,4430,4444,4480,5000,5222,5353,5432,5631,5632,5723,5724,5800,5900,6000,6001,6002,6103,6112,6588,6666,6667,7001,7002,7070,7100,8000,8001,8005,8008,8010,8080,8088,8100,8443,8531,8800,8843,8880,8888,8890,9090,9100,9391,9999,10000,10001,12001,32768,33333,49152,49153,49154,49155,49156,49157,65535
#PORTSUDP=1,7,8,9,11,15,17,19,49,53,67,68,69,80,88,111,120,123,135,136,137,138,139,158,161-162,177,427,443,445,497,500,513,514,515,518,520,593,623,626,631,996-999,1022-1023,1025-1030,1194,1433,1434,1645,1646,1701,1718,1719,1812,1813,1900,2000,2048,2049,2222,2223,3283,3456,3703,4045,4444,4500,5000,5020,5060,5353,5632,9200,10000,17185,20031,30718,31337,32768,32769,32771,32815,33281,49152,49153,49154,49156,49181,49182,49185,49186,49188,49190,49191,49192,49193,49194,49200,49201,65024,65535
#DMZPORTS=20,21,22,23,25,53,80,110,113,143,161,443,445,587,989,990,993,995

# check/set path to tools
ECHO=`which echo`
TEE=`which tee`
GREP=`which grep` 
PS=`which ps`
DATE=`which date`
TCPDUMP=`which tcpdump`
SLEEP=`which sleep`
IP=`which ip`
ROUTE=`which route`
HOST=`which host`
DIG=`which dig`
WHOIS=`which whois`
NMAP=`which nmap`
UNICORNSCAN=`which unicornscan`
AMAP=`which amap`
HPING2=`which hping2`
NIKTO=`which nikto`
CURL=`which curl`
OPENSSL=`which openssl`
RUBY19=`which ruby-1.9`
WHATWEB=`which whatweb`
PRINTF=`which printf`
NESSUS=`which nessus`
NESSUSSERVICE=`which nessus-service`
KILL=`which kill`
SYNC=`which sync`
MKDIR=`which mkdir`
WGET=`which wget`
SED=`which sed`
CP=`which cp`
MV=`which mv`
TAR=`which tar`
RM=`which rm`
CHOWN=`which chown`
CHMOD=`which chmod`

# banner function
function Banner()
{
$ECHO
$ECHO "  _..__.          .__.._"
$ECHO " .^-.._ '-(\__/)-' _..-^."
$ECHO "       '-.' oo '.-'"
$ECHO "          '-..-'"
$ECHO
$ECHO " IndianZ Basic Assessment" $VERSION 
$ECHO
}

# check root permissions
if [[ $EUID -ne 0 ]]; then
  Banner
  $ECHO
  $ECHO "[!] not root: please use sudo"
  $ECHO
  exit 1
fi

# check for parameters
if [ $# -ne 1 ]; then
  Banner
  $ECHO
  $ECHO "[!] parameter missing: $0 TARGETIP"
  $ECHO
  exit 1
fi

# check if nessusd is running, if not start and update it
$PS aux | $GREP -v grep | $GREP nessusd > /dev/null
if [ $? -ne 0 ]; then
  Banner
  $ECHO
  $ECHO "[!] nessusd not running: starting it now"
  $ECHO
  $NESSUSSERVICE -D
else
  $ECHO
  $ECHO "[i] nessusd is running" 
  $ECHO
fi

# show and record banner
Banner | $TEE -a $LOG

# supporting ctrl+c for abortion of actual test
signal_handler()
{
$SYNC
$SLEEP 3
$ECHO | $TEE -a $LOG
$ECHO "[!] ctrl+c: actual test aborted" | tee -a $LOG
$ECHO | $TEE -a $LOG
}

# log time
$ECHO | $TEE -a $LOG
$ECHO "[i] record time" | $TEE -a $LOG
$ECHO | $TEE -a $LOG
$DATE 2>&1 | $TEE -a $LOG
$ECHO | $TEE -a $LOG

# log infos
$ECHO | $TEE -a $LOG
$ECHO "[i] record ip/route" | $TEE -a $LOG
$IP addr show $NETINTERFACE 2>&1 | $TEE -a $LOG
$ECHO | $TEE -a $LOG
$IP route list 2>&1 | $TEE -a $LOG
$ECHO | $TEE -a $LOG
$ECHO "[i] tester ip (public internet)" | $TEE -a $LOG
$CURL https://www.indianz.ch/ip.php 2>&1 | $TEE -a $LOG
$ECHO | $TEE -a $LOG

# catch ctrl+c signal
trap signal_handler SIGINT

# message to user
$ECHO | $TEE -a $LOG
$ECHO "[i] starting checks now" | $TEE -a $LOG
$ECHO | $TEE -a $LOG

# start tcpdump
$ECHO | $TEE -a $LOG
$ECHO "[i] start tcpdump" | $TEE -a $LOG
$ECHO | $TEE -a $LOG
$TCPDUMP -i $NETINTERFACE -n -s0 -w basicass_$1.dump host $1 & dumppid=$!
$SLEEP 3
$ECHO | $TEE -a $LOG

# firewall check
$ECHO "[i] firewall" | $TEE -a $LOG
$ECHO | $TEE -a $LOG
$NMAP -sS -P0 -p $DMZPORTS --badsum -T3 --reason -e $NETINTFACE -n -vvv --packet_trace $1 2>&1 | $TEE -a $LOG
$ECHO | $TEE -a $LOG

# dns checks
$ECHO "[i] host" | $TEE -a $LOG
$ECHO | $TEE -a $LOG
$HOST $1 2>&1 | $TEE -a $LOG
$ECHO | $TEE -a $LOG
$ECHO "[i] host reverse" | $TEE -a $LOG
$ECHO | $TEE -a $LOG
$HOST -la $1 2>&1 | $TEE -a $LOG
$ECHO | $TEE -a $LOG
$ECHO "[i] dig" | $TEE -a $LOG
$ECHO | $TEE -a $LOG
$DIG any $1 2>&1 | $TEE -a $LOG
$ECHO | $TEE -a $LOG
$ECHO "[i] dig relay lookup" | $TEE -a $LOG
$ECHO | $TEE -a $LOG
$DIG @$1 www.indianz.ch $1 2>&1 | $TEE -a $LOG
$ECHO | $TEE -a $LOG
$ECHO "[i] bind version" | $TEE -a $LOG
$ECHO | $TEE -a $LOG
$HOST -t txt -c chaos version.bind $1 2>&1 | $TEE -a $LOG
$ECHO | $TEE -a $LOG
$DIG @$1 version.bind txt chaos 2>&1 | $TEE -a $LOG
$ECHO | $TEE -a $LOG

# whois check
$ECHO "[i] whois" | $TEE -a $LOG
$ECHO | $TEE -a $LOG
$WHOIS -a $1 2>&1 | $TEE -a $LOG
$ECHO | $TEE -a $LOG

# protocol checks
$ECHO | $TEE -a $LOG
$ECHO "[i] nmap protocols" | $TEE -a $LOG
$ECHO | $TEE -a $LOG
$NMAP -sO -T5 -P0 -e $NETINTERFACE -p $PROTOCOLS -n -vvv -oX nmap_protocols_$1.xml $1 2>&1 | $TEE -a $LOG
# for all protocols use:
# $NMAP -sO -T5 -P0 -e $NETINTERFACE -p- -n -vvv -oX nmap_protocols_$1.xml $1 2>&1 | $TEE -a $LOG
$ECHO | $TEE -a $LOG

# tcp/udp port checks
$ECHO | $TEE -a $LOG
$ECHO "[i] nmap ports tcp/udp" | $TEE -a $LOG
$ECHO | $TEE -a $LOG
$NMAP -sSUV -A -e $NETINTERFACE -T5 -P0 -O --reason --open -n -vvv -oX nmap_combined_$1.xml -p T:$PORTSTCP,U:$PORTSUDP $1 2>&1 | $TEE -a $LOG
$ECHO | $TEE -a $LOG
$ECHO "[i] nmap ports tcp" | $TEE -a $LOG
$ECHO | $TEE -a $LOG
$NMAP -sS -e $NETINTERFACE -P0 -p $PORTSTCP -T5 -n -v -oM nmap-tcp -oX nmap_tcp_$1.xml $1 2>&1 | $TEE -a $LOG
# for all ports use:
# $NMAP -sS -e $NETINTERFACE -P0 -p- -T5 -n -v -oM nmap-tcp -oX nmap_tcp_$1.xml $1 2>&1 | $TEE -a $LOG
$ECHO | $TEE -a $LOG
$ECHO "[i] nmap ports udp" | $TEE -a $LOG
$ECHO | $TEE -a $LOG
$NMAP -sU -e $NETINTERFACE -P0 -p $PORTSUDP -T5 -n -v -oM nmap-udp -oX nmap_udp_$1.xml $1 2>&1 | $TEE -a $LOG
# for all ports, but only if icmp is NOT filtered, use:
# $NMAP -sU -e $NETINTERFACE -P0 -p $PORTSUDP -T5 -n -v -oM nmap-udp -oX nmap_udp_$1.xml $1 2>&1 | $TEE -a $LOG
$ECHO | $TEE -a $LOG
$ECHO "[i] unicornscan ports tcp" | $TEE -a $LOG
$ECHO | $TEE -a $LOG
$UNICORNSCAN -mT -p -vv $1/32:p -r100 2>&1 | $TEE -a $LOG
# for all ports use:
# $UNICORNSCAN -mT -p -vv $1/32:a -r100 2>&1 | $TEE -a $LOG
$ECHO | $TEE -a $LOG
$ECHO "[i] unicornscan ports udp" | $TEE -a $LOG
$ECHO | $TEE -a $LOG
$UNICORNSCAN -mU -p -vv $1/32:p -r100 2>&1 | $TEE -a $LOG
# for all ports use:
# $UNICORNSCAN -mU -p -vv $1/32:a -r100 2>&1 | $TEE -a $LOG
$ECHO | $TEE -a $LOG
$ECHO "[i] amap application mapper" | $TEE -a $LOG
$ECHO | $TEE -a $LOG
$AMAP -AbqvH -c 1 -i nmap-tcp 2>&1 | $TEE -a $LOG
$ECHO | $TEE -a $LOG
$AMAP -AbqvHu -c 1 -i nmap-udp 2>&1 | $TEE -a $LOG
$ECHO | $TEE -a $LOG

# icmp/tcp checks
$ECHO | $TEE -a $LOG
$ECHO "[i] hping2 port 22 timestamp" | $TEE -a $LOG
$ECHO | $TEE -a $LOG
$HPING2 $1 -S -c 1 -p 22 --tcp-timestamp 2>&1 | $TEE -a $LOG
$ECHO | $TEE -a $LOG
$ECHO "[i] hping2 port 80 timestamp" | $TEE -a $LOG
$ECHO | $TEE -a $LOG
$HPING2 $1 -S -c 1 -p 80 --tcp-timestamp 2>&1 | $TEE -a $LOG
$ECHO | $TEE -a $LOG
$ECHO "[i] hping2 icmp timestamp" | $TEE -a $LOG
$ECHO | $TEE -a $LOG
$HPING2 $1 -c 1 -C 13 -K 00 --force-icmp 2>&1 | $TEE -a $LOG
$ECHO | $TEE -a $ LOG
$ECHO "[i] hping2 netmask" | $TEE -a $LOG
$ECHO | $TEE -a $LOG
$HPING2 $1 -c 1 -C 17 -K 00 --force-icmp 2>&1 | $TEE -a $LOG
$ECHO | $TEE -a $LOG

# web checks
$ECHO | $TEE -a $LOG
$ECHO "[i] nikto http" | $TEE -a $LOG
$ECHO | $TEE -a $LOG
$NIKTO -v -port 80 -nossl -host $1 2>&1 | $TEE -a $LOG
$ECHO | $TEE -a $LOG
$ECHO "[i] nikto https" | $TEE -a $LOG
$ECHO | $TEE -a $LOG
$NIKTO -v -port 443 -ssl -host $1 2>&1 | $TEE -a $LOG
$ECHO | $TEE -a $LOG
$ECHO "[i] curl http" | $TEE -a $LOG
$ECHO | $TEE -a $LOG
$CURL http://$1 --insecure 2>&1 | $TEE -a $LOG
$ECHO | $TEE -a $LOG
$ECHO "[i] nikto https" | $TEE -a $LOG
$ECHO | $TEE -a $LOG
$CURL https://$1 --insecure 2>&1 | $TEE -a $LOG
$ECHO | $TEE -a $LOG
$ECHO "[i] whatweb http" | $TEE -a $LOG
$ECHO | $TEE -a $LOG
$RUBY19 $WHATWEB http://$1 2>&1 | $TEE -a $LOG
$ECHO | $TEE -a $LOG
$ECHO "[i] whatweb https" | $TEE -a $LOG
$ECHO | $TEE -a $LOG
$RUBY19 $WHATWEB https://$1 2>&1 | $TEE -a $LOG
$ECHO | $TEE -a $LOG

# vulnerability checks
$ECHO | $TEE -a $LOG
$ECHO "[i] nessus vulnerabilities" | $TEE -a $LOG
$ECHO | $TEE -a $LOG
$PRINTF $1 > target.txt
$NESSUS -V -T xml -x -c nessus.config -q $NESSUSHOST $NESSUSPORT $NESSUSUSER $NESSUSPASS target.txt nessus_$1.xml 2>&1 | $TEE -a $LOG
$ECHO | $TEE -a $LOG

# stop tcpdump
$ECHO | $TEE -a $LOG
$ECHO "[i] stop tcpdump" | $TEE -a $LOG
$ECHO | $TEE -a $LOG
$KILL $dumppid
$SLEEP 3
$SYNC
$ECHO | $TEE -a $LOG

# log time
$ECHO | $TEE -a $LOG
$ECHO "[i] record time" | $TEE -a $LOG
$ECHO | $TEE -a $LOG
$DATE 2>&1 | $TEE -a $LOG
$ECHO | $TEE -a $LOG

# download nmap stylesheet
read -p "[?] download latest nmap.xsl from svn? (Yy/Nn) " answer
while true
do
  case $answer in
   [Yy]* ) $WGET http://nmap.org/svn/docs/nmap.xsl
           $ECHO "[i] downloading nmap.xsl"
           break;;

   [Nn]* ) $ECHO "[i] not downloading nmap.xsl"
           exit;;

   * )     $ECHO "[!] please enter either Yy or Nn"; break ;;
  esac
done

# clean, sort and move
$ECHO
$ECHO "[i] cleaning up"
$ECHO
$MKDIR basicass_$1_`$DATE +%Y%m%d`
$SED -i 's/http:\/\/nmap.org\/svn\/docs\/nmap.xsl/nmap.xsl/g' *.xml
$SED -i 's/file:\/\/\/usr\/share\/nmap\/nmap.xsl/nmap.xsl/g' *.xml
$SED -i 's/file:\/\/\/usr\/bin\/..\/share\/nmap\/nmap.xsl/nmap.xsl/g' *.xml
$MV nmap* basicass_$1_`$DATE +%Y%m%d`/
$MV nessus* basicass_$1_`$DATE +%Y%m%d`/
$MV target.txt basicass_$1_`$DATE +%Y%m%d`/
$RM -f amap.out
$TAR -cjf basicass_$1_dump.tgz basicass_$1.dump
$RM -f basicass_$1.dump
$MV basicass_$1_dump.tgz basicass_$1_`$DATE +%Y%m%d`/
$MV basicass_$1.txt basicass_$1_`$DATE +%Y%m%d`/

# set permissions
$ECHO
$ECHO "[i] setting permissions"
$CHOWN -R $YOURUSER:users basicass_$1_`$DATE +%Y%m%d`/
$CHMOD -R 770 basicass_$1_`$DATE +%Y%m%d`/

# exit correctly :p
$ECHO
$ECHO "[i] please find the results and the network dump in basicassess"$1_`$DATE +%Y%m%d`"/ directory"
$ECHO "[i] and have a nice day ;)"
$ECHO
exit 0