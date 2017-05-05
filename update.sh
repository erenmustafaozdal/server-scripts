#!/usr/bin/env bash

# ============================================================== #
#
# General Scripts Update Bash Scripts
# By erenMustafaOzdal [eren.060737@gmail.com]
#
# Last Modified 2017-05-04
#
# CODE INDEX
#   1. ezelnet scripts update
#
# ============================================================== #

# 1. general scripts update
function generalScriptsUpdate()
{
    local path="/var/www/projects/server-scripts/general-scripts";
    if [ ! -z ${generalScriptsPath} ]; then
        path=${generalScriptsPath};
    fi
    cd ${path};
    gitPull master;
}
alias genUpdate=generalScriptsUpdate;

# 2. general scripts push
# @param string [commit message]
function generalScriptsPush()
{
    local path="/var/www/projects/server-scripts/general-scripts";
    if [ ! -z ${generalScriptsPath} ]; then
        path=${generalScriptsPath};
    fi
    cd ${path};
    gitCommitPush "$1" master;
}
alias genPush=generalScriptsPush;