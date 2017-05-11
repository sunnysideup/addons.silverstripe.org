#!/bin/bash

gh[1]="https://github.com/comperio/silverstripe-framework"


mn[1]="silverstripe-framework"


vd[1]="comperio"

for index in ${!gh[*]}
    do
        echo "====================================================== starting loop";
        git clone ${gh[$index]} ./src
    done

mkdir temp
composer create-project silverstripe/installer ./temp --no-dev
cd temp
rm themes/ -rf
mkdir themes
