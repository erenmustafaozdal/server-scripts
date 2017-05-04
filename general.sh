#!/usr/bin/env bash

# ============================================================== #
#
# General Bash Scripts
# By erenMustafaOzdal [eren.060737@gmail.com]
#
# Last Modified 2017-04-29
#
# CODE INDEX
#   1. if not running interactively, don't do anything
#   2. Source global definitions
#   3. Automatic setting of $DISPLAY
#   4. Some settings
#   5. Enable options
#   6. Disable options
#   7. Greeting, colors etc.
#       7.a Normal Colors
#       7.b Soft Colors
#       7.c Background Colors
#       7.d Color Reset
#       7.e Alert
#       7.f User specific environment and startup programs
#   8. Echo bash version, display ip and date
#   9. exit function
#   10. Shell Prompt
#       10.a Test connection type
#       10.b Test user type
#       10.c CPU's and loads
#       10.d Returns system load as percentage
#       10.e Returns a color indicating system load.
#       10.f Returns a color according to free disk space in $PWD
#       10.g Returns a color according to running/suspended jobs
#       10.h Adds some text in the terminal frame (if applicable)
#       10.i for setting history length see HISTSIZE and HISTFILESIZE in bash
#   11. Alias and functions
#       11.a clear console
#       11.b safe file management
#       11.c Prevents accidentally clobbering files
#       11.d quick directory movement
#       11.e go to the last directory you were in
#       11.f ls aliases
#       11.g Pretty-print of some PATH variables
#       11.h Makes a more readable output
#       11.i quickly source the .bashrc file || remove .bashrc and nano
#       11.k update and upgrade system
#   12. File & strings related functions
#       12.a Find a file with a pattern in name
#       12.b Find a file with pattern $1 in name and Execute $2 on it
#       12.c Swap 2 filenames around, if they exist (from Uzi's bashrc)
#       12.d Handy Extract Program
#       12.e Creates an archive (*.tar.gz) from given directory
#       12.f Create a ZIP archive of a file or folder
#       12.g Make your directories and files access rights sane
#   13. Process/system related functions
#       13.a My personal system information
#       13.b Get IP address on ethernet
#       13.c Get current host related info
#   14. Misc utilities
#       14.a Repeat n times command
#       14.b ask question
#   15. add bitbucket ssh key
#   16. Echo management
#   17. Combine elements with a specific bracket (join)
#   18. Some directory functions
#       18.a go to
#       18.b go to project
#       18.c go to site root
#       18.d go to site
#       18.e remove all files in public_html
#       18.f make public_html directory
#
# ============================================================== #

# 1. if not running interactively, don't do anything
[ -z "$PS1" ] && return



# 2. Source global definitions (if any)
if [ -f /etc/bashrc ]; then
    . /etc/bashrc # --> Read /etc/bashrc, if present
fi



# 3. Automatic setting of $DISPLAY (if not set already)
function getXServer()
{
    case $TERM in xterm )
        XSERVER=$(who am i | awk '{print $NF}' | tr -d ')''(' )
        XSERVER=${XSERVER%%:*}
        ;;
        aterm | rxvt)
        ;;
    esac
}
if [ -z ${DISPLAY:=""} ]; then
    getXServer
    if [[ -z ${XSERVER} || ${XSERVER} == $(hostname) || ${XSERVER} == "unix" ]]; then
        DISPLAY=":0.0"                          # display on localhost
    else
        DISPLAY=${XSERVER}:0.0                  # display on remote
    fi
fi
export DISPLAY



# 4. Some settings
alias debug="set -o nounset; set -o xtrace"
ulimit -S -c 0      # Don't want coredumps.
set -o notify set -o noclobber
set -o ignoreeof



# 5. Enable options:
shopt -s cdspell
shopt -s cdable_vars
shopt -s checkhash
shopt -s checkwinsize
shopt -s sourcepath
shopt -s no_empty_cmd_completion
shopt -s cmdhist
shopt -s histappend histreedit histverify
shopt -s extglob       # Necessary for programmable completion.



# 6. Disable options:
shopt -u mailwarn
unset MAILCHECK        # Don't want my shell to warn me of incoming mail.



