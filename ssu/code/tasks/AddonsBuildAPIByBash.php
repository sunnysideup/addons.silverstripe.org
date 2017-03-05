<?php


class AddonsBuildAPIByBash extends BuildTask
{
    protected $title = 'Build Add-ons APIs using a bash script';

    protected $description = 'Create Bash Script for building API documentation for all packages';

    protected $numberOfSteps = 999;

    protected $reposPerStep = 100;

    protected $destinationFile = '/var/www/docs.ssmods.com/process/run.sh';

    public function run($request)
    {

        $count = 0;
        $ghs = '';
        $vds = '';
        $mns = '';
        for ($i = 0; $i < $this->numberOfSteps; $i++) {
            $start = $i * $this->reposPerStep;
            $addons = Addon::get()->limit($this->reposPerStep, $start);
            echo "======================================================\n\n";
            if($addons->count() == 0) {
                $i = 999999;
            }
            foreach ($addons as $addon) {
                $version = $addon->MasterVersion();
                if (!$version) {
                    $version = $addon->Versions()->first();
                }
                $vendorAndName = explode('/', $addon->Name);
                if(
                    isset($vendorAndName[0]) &&
                    isset($vendorAndName[1]) &&
                    isset($version->SourceUrl)
                ) {
                    echo $count;
                    $count++;
                    $ghs .= "\ngh[$count]=\"".$version->SourceUrl."\"";
                    $vds .= "\nvd[$count]=\"".$vendorAndName[0]."\"";
                    $mns .= "\nmn[$count]=\"".$vendorAndName[1]."\"";
                }
                else {
                    $ghs .= '# ERROR GETTING: '.$addon->Name;
                }
            }
        }
        $bash =
'#!/bin/bash

echo "======================================================";
echo "======================================================";
echo "======================================================";

date

echo "======================================================";
echo "======================================================";
echo "======================================================";

cd /var/www/docs.ssmods.com/process
echo "====================================================== setting variables";
'.$ghs.'

'.$mns.'

'.$vds.'

for index in ${!gh[*]}
do
    echo "====================================================== starting loop";
    rm ./src -rf
    rm ./build -rf
    rm ./docs -rf
    echo "====================================================== cloning git repo";
    printf "%4d: %s\n" $index ${mn[$index]}
    echo "====================================================== cloning git repo";
    git clone ${gh[$index]} ./src
    echo "====================================================== running phpdox";
    phpdox
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
';
        if(is_writable($this->destinationFile)) {
            file_put_contents($this->destinationFile, $bash);
        } else {
            echo "<hr /><pre>";
            echo $bash;
            echo "</pre><hr />";
        }
    }
}
