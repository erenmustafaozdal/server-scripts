#!/usr/bin/env bash

# ============================================================== #
#
# GIT Bash Scripts
# By erenMustafaOzdal [eren.060737@gmail.com]
#
# Last Modified 2017-05-01
#
# CODE INDEX
#   1. git status
#   2. git branch
#   3. git checkout
#   4. git commit
#   5. git push
#   6. git create branch
#   7. git create branch and switch
#   8. git delete branch
#   9. git pull
#   10. git commit and push
#   11. git merge branch
#   12. git merge and delete branch
#   13. git commit, merge and delete branch
#   14. git commit and merge branch
#   15. git commit, merge branch, delete branch and push
#   16. git commit, merge branch and push two branches
#   17. git merge branch and push
#   18. git init
#
# ============================================================== #

# 1. git status
function gitStatus() {
    git status
    _echo "Git Status" small Yellow
}
alias gs=gitStatus

# 2. git branch
# @param string [branch] [optional]
# @otherParams string [types] [optional]
function gitBranch() {
    local message="Git Branches";

    local branch=""
    if [[ ! -z $1 ]]; then
        branch=$1;
        message="Branch Delete";
        shift;
    fi

    local types=$(_join " -" "$@");
    if [[ ! -z ${types} ]]; then
        types="-${types}";
    fi

    git branch ${types} ${branch}
    _echo "${message}" small Yellow ${branch}
}
alias gb=gitBranch

# 3. git checkout
# @param string [checkout branch]
# @otherParams string [types] [optional]
function gitCheckout() {
    message="Checkout Branch";
    branches=$1;
    if [ ! -z $2 ]; then
        branches="${branches} $2";
        message="Checkout New Branch";
        shift;
    fi
    shift;

    types=$(_join " -" "$@");
    if [[ ! -z ${types} ]]; then
        types="-${types}";
    fi

    git checkout ${types} ${branches}

    secondMessage=$(_join " - " ${branches})
    _echo "${message}" small Yellow "${secondMessage}"
}
alias gcheck=gitCheckout

# 4. git commit
# @param string [commit message]
function gitCommit() {
    git add -A
    git commit -m "$1"
    _echo "Git Commit" small Yellow
}
alias gc=gitCommit

# 5. git push
# @param string [push branch]
function gitPush() {
    git push origin $1
    _echo "Git Pushed" small Yellow " ${Red}${On_Cyan}Branch: ${Blue}${On_Cyan} ($1) "
}
alias gp=gitPush

# 6. git create branch
# @param string [new branch]
# @param string [from branch]
function gitCreateBranch() {
    gcheck $1 $2 b      # b=type
    gcheck $2           # return from branch
    gb                  # show git branches
    _echo "Git Branch Created" slant Yellow "( $2 -> $1 )"
}
alias gcb=gitCreateBranch

# 7. git create branch and switch
# @param string [new branch]
# @param string [from branch]
function gitCreateBranchSwitch() {
    gcheck $1 $2 b      # b=type
    gb                  # show git branches
    _echo "Git Branch Created and Switch" slant Yellow "( $2 -> $1 )"
}
alias gcbs=gitCreateBranchSwitch

# 8. git delete branch
# @param string [delete branch]
# @param string [go branch] [optional]
function gitDeleteBranch() {
    local go=master
    if [ ! -z $2 ]; then
        go=$2
    fi

    gcheck ${go}
    gb $1 D
    _echo "Git Branch Delete" slant Yellow "$1"
}
alias gdb=gitDeleteBranch

# 9. git pull
# @param string [pull from branch]
function gitPull() {
    git pull origin $1
    _echo "Git Pull" small Yellow " ${Red}${On_Cyan}From Branch: ${Blue}${On_Cyan} ($1) "
}
alias gpull=gitPull

# 10. git commit and push
# @param string [commit message]
# @param string [push branch]
function gitCommitPush() {
    gc "$1"
    gp $2
}
alias gcp=gitCommitPush

# 11. git merge branch
# @param string [to branch]
# @param string [from branch]
# @param string [-r] [return from]
function gitMerge() {
    gcheck $1
    git merge $2
    if [[ ! -z $3 && $3 == '-r' ]]; then
        gcheck $2
    fi
    _echo "Git Merged" slant Yellow " ${Red}${On_Cyan}Branches: ${Blue}${On_Cyan} ( $2 -> $1 ) "
}
alias gm=gitMerge

# 12. git merge and delete branch
# @param string [to branch]
# @param string [from branch - delete branch]
function gitMergeDeleteBranch() {
    gm $1 $2
    gdb $2 $1
}
alias gmd=gitMergeDeleteBranch

# 13. git commit, merge and delete branch
# @param string [commit message]
# @param string [commit branch - delete branch]
# @param string [merge branch]
function gitCommitMergeDeleteBranch() {
    gc "$1"
    gmd $3 $2
}
alias gcmd=gitCommitMergeDeleteBranch

# 14. git commit and merge branch
# @param string [commit message]
# @param string [commit branch]
# @param string [merge branch]
function gitCommitMerge() {
    gc "$1"
    gm $3 $2
}
alias gcm=gitCommitMerge

# 15. git commit, merge branch, delete branch and push
# @param string [commit message]
# @param string [commit branch - delete branch]
# @param string [merge branch]
function gitCommitMergeDeleteBranchAndPush() {
    gcmd "$1" $2 $3
    gp $3
}
alias gcmdp=gitCommitMergeDeleteBranchAndPush

# 16. git commit, merge branch and push two branches
# @param string [commit message]
# @param string [commit branch]
# @param string [merge branch]
function gitCommitMergeBranchAndPushes() {
    gcp "$1" $2
    gm $3 $2
    gp $3
    gcheck $2
}
alias gcmp=gitCommitMergeBranchAndPushes

# 17. git merge branch and push
# @param string [from branch]
# @param string [merge branch]
function gitMergeAndPushes() {
    gm $2 $1
    gp $2
    gcheck $1
}
alias gmp=gitMergeAndPushes

# 18. git init
# @param string [repository]
function gitInit() {
    git init
    git remote add origin "$1"
    _echo "Git init" slant Yellow "$1"
}
alias gi=gitInit