# ============================================================== #
#
# 7. Greeting, motd etc. ...
#
# Color definitions (taken from Color Bash Prompt HowTo).
# Some colors might look different of some terminals.
# For example, I see 'Soft Red' as 'orange' on my screen,
# hence the 'Green' 'SRed' 'Red' sequence I often use in my prompt.
#
# ============================================================== #


# 7.a Normal Colors
Black='\e[0;30m'        # Black
Red='\e[0;31m'          # Red
Green='\e[0;32m'        # Green
Yellow='\e[0;33m'       # Yellow
Blue='\e[0;34m'         # Blue
Purple='\e[0;35m'       # Purple
Cyan='\e[0;36m'         # Cyan
White='\e[0;37m'        # White
Gray='\e[1;30m'         # Gray

# 7.b Soft Colors
SBlack='\e[1;30m'       # Black
SRed='\e[1;31m'         # Red
SGreen='\e[1;32m'       # Green
SYellow='\e[1;33m'      # Yellow
SBlue='\e[1;34m'        # Blue
SPurple='\e[1;35m'      # Purple
SCyan='\e[1;36m'        # Cyan
SWhite='\e[1;37m'       # White

# 7.c Background Colors
On_Black='\e[40m'       # Black
On_Red='\e[41m'         # Red
On_Green='\e[42m'       # Green
On_Yellow='\e[43m'      # Yellow
On_Blue='\e[44m'        # Blue
On_Purple='\e[45m'      # Purple
On_Cyan='\e[46m'        # Cyan
On_White='\e[47m'       # White

# 7.d Color Reset
NC="\e[m"               # Color Reset

# 7.e Alert
ALERT=${SWhite}${On_Red} # Bold White on red background

# 7.f User specific environment and startup programs
PATH=$PATH:$HOME/bin
export PATH



# 8. Echo bash version, display ip and date
echo -e "${SCyan}This is BASH ${SRed}${BASH_VERSION%.*}${SCyan}\- DISPLAY on ${SRed}$DISPLAY${NC}\n"
date


# 9. exit function
function _exit()              # Function to run upon exit of shell.
{
    _echo "Good Bye :)" small SRed;
}
trap _exit EXIT



# ============================================================== #
#
# 10. Shell Prompt
#
# For many examples, see:
#   http://www.debian-administration.org/articles/205
#   http://www.askapache.com/linux/bash-power-prompt.html
#   http://tldp.org/HOWTO/Bash-Prompt-HOWTO
#   https://github.com/nojhan/liquidprompt
#
# Current Format: [TIME USER@HOST PWD] >
# TIME:
#   Green     == machine load is low
#    Orange    == machine load is medium
#    Red       == machine load is high
#    ALERT     == machine load is very high
# USER:
#    Cyan      == normal user
#    Orange    == SU to user
#    Red       == root
# HOST:
#    Cyan      == local session
#    Green     == secured remote connection (via ssh)
#    Red       == unsecured remote connection
# PWD:
#    Green     == more than 10% free disk space
#    Orange    == less than 10% free disk space
#    ALERT     == less than 5% free disk space
#    Red       == current user does not have write privileges
#    Cyan      == current filesystem is size zero (like /proc)
# >:
#    White     == no background or suspended jobs in this shell
#    Cyan      == at least one background job in this shell
#    Orange    == at least one suspended job in this shell
#
#    Command is added to the history file each time you hit enter,
#    so it's available to all shells (using 'history -a').
#
# ============================================================== #

# 10.a Test connection type
if [ -n "${SSH_CONNECTION}" ]; then
    CNX=${Green}        # Connected on remote machine, via ssh (good).
elif [[ "${DISPLAY%%:0*}" != "" ]]; then
    CNX=${ALERT}        # Connected on remote machine, not via ssh (bad).
else
    CNX=${SCyan}        # Connected on local machine.
fi

# 10.b Test user type
if [[ ${USER} == "root" ]]; then
    SU=${Red}           # User is root.
elif [[ ${USER} != $(logname) ]]; then
    SU=${SRed}          # User is not login user.
else
    SU=${SCyan}         # User is normal (well ... most of us are).
fi

# 10.c CPU's and loads
NCPU=$(grep -c 'processor' /proc/cpuinfo)    # Number of CPUs
SLOAD=$(( 100*${NCPU} ))        # Small load
MLOAD=$(( 200*${NCPU} ))        # Medium load
XLOAD=$(( 400*${NCPU} ))        # Xlarge load

