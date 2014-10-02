#!/bin/bash
#vars
fail='Recived invalid type or cancelled, log not created.'
use(){
cat << EOF
 Log Chat, written for use at Bluehost by Jameson Aranda 2013
 
 log [arg..] [type...] - log escalaion chats to the logs directory in the format ~/logs/[type]-yymmddhh
 Type argument is optional; if left empty a selection dialog will appear. 
  Valid types:
     2  L2
     3  L3
     d  Domains
     t  Terms of Service
     q  Quality Assurance
     s  Site Compatibility
     c  Chargebacks
     l  LineItems
     b  Billing
     v  Verification
     p  Paypal Chargebacks
     f  Fraud
 
  Other arguments:
    -h          display help
 
    -f [string] search logs by string
 
    -r [log]    read [log] (not yet implemented)
 
    -r [type]   search logs by type or date (not yet implemented)
       [date]
 
EOF
}
#check/create log directory
if [ ! -d ~/logs ]; then mkdir ~/logs; fi
 
logc(){
while getopts h23dtqsclbvpf: opt; do
  case $opt in
   h)
     use
     exit;;
   f)
     grep -n "${@:2}" `ls -1 ~/logs/*` /dev/null|zenity --text-info --title="Search results for "${@:2}""; 
     exitexit;;
   2)
     chat=$(zenity --text-info --editable --title="paste in L2 chat") & sleep 2 && wmctrl -r "paste in" -b add,above; if [[ $chat = '' ]]; then echo $fail
     else echo $chat > ~/logs/L2-$(date +%y%m%d%H%S); echo 'chat saved to '`ls ~/logs/L2* | tail -n 1`; fi
     exit;;
   3)
     chat=$(zenity --text-info --editable --title="paste in L3 chat"); if [[ $chat = '' ]]; then echo $fail
     else echo $chat > ~/logs/L3-$(date +%y%m%d%H%S); echo 'chat saved to '`ls ~/logs/L3* | tail -n 1`; fi
     exit;;
   d)
     chat=$(zenity --text-info --editable --title="paste in Domains chat"); if [[ $chat = '' ]]; then echo $fail
     else echo $chat > ~/logs/DOM-$(date +%y%m%d%H%S); echo 'chat saved to '`ls ~/logs/D* | tail -n 1`; fi
     exit;;
   t)
     chat=$(zenity --text-info --editable --title="paste in Terms of Service chat"); if [[ $chat = '' ]]; then echo $fail
     else echo $chat > ~/logs/ToS-$(date +%y%m%d%H%S); echo 'chat saved to '`ls ~/logs/T* | tail -n 1`; fi
     exit;;
   q)
     chat=$(zenity --text-info --editable --title="paste in QA chat"); if [[ $chat = '' ]]; then echo $fail
     else echo $chat > ~/logs/QA-$(date +%y%m%d%H%S); echo 'chat saved to '`ls ~/logs/Q* | tail -n 1`; fi
     exit;;
   s)
     chat=$(zenity --text-info --editable --title="paste in Site Comp chat"); if [[ $chat = '' ]]; then echo $fail
     else echo $chat > ~/logs/COM-$(date +%y%m%d%H%S); echo 'chat saved to '`ls ~/logs/S* | tail -n 1`; fi
     exit;;
   c)
     chat=$(zenity --text-info --editable --title="paste in Chargeback chat"); if [[ $chat = '' ]]; then echo $fail
     else echo $chat > ~/logs/CHAR-$(date +%y%m%d%H%S); echo 'chat saved to '`ls ~/logs/C* | tail -n 1`; fi
     exit;;
   l)
     chat=$(zenity --text-info --editable --title="paste in Lineitems chat"); if [[ $chat = '' ]]; then echo $fail
     else echo $chat > ~/logs/LINE-$(date +%y%m%d%H%S); echo 'chat saved to '`ls ~/logs/L* | tail -n 1`; fi
     exit;;
   b)
     chat=$(zenity --text-info --editable --title="paste in Billing chat"); if [[ $chat = '' ]]; then echo $fail
     else echo $chat > ~/logs/BIL-$(date +%y%m%d%H%S); echo 'chat saved to '`ls ~/logs/B* | tail -n 1`; fi
     exit;;
   v)
     chat=$(zenity --text-info --editable --title="paste in Verification chat"); if [[ $chat = '' ]]; then echo $fail
     else echo $chat > ~/logs/VER-$(date +%y%m%d%H%S); echo 'chat saved to '`ls ~/logs/V* | tail -n 1`; fi
     exit;;
   p)
     chat=$(zenity --text-info --editable --title="paste in Paypal chat"); if [[ $chat = '' ]]; then echo $fail
     else echo $chat > ~/logs/PAY-$(date +%y%m%d%H%S); echo 'chat saved to '`ls ~/logs/P* | tail -n 1`; fi
     exit;;
   f)
     chat=$(zenity --text-info --editable --title="paste in Fraud chat"); if [[ $chat = '' ]]; then echo $fail
     else echo $chat > ~/logs/FRA-$(date +%y%m%d%H%S); echo 'chat saved to '`ls ~/logs/F* | tail -n 1`; fi
     exit;;
   ?)
     use
     exit;;
  esac
done
}
 
if [[ ! $1 =~ -[a-zA-Z] ]]; 
then logc "-"$1
fi
if [[ -z $1 ]]
then logc -`zenity  --list  --text "Please select chat type" --radiolist  --column "Pick" --column "Chat type" TRUE L2  FALSE L3  FALSE Domains  FALSE 'Terms of Service'  FALSE QA  FALSE 'Site Compatibility' FALSE Chargebacks FALSE LineItems FALSE Billing FALSE Verification FALSE 'PayPal Chargebacks' FALSE Fraud | sed -e "s/L([0-9])/1/"|cut -b 1|tr '[A-Z]' '[a-z]'`
fi
logc
