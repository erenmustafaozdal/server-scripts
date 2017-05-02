#!/usr/bin/env bash

# ============================================================== #
#
# ECHO ALPHABET Bash Scripts
# By erenMustafaOzdal [eren.060737@gmail.com]
#
# Last Modified 2017-05-01
#
# Requirement
#   1. figlet
#       Centos: sudo yum install figlet
#       Ubuntu: sudo apt-get install figlet
#
#       figlet -lt -f slant -C utf8 "Eren Mustafa Özdal"
#       figlet -lt -f banner -C utf8 "Eren Mustafa Özdal"
#       figlet -lt -f small -C utf8 "Eren Mustafa Özdal"
#
# CODE INDEX
#   1. echo message
#
# ============================================================== #

# 1. echo message
# @param string [message]
# @param string [type:banner,slant,mini] [optional]
function echoMessage()
{
    type=slant;
    if [ ! -z $2 ]; then
        type=$2;
    fi
    figlet -lt -f ${type} -C utf8 "$1"
}
alias em=echoMessage
isEchoMessage=1