# 10.d Returns system load as percentage, i.e., '40' rather than '0.40)'.
function load()
{
    local SYSLOAD=$(cut -d " " -f1 /proc/loadavg | tr -d '.')   # System load of the current host.
    echo $((10#$SYSLOAD))                                       # Convert to decimal.
}

# 10.e Returns a color indicating system load.
function load_color()
{
    local SYSLOAD=$(load)
    if [ ${SYSLOAD} -gt ${XLOAD} ]; then
        echo -en ${ALERT}
    elif [ ${SYSLOAD} -gt ${MLOAD} ]; then
        echo -en ${Red}
    elif [ ${SYSLOAD} -gt ${SLOAD} ]; then
        echo -en ${SRed}
    else
        echo -en ${Green}
    fi
}

# 10.f Returns a color according to free disk space in $PWD.
function disk_color()
{
    if [ ! -w "${PWD}" ] ; then
        echo -en ${Red}                 # No 'write' privilege in the current directory.
    elif [ -s "${PWD}" ] ; then
        local used=$(command df -P "$PWD" | awk 'END {print $5} {sub(/%/,"")}')
        if [ ${used} -gt 95 ]; then
            echo -en ${ALERT}           # Disk almost full (>95%).
        elif [ ${used} -gt 90 ]; then
            echo -en ${SRed}            # Free disk space almost gone.
        else
            echo -en ${Green}           # Free disk space is ok.
        fi
    else
        echo -en ${Cyan}                # Current directory is size '0' (like /proc, /sys etc).
    fi
}

# 10.g Returns a color according to running/suspended jobs.
function job_color()
{
    if [ $(jobs -s | wc -l) -gt "0" ]; then
        echo -en ${SRed}
    elif [ $(jobs -r | wc -l) -gt "0" ] ; then
        echo -en ${SCyan}
    fi
}

# 10.h Adds some text in the terminal frame (if applicable)
# Now we construct the prompt. PROMPT_COMMAND="history -a"
case ${TERM} in
    *term | rxvt | linux)
        PS1="\[\$(disk_color)\][\w]\[${NC}\]\n"                                 # PWD (with 'disk space' info)
        PS1=${PS1}"${Gray}(\[\$(load_color)\]\A${Gray})\[${NC}\]"               # Time of day (with load info)
        PS1=${PS1}"${Gray}-(\[${SU}\]\u\[${NC}\]@\[${CNX}\]\h${Gray})\[${NC}\]" # User@Host (with connection type info)
        PS1=${PS1}"\[\$(job_color)\]->\[${NC}\] "                               # Prompt (with 'job' info)
        PS1=${PS1}"\[\e]0;(\A)-(\u@\h) -> \w\a"                                 # Set title of current xterm
        ;;
    *)
        PS1="(\A \u@\h \W) > "                                  # --> PS1="(\A \u@\h \w) > "
        ;;                                                      # --> Shows full pathname of current dir.
esac

export TIMEFORMAT=$'\nreal %3R\tuser %3U\tsys %3S\tpcpu %P\n' export HISTIGNORE="&:bg:fg:ll:h"
export HISTTIMEFORMAT="$(echo -e ${SCyan})[%d/%m %H:%M:%S]$(echo -e ${NC}) "
export HISTCONTROL=ignoredups
export HOSTFILE=$HOME/.hosts    # Put a list of remote hosts in ~/.hosts

# 10.i for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
export HISTSIZE=1000
export HISTFILESIZE=2000



# ============================================================== #
#
# 11. Alias and functions
#
# ============================================================== #

