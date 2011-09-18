#! /bin/bash
# author: Ari Selseng
# version: v2, 18. september 2011
# license: GPLv2

clear
# Style
bold=`tput bold`
normal=`tput sgr0`
red='\e[0;31m'
blue='\e[1;34m'
purple='\e[1;35m'
green='\e[1;32m'


# functions to make the code cleaner, by 
title() { echo -en "${purple}#${normal}${bold}${blue} $1\n ${normal}"; }
titlenn() { echo -e "${purple}#${normal}${bold}${blue} $1 ${normal}"; }
newline() { echo -en '\n'; }
logosystm(){ echo -ne "${green}$1"; }
logonfo(){ echo -e "${blue}$1"; }
logoline(){ echo -en "${purple}$1"; }

# Welcome
newline
logosystm " _____ __ __ _____ _____ _____    ";logonfo " _____ _____ _____ "
logosystm "|   __|  |  |   __|_   _|     |";logoline "___";logonfo "|   | |   __|     |"
logosystm "|__   |_   _|__   | | | | | | |";logoline "___";logonfo "| | | |   __|  |  |"
logosystm "|_____| |_| |_____| |_| |_|_|_|   ";logonfo "|_|___|__|  |_____|${normal}"
echo "  GPLv2";newline
                                             
# Retrievs the external IP with a 3rd party service.
title "External IP: ";wget -qO- icanhazip.com;newline

# Gets the internal IP
title "Internal IP address(es): "; hostname --all-ip-addresses;newline

# Display the computers hostname
Hostname=$(hostname)
title "Hostname: "
hostname;newline

# Free available memory
title "Actual free memory:"
actualfreemem=$(free -m | awk '/-\/\+\ buffers\/cache:/ {print $4}')
echo -e "$actualfreemem \bMB";newline 

# Apps with most RAM usage
titlenn "Processes using the most memory:"
ps -A --sort -rss -o comm,pmem | head -n 4|awk '{sub(/COMMAND/,"Name    ");print}'|awk '{sub(/%MEM/,"Memory (%)");print}';newline

# Partition Information
titlenn "Partition Information:"
df -PhT |awk '{sub(/Filesystem/,"Device");print}'|awk '{sub(/Mounted on/,"Path");print}'|awk '{sub(/Avail/,"Free");print}'|grep -v none|column -t;newline

# Displays uptime in hours:minuets
title "System uptime:"
uptime | awk -F ',' ' {print $1} '|awk ' {print $3} ';newline

# Displays when the system was installed
title "First setup:"
ls -lct /etc | tail -1 | awk '{print $6, $7}'

# If the system has mplayer, run fancy welcome text
hash mplayer &> /dev/null
if [ $? -eq 1 ]; then
    echo >&2 "mplayer not found."
	else
		say() { mplayer "http://translate.google.com/translate_tts?q=$1" > /dev/null 2>&1; }
		say "Hello $USER, and welcome to Systm INFO."
fi



