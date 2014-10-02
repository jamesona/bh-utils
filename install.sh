#!/bin/bash
invoked=$_ #making the script sourceable
OPTIND=1
###############
## Functions ##
###############
info() {
cat << EOF
 
  Bluehost Tools - Written for use in the Bluehost Support by Jameson Aranda (2013)
  This is the base package installer.
 
  Options
  ##################################################################  
  -d [path]  Override the install directory.
 
  -s         Safe mode. Saves packages to /dev/null rather than the default directory.
 
  -i,        Display help text.
  -h
 
EOF
}
####################### Exit ########################
issrc() {
 if [[ $invoked != $0 ]]
 then
     return 1    # the script was sourced
 else
     exit 1    # the script was executed
 fi
}
####################### Bluehost Logo ############################################################
logo(){
echo -e '\n\n'
tput bold
tput cuf `expr $(($(tput cols)-10)) / 2`
echo -ne "\e[48;5;75m BlueHost \e[0m\n"
tput cuf `expr $(($(tput cols)-14)) / 2`
echo -ne "\e[48;5;0m              \n"
tput cuf `expr $(($(tput cols)-14)) / 2`
echo -ne "\e[48;5;0m  \e[48;5;4m  \e[48;5;0m  \e[48;5;4m  \e[48;5;0m  \e[48;5;4m  \e[48;5;0m  \n"
tput sgr0;
tput cuf `expr $(($(tput cols)-14)) / 2`
echo -ne "\e[48;5;0m              \n"
tput cuf `expr $(($(tput cols)-14)) / 2`
echo -ne "\e[48;5;0m  \e[48;5;4m  \e[48;5;0m  \e[48;5;4m  \e[48;5;0m  \e[48;5;4m  \e[48;5;0m  \n"
tput sgr0
tput cuf `expr $(($(tput cols)-14)) / 2`
echo -ne "\e[48;5;0m              \n"
tput cuf `expr $(($(tput cols)-14)) / 2`
echo -ne "\e[48;5;0m  \e[48;5;4m  \e[48;5;0m  \e[48;5;4m  \e[48;5;0m  \e[48;5;75m  \e[48;5;0m  \n"
tput sgr0
tput cuf `expr $(($(tput cols)-14)) / 2`
echo -ne "\e[48;5;0m              "
tput sgr0
echo
}
############ Splash ####################################
splash() {
  clear
  logo
  center "╔══════════════════════════════════════════════════════════════════════════╗"
  center "║ This is the base package installer for Jameson's Bluehost Utility Suite. ║"
  center "║Press enter to abort install, or type yes to proceed to package selection.║"
  center "╚═════════════════════════════════╤══════╤═════════════════════════════════╝"
  center "│ >___ │"
  center "└──────┘"
  tput cup 15 `expr $(($(tput cols)-2)) / 2`
  read -n 3
  if [[ $REPLY =~ ^[Yy][Ee][Ss]$ ]]; then
   echo; echo
   center "Continuing to package selection"
   sleep 2
   clear
  else
   echo "Aborted"
   issrc
  fi
}
############# Confirm ###############
confirm() {
  echo -ne "nn$1 "
  while read -s -rp $'(y/n)n' -n 1; do
  case "$REPLY" in
  [nN])
     ans=0
     break;;
  [yY])
     ans=1
     break;;
  ?)
     echo "Please enter Y or N"
     ;;
  esac
  done
  }
############# Center #######################
center(){
 tput cuf `expr $(($(tput cols)-${#1})) / 2`
 if [ $# -gt 1 ];then
  echo -en "$1"; `eval $2`
 else 
  echo -e $1
 fi
}
############# Menu ###################################################
menu() {
  echo "Avaliable options:"
  for i in ${!options[@]}; do 
      printf "[%s] %2d) %s\n" "${choices[i]:- }" $((i+1)) "${options[i]}";
  done
  [[ "$msg" ]] && echo "$msg"; :
  }
####################### Selection ###############################################
selection() {
  clear
  prompt="Check an option (again to uncheck, ENTER when done): "
  while menu && read -rp "$prompt" num && [[ "$num" ]]; do
    clear
    [[ "$num" != *[![:digit:]]* ]] && (( num > 0 && num <= ${#options[@]} )) || {
        msg="Invalid option: $num"; continue
    }
    ((num--)); msg="${options[num]} was ${choices[num]:+un}checked"
    [[ "${choices[num]}" ]] && choices[num]=" " || choices[num]="✓"
  done
  printf "nnYou selected:n";  msg=" nothing"
  for i in ${!options[@]}; do 
    [[ "${choices[i]}" == "✓" ]] && { printf " %s" "${options[i]}";echo; msg=""; }    
  done
  }
############## Install ######################################
install() {
  echo -e "nConfiguring local directories"
  if [ ! -d $dir ]; then
    echo "$dir not found"
    echo "creating $dir"
    mkdir $dir
  else
    echo "$dir detected, setting install path"
  fi  
  curdir=$(pwd)
  cd $dir 
  echo -e "nInstalling Packagesnn"
  for i in "${!options[@]}"; do 
  [[ "${choices[i]}" == "✓" ]] && { 
     echo -ne "   Installing"
     printf " %s" "${options[i]}";
     echo "..."
     curl -# $repo${options[i]} > ${options[i]}
     msg=""
     }    
  done
  cd $curdir
  }
#########
## Run ##
#########
dir=/home/`whoami`/.scripts
source='http://jamesonaranda.com/code/'
list=http://jamesonaranda.com/blog/tag/bhutils/
options=($(wget -q -O - $repo |egrep -o $repo[[:alpha:]]+|egrep -v "(feed|install)"|cut -c $(len=${#repo}&&((len++))&&echo $len)-|uniq))
while getopts ":IiHhSsD:d:" opt; do
   case $opt in
     [IiHh])
       info
       issrc
       ;;
     [Ss])
       echo "Running in Safe/Preview mode. No programs will be installed."
       sleep 1
       dir="/dev/null"
       ;;
     [Dd])
       dir=${OPTARG}
       echo "Directory override: path set to $dir"
       sleep 1
       ;;
     ?)
       echo "Invalid option: -$OPTARG" >&2
       issrc
       ;;
   esac
done
splash
until [[ "$ans" = 1 ]];do
  selection
  confirm "Continue?"
done
unset ans
install
