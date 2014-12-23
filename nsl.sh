#!/bin/bash
invoked=$_ #making the script sourceable
OPTIND=1
#==vars==#
title=`tput bold; tput smul`
ctitle=`tput rmul; tput sgr0`
from=""
for dom; do true; done
resolver="8.8.8.8"
BRAND=out
DATE=out
LOCK=out
#==functions==#
info() {
cat << EOF
 
    Nameserver Lookup v0.96 - written for use at Bluehost by Jameson Aranda 2013
 
    Returns relevant fields from a whois and dig query for the domain,
    with optional highlighting of key or critical areas.
 
    Use: nsl [opt] [BRAND] [domain]
 
    `tput smul`Options`tput rmul; tput sgr0`
    -h       Print help
    -r       Clear terminal before output
    -n [ns]  Specify DNS resolver by hostname OR IP (default is Google)
    -i       Get host information of resolved ip
    -c       Get cURL data
    -b       Highlight brand
 
EOF
}
issrc() {
 if [[ $invoked != $0 ]]
 then
     return 1    # the script was sourced
 else
     exit 1    # the script was executed
 fi
}
cs(){
tr -d " \t"
}
brand() {
sed -e 's/\(ns\d|whois.\)\?fastdomain\(.com\)\?.*/\1FastDomain\2/gI' | 
sed -e 's/\(ns\d.\)\?hostmonster\(.com\)\?.*/\1HostMonster\2/gI' | 
sed -e 's/\(ns\d.\)\?bluehost\(.com\)\?.*/\1Bluehost\2/gI' | 
sed -e 's/\(ns\d.\)\?justhost\(.com\)\?.*/\1JustHost\2/gI' |  
awk -v B=`tput cub 99;tput cuf 25` -v A=`tput cub 99;tput cuf 20` 'BEGIN { FS=":" } {reg=$2;
if ( reg ~ /FastDomain/ ) brand="\033[92m\xE2\x9C\x93\033[0m    \033[38;5;220;1m"$2"\033[0m";
else if ( reg ~ /Bluehost/ ) brand="\033[92m\xE2\x9C\x93\033[0m    \033[38;5;33;1m"$2"\033[0m";
else if ( reg ~ /HostMonster/ ) brand="\033[92m\xE2\x9C\x93\033[0m    \033[38;5;70;1m"$2"\033[0m";
else if ( reg ~ /JustHost/ ) brand="\033[92m\xE2\x9C\x93\033[0m    \033[38;5;124;1m"$2"\033[0m";
#if ( reg ~ /FastDomain/ ) brand="\033[92m\xE2\x9C\x93\033[0m    \033[38;5;25;48;5;220m"$2"\033[0m";
#else if ( reg ~ /HostMonster/ ) brand="\033[92m\xE2\x9C\x93\033[0m    \033[32;1;5;24m"$2"\033[0m";
#else if ( reg ~ /JustHost/ ) brand="\033[92m\xE2\x9C\x93\033[0m    \033[38;5;18;48;5;88m"$2"\033[0m";
#else if ( reg ~ /HostMonster/ ) brand="\033[92m\xE2\x9C\x93\033[0m    \033[48;5;70;38;5;24m"$2"\033[0m";
else brand="\033[38;5;214m!    "$2"\033[0m"; 
print "  "$1":" A brand}'
}
expire() {
awk -v B=`tput cub 99;tput cuf 20` 'BEGIN { FS=":" } {print "  "$1":" B"33[91mxf0x9fx98x9e33[0m   " $2}'
}
out() {
awk -v B=`tput cub 99;tput cuf 25` 'BEGIN { FS=":" } {print "  "$1":" B $2}'
}
lookup() {
who=$(whois $dom)
echo -e '\n   '$title'\e[97mWHOIS results for '$dom$ctitle
echo "$who" | egrep -io "Registrar(nsName)?:.+"| head -1 |cs| $BRAND
echo "$who" | egrep -io "Registrant:[[:space:]]*?[a-zA-Z0-9.]+" |cs| out
echo "$who" | egrep -io "Whois ?Server:[[:space:]]*?[a-zA-Z0-9.]+" |cs| $BRAND
echo "$who" | egrep -io "Name ?Servers?:[[:space:]]*?[a-zA-Z0-9.-]+" |cs| $BRAND
echo "$who" | egrep -io "Updated ?Date:.+" |cs| out
echo "$who" | egrep -io "Creation ?Date:.+" |cs| out
echo "$who" | egrep -io "Expiration ?Date:.+" |cs| out
echo "$who" | egrep -io "Status:.+" |cs| $LOCK
echo -e "\n   "$title"\e[97mDIG results for $dom"$ctitle$(if [[ $resolver != "8.8.8.8" ]]; then echo " (from $resolver)"; fi)
dig any $dom @$resolver +noall +answer | egrep "IN" | egrep -v "(NS|SOA)" | sed -r 's/.+(A|CNAME|MX|TXT|SRV|AAAA)\t/\1\t/' | awk -v B=`tput cub 99;tput cuf 26` 'BEGIN { FS="\t" } {print "  "$1":" B $2}' | sort -d
if [ -n "$HOST" ]; then 
 echo -e '\n   '$title'\e[97mHost Data for '$dom$ctitle;
 host $dom|sort -h| tee >(sed 's/^/  /'>/dev/stderr)|head -1|awk  '{print $NF}'|xargs host|sed 's/^/  /'; 
fi
if [ -n "$CURL" ]; then
 echo -e '\n   '$title'\e[97mcURL Data for '$dom$ctitle;
 curl -LI $dom |sed 's/^/  /'
fi
echo -e "\033[0m"
}
#==opts==#
while getopts ":HhRrIiCcBbDdLlNn:" opt; do
  case $opt in
    h|H)
      info
      issrc;;
    r|R)
      reset;;
    n|N)
      resolver=${OPTARG};;
    i|I)
      HOST=host;;
    c|C)
      CURL=curl;;
    b|B)
      BRAND=brand;;
    d|D)
      DATE=expire;;
    l|L)
      LOCK=lock;;
    ?)
      echo "invalid argument"; info; issrc;;
  esac
done
#==run==#
lookup
