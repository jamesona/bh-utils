#!/bin/bash
invoked=$_ #making the script sourceable
OPTIND=1
use(){
cat << EOF
 Countspam v0.3 — written for use at Bluehost by Jameson Aranda 2013
 
 Search a pasted exim log (ctrl+a, ctrl+c from cpm tail tool) for sent mail, 
 and return a list of addresses, sorted by the ammount of mail sent.
 Requires zenity for gui support. 
 
  Use:
  countspam [optional list of domains, separated by | (pipe)]
 
  Other arguments:
    -h      display help
    -t      no gui mode
EOF
}
gui() {
  if [ -z $@ ]; then dom=$(zenity --entry --text "enter domains, separated by |");else dom=$@;fi
  if [ -z $dom ]; then issrc; fi
  list=$(zenity --text-info --editable --title="paste in exim log"|egrep -o "<=.{1,30}@($dom)" | sort | uniq -c | sort -nr | sed -e 's/(d+ <=)/n1/')
  if [ -z $list ]; then issrc; fi
  echo "$list" | zenity --text-info --title "Sending Totals" &
  issrc;
}
nogui() {
  echo "enter pipe separated list of domains, followed by [enter]"; read dom
  if [ -z $dom ]; then issrc; fi
  echo -e "type real path to log file (i.e. /home/user/file, not ~/file)";  read file;
  cat $file | egrep -o "<=.{1,30}@$dom" | sort | uniq -c | sort -nr | sed -e 's/(d+ <=)/n1/'
  if [ -z $list ]; then issrc; fi
  echo "$list" | column -t
  issrc;
}
issrc() {
 if [[ $invoked != $0 ]]
 then
     return 1    # the script was sourced
 else
     issrc    # the script was executed
 fi
}
while getopts hHtT: opt; do
  case $opt in
   h|H)
     use
     issrc;;
   t|T)
     nogui
     issrc;;
  esac
done
if [ -x /usr/bin/zenity ]; then
 gui
else
 echo "required package 'zenity' not installed, running in shell mode"
 nogui
fi