# 11.a clear console
alias c='clear'
# 11.b safe file management
alias rm='rm -i'
alias cp='cp -iv'
alias mv='mv -i'
# 11.c Prevents accidentally clobbering files
alias mkdir='mkdir -p'
alias h='history'
alias j='jobs -l'
alias which='type -a'
# 11.d quick directory movement
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ....='cd ../../../..'
# 11.e go to the last directory you were in
alias back="cd ${OLDPWD}"
# 11.f ls aliases
alias ls='ls -h --color'
alias ll="ls -lv --group-directories-first"
alias la='ls -lA --color'
alias lx='ls -lXB'         #  Sort by extension.
alias lk='ls -lSr'         #  Sort by size, biggest last.
alias lt='ls -ltr'         #  Sort by date, most recent last.
alias lc='ls -ltcr'        #  Sort by/show change time,most recent last.
alias lu='ls -ltur'        #  Sort by/show access time,most recent last.
alias lm='ll |more'        #  Pipe through 'more'
alias lr='ll -R'           #  Recursive ls.
alias la='ll -A'           #  Show hidden files.
alias tree='tree -Csuh'    #  Nice alternative to 'recursive ls' ...
# 11.g Pretty-print of some PATH variables
alias path='echo -e ${PATH//:/\\n}'
alias libpath='echo -e ${LD_LIBRARY_PATH//:/\\n}'
# 11.h Makes a more readable output
alias du='du -kh'
alias df='df -kTh'
# 11.i quickly source the .bashrc file || remove .bashrc and nano
alias srcbash='. ~/.bashrc'
alias rebash='rm ~/.bashrc && nano ~/.bashrc'
alias runbash='source ~/.bashrc'
# 11.k update and upgrade system
alias updateSystem='sudo yum update && sudo yum -y upgrade'



# ============================================================== #
#
# 12. File & strings related functions
#
# ============================================================== #

# 12.a Find a file with a pattern in name
function ff() { find . -type f -iname '*'"$*"'*' -ls ; }

# 12.b Find a file with pattern $1 in name and Execute $2 on it
function fe() { find . -type f -iname '*'"${1:-}"'*' \
-exec ${2:-file} {} \;  ; }

# 12.c Swap 2 filenames around, if they exist (from Uzi's bashrc)
function swap()
{
    local TMPFILE=tmp.$$

    [ $# -ne 2 ] && echo "swap: 2 arguments needed" && return 1
    [ ! -e $1 ] && echo "swap: $1 does not exist" && return 1
    [ ! -e $2 ] && echo "swap: $2 does not exist" && return 1

    mv "$1" $TMPFILE
    mv "$2" "$1"
    mv $TMPFILE "$2"
}

# 12.d Handy Extract Program
function extract()
{
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xvjf $1     ;;
            *.tar.gz)    tar xvzf $1     ;;
            *.bz2)       bunzip2 $1      ;;
            *.rar)       unrar x $1      ;;
            *.gz)        gunzip $1       ;;
            *.tar)       tar xvf $1      ;;
            *.tbz2)      tar xvjf $1     ;;
            *.tgz)       tar xvzf $1     ;;
            *.zip)       unzip $1        ;;
            *.Z)         uncompress $1   ;;
            *.7z)        7z x $1         ;;
            *)           echo "'$1' cannot be extracted via >extract<" ;;
        esac
    else
        echo "'$1' is not a valid file!"
    fi
}

# 12.e Creates an archive (*.tar.gz) from given directory
function maketar() { tar cvzf "${1%%/}.tar.gz"  "${1%%/}/"; }

# 12.f Create a ZIP archive of a file or folder
function makezip() { zip -r "${1%%/}.zip" "$1" ; }

# 12.g Make your directories and files access rights sane
function sanitize() { chmod -R u=rwX,g=rX,o= "$@" ;}



# ============================================================== #
#
# 13. Process/system related functions
#
# ============================================================== #

# 13.a My personal system information
function my_ps() { ps $@ -u $USER -o pid,%cpu,%mem,bsdtime,command ; }
function pp() { my_ps f | awk '!/awk/ && $0~var' var=${1:-".*"} ; }

