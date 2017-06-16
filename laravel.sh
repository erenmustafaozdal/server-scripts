#!/usr/bin/env bash

# ============================================================== #
#
# LARAVEL ARTISAN and HELPFUL Bash Scripts
# By erenMustafaOzdal [eren.060737@gmail.com]
#
# Last Modified 2017-05-02
#
# CODE INDEX
#   1. composer init
#   2. set permissions of files and directories
#   3. artisan app init
#   4. artisan migrate
#   5. artisan optimize
#   6. phpunit test
#   7. laravel up install on server
#   8. gulp and laravel modules core vendor publish public tag (MODULES for PRO v1)
#
# ============================================================== #

# 1. composer init
# @param string [type:install,update] [optional,default:install]
function composerInit()
{
    local type=install;
    if [ ! -z $1 ]; then
        type=$1;
    fi
    if [[ ${USER} == "root" ]]; then
        composer self-update
    fi
    composer ${type} --no-plugins --no-scripts
    _echo "Composer ${type} is finished" small Yellow
}
alias ci=composerInit

# 2. set permissions of files and directories
# @param string [linux user]
function setPermissions()
{
    sudo chown -R $1:$1 *
    sudo chmod -R ug+rwx storage bootstrap/cache
    sudo chmod -R 755 public

    # if use html purifier
    local htmlPurifier=vendor/ezyang/htmlpurifier/library/HTMLPurifier/DefinitionCache/Serializer
    if [ -d ${htmlPurifier} ]; then
        sudo chmod 777 ${htmlPurifier}
    fi

    _echo "Set permissions to $1" small Yellow
}
alias sp=setPermissions

# 3. artisan app init
# @param string [type:up,down] [optional,default:up]
function artisanAppInit()
{
    local type=up;
    if [ ! -z $1 ]; then
        type=$1;
    fi
    php artisan ${type}
    _echo "App is ${type}" small Yellow
}
alias aai=artisanAppInit

# 4. artisan migrate
# @param string [type] [optional]
# @otherParams string [options] [optional]
function artisanMigrate()
{
    local command="php artisan migrate"
    local type="";
    if [ ! -z $1 ]; then
        case $1 in
            install | refresh | reset | rollback | status)
                type=$1;
                command="${command}:$1";
                shift;
                ;;
        esac
    fi

    local options=$(_join " --" "$@");
    if [[ ! -z ${options} ]]; then
        options="--${options}";
    fi
    eval "${command} ${options}"
    _echo "Migrate ${type} is finish" small Yellow
}
alias am=artisanMigrate

# 5. artisan optimize
# @param string [clear] [optional]
function artisanOptimize()
{
    local type="";
    if [ ! -z $1 ] && [ $1 == "clear" ]; then
        php artisan cache:clear
        php artisan config:clear
        php artisan route:clear
        php artisan clear-compiled
        type=$1;
    else
        php artisan cache:clear
        php artisan route:cache
        php artisan config:cache
        php artisan optimize --force
        composer dump-autoload --optimize
    fi
    _echo "Optimization ${type} is finish" small Yellow
}
alias ao=artisanOptimize

# 6. phpunit test
# @param string [refresh migration refresh] [optional]
# @param string [result] [optional]
function phpunitTest()
{
    local testFile="./test_result.html";
    if [ ! -z ${testFileName} ]; then
        testFile=${testFileName};
    fi
    rm -rf ${testFile};

    local command="./vendor/bin/phpunit";
    if [ ! -z $1 ] && [ $1 == 'refresh' ]; then
        am refresh env=testing seed
        shift;
    fi
    if [ ! -z $1 ] && [ $1 == 'result' ]; then
        command="${command} --testdox-html=./test_result.html";
    fi
    eval ${command}
    _echo "PhpUnit test is finished" slant Yellow
}
alias pt=phpunitTest

# 7. laravel up install on server
# @param string [install,update]
# @param string [linux user] [optional]
function laravelInit()
{
    if [ $1 == 'update' ]; then
        artisanAppInit down
    fi
    composerInit install
    options="force";
    if [ $1 == 'install' ]; then
        options=${options}" seed"
    fi
    artisanMigrate ${options}
    if [ $1 == 'install' ]; then
        setPermissions $2
    fi
    artisanOptimize
    artisanAppInit up
}

# 8. gulp and laravel modules core vendor publish public tag (MODULES for PRO v1)
# @param string [task] (optional)
function gulpPub() {
    rm -rf /var/www/projects/ezelnet/packages/erenmustafaozdal/laravel-modules-core/public
    rm -rf /var/www/projects/ezelnet/public/vendor/laravel-modules-core
    gtp ezelnet
    gulp $1
    _echo "Gulp is finished" small Yellow
    php artisan vendor:publish --provider="ErenMustafaOzdal\LaravelModulesCore\LaravelModulesCoreServiceProvider" --tag="public" --force
    _echo "Process completed! :)" slant Yellow
}