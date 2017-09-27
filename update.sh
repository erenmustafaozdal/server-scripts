#!/usr/bin/env bash

# ============================================================== #
#
# General Scripts Update Bash Scripts
# By erenMustafaOzdal [eren.060737@gmail.com]
#
# Last Modified 2017-05-04
#
# CODE INDEX
#   1. general scripts update
#   2. general scripts push
#
# ============================================================== #

# 1. general scripts update
function generalScriptsUpdate()
{
    local directory="/var/www/projects";
    if [ ! -z ${projectRootDirectory} ]; then
        directory=${projectRootDirectory};
    fi
    local path="${projectRootDirectory}/server-scripts/general-scripts";
    if [ ! -z ${generalScriptsPath} ]; then
        path=${generalScriptsPath};
    fi
    cd "${path}";
    gitPull master;
}
alias genUpdate=generalScriptsUpdate;

# 2. general scripts push
# @param string [commit message]
function generalScriptsPush()
{
    local directory="/var/www/projects";
    if [ ! -z ${projectRootDirectory} ]; then
        directory=${projectRootDirectory};
    fi
    local path="${projectRootDirectory}/server-scripts/general-scripts";
    if [ ! -z ${generalScriptsPath} ]; then
        path=${generalScriptsPath};
    fi
    cd "${path}";
    gitCommitPush "$1" master;
}
alias genPush=generalScriptsPush;