# 13.b Get IP adress on ethernet
function my_ip()
{
    MY_IP=$(/sbin/ifconfig eth0 | awk '/inet/ { print $2 } ' |
      sed -e s/addr://)
    echo ${MY_IP:-"Not connected"}
}

# 13.c Get current host related info
function ii()
{
    echo -e "\nYou are logged on ${SRed}$HOST"
    echo -e "\n${SRed}Additionnal information:$NC " ; uname -a
    echo -e "\n${SRed}Users logged on:$NC " ; w -hs |
             cut -d " " -f1 | sort | uniq
    echo -e "\n${SRed}Current date :$NC " ; date
    echo -e "\n${SRed}Machine stats :$NC " ; uptime
    echo -e "\n${SRed}Memory stats :$NC " ; free
    echo -e "\n${SRed}Diskspace :$NC " ; mydf / $HOME
    echo -e "\n${SRed}Local IP Address :$NC" ; my_ip
    echo -e "\n${SRed}Open connections :$NC "; netstat -pan --inet;
    echo
}



# ============================================================== #
#
# 14. Misc utilities
#
# ============================================================== #

# 14.a Repeat n times command
function repeat()
{
    local i max
    max=$1; shift;
    for ((i=1; i <= max ; i++)); do  # --> C-like syntax
        eval "$@";
    done
}

# 14.b ask question
function ask()
{
    echo -e "$@" '[y/n] ' ; read ans
    case "$ans" in
        y*|Y*) return 0 ;;
        *) return 1 ;;
    esac
}

# 15. add bitbucket ssh key
SSH_ENV=/root/.ssh/environment
# start the ssh-agent
function start_agent {
    if [[ ${USER} != "root" ]]; then
        return;
    fi

    echo "Initializing new SSH agent..."
    # spawn ssh-agent
    /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
    echo succeeded
    chmod 600 "${SSH_ENV}"
    . "${SSH_ENV}" > /dev/null
    /usr/bin/ssh-add
}
if [ -f "${SSH_ENV}" ]; then
     . "${SSH_ENV}" > /dev/null
     ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
        start_agent;
    }
else
    start_agent;
fi



# 16. Echo management
# @param string [message]
# @param string [type:banner,slant,mini] [optional]
# @param string [color in general.sh] [optional]
# @param string [secondMessage] [optional]
function _echo()
{
    echo -e "\n";

    secondMessage=${PWD}
    if [[ ! -z $4 ]]; then
        secondMessage="$4";
    fi

    if [ -z ${isEchoMessage} ]; then
        # normal message
        color=White;
        if [ ! -z $3 ]; then
            color=$3;
        fi
        eval "color=$"${color};

        echo -e "#####\n#"
        echo -e "# ${color}$1${White} - ${Blue}${On_Cyan} ${secondMessage} ${NC}";
        echo -e "#\n#####\n"
    else
        # figlet message
        type=slant
        if [ ! -z $2 ]; then
            type=$2
        fi
        echoMessage "$1" ${type}
        echo -e "${Blue}${On_Cyan} ${secondMessage} ${NC}\n";
    fi
    # by eren mustafa ozdal message
#    echo -e "\n\n${SPurple}by erenMustafaOzdal${White} -> ${Purple}${On_White} eren.060737@gmail.com ${NC}\n";
}



# 17. Combine elements with a specific bracket (join)
function _join {
    local d=$1;
    shift;
    echo -n "$1";
    shift;
    printf "%s" "${@/#/$d}";
}



# ============================================================== #
#
# 18. Some directory functions
#
# ============================================================== #

# 18.a go to
# @param string [directory path]
function GoTo()
{
    if [ -d $1 ]; then
        cd $1
        _echo "Go to" small Yellow $1
    else
        _echo "ERROR: It's not directory" banner Yellow $1
        exit;
    fi
}
alias gt=GoTo

# 18.b go to project
# @param string [project name]
function GoToProject()
{
    local directory="/var/www/projects";
    if [ ! -z ${projectRootDirectory} ]; then
        directory=${projectRootDirectory};
    fi
    gt "${directory}/$1";
}
alias gtp=GoToProject

# 18.c go to site root
# @param string [site name] [for cPanel]
function goToSiteRoot()
{
    gt "/home/$1";
}
alias gtsr=goToSiteRoot

# 18.d go to site
# @param string [site name] [for cPanel]
function goToSite()
{
    gt "/home/$1/public_html";
}
alias gts=goToSite

# 18.e remove all files in public_html
function removeSitePublicHtml()
{
    rm -rfv public_html
    _echo "Removed public html" slant Yellow
}
alias rsph=removeSitePublicHtml

# 18.f make public_html directory
# @param string [site name] [for cPanel]
function makeSitePublicHtml()
{
    mkdir public_html
    chown -R $1:nobody public_html
    _echo "Make and chown public html directory" slant Yellow $1
}
alias msph=makeSitePublicHtml


# Local Variables:
# mode:shell-script
# sh-shell:bash
# End:
