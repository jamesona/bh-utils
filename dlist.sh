#!/bin/bash
doms=$(awk 'FS="," { if ($2 != "Unassigned")print $1"|" }' $@|tail -n +2|tr -d ' n'|head -c -1)
user=$(zenity --entry --title="Enter customer username:" --width=270)
host=$(zenity --entry --title="Enter host (box###.bluehost.com):" --width=350)
echo "$doms|$user@$host" | zenity --text-info --title="Search Exim for:" &&
list=$(zenity --text-info --editable --title="paste in exim log")
#if [ -z $list ]; then exit; fi
echo "$list" | egrep -o "<= (.{1,30}@($doms)|$user@$host)" | sort | uniq -c | sort -nr | sed -e 's/(d+ <=)/n1/' | zenity --text-info --title "Sending Totals" &
exit 1;
