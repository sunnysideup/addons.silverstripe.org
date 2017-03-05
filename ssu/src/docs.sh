#!/bin/bash

echo "======================================================";
echo "======================================================";
echo "======================================================";

date

echo "======================================================";
echo "======================================================";
echo "======================================================";

cd /var/www/docs.ssmods.com/process
echo "====================================================== setting variables";
gh[0]="https://github.com/derRobert/silverstripe-chunks.git"
gh[1]="https://github.com/registripe/registripe-addons.git"

mn[0]="silverstripe-chunks"
mn[1]="registripe-addons"

vd[0]="vendor-A"
vd[1]="vendor-B"

for index in ${!gh[*]}
do
    echo "====================================================== starting loop";
    rm ./src -rf
    rm ./build -rf
    rm ./docs -rf
    echo "====================================================== cloning git repo";
    printf "%4d: %s\n" $index ${mn[$index]}
    echo "====================================================== cloning git repo";
    git clone gh[$index] ./src
    echo "====================================================== running phpdox";
    phpdox .
    echo "====================================================== moving";
    dira="../public_html"
    dirb="${vd[$index]}"
    dirc="${mn[$index]}"
    dir=$dira/$dirb/$dirc
    echo $dir
    rm $dir -rf
    mkdir $dir -p
    mv ./docs/html/* $dir
done

rm ./src -rf
rm ./build -rf
rm ./docs -rf
