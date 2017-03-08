<?php


class AddonsBuildAPIByBash extends BuildTask
{
    protected $title = 'Build Add-ons APIs using a bash script';

    protected $description = 'Create Bash Script for building API documentation for all packages';

    protected $numberOfSteps = 999;

    protected $reposPerStep = 100;

    protected $destinationFile = '/var/www/docs.ssmods.com/process/run.sh';

    protected $destinationFile_quick = '/var/www/docs.ssmods.com/process/run_quick.sh';

    public function run($request)
    {

        $count = 0;
        $ghs = '';
        $vds = '';
        $mns = '';
        $count_quick = 0;
        $ghs_quick = '';
        $vds_quick = '';
        $mns_quick = '';
        for ($i = 0; $i < $this->numberOfSteps; $i++) {
            $start = $i * $this->reposPerStep;
            $addons = Addon::get()->limit($this->reposPerStep, $start);
            if($addons->count() == 0) {
                $i = 999999;
            }
            foreach ($addons as $addon) {
                $link = '';
                if($this->isHTTPLink($addon->Repository)) {
                    $link = $addon->Repository;
                } else {
                    $version = $addon->MasterVersion();
                    if (!$version) {
                        $version = $addon->Versions()->first();
                    }
                    if($version) {
                        $link = $version->SourceUrl;
                    }
                }
                $vendorAndName = explode('/', $addon->Name);
                if(
                    isset($vendorAndName[0]) &&
                    isset($vendorAndName[1]) &&
                    $link &&
                    $addon->Type === 'module'
                ) {
                    DB::alteration_message($vendorAndName[0]);
                    DB::alteration_message(' ... '.$vendorAndName[1]);
                    DB::alteration_message(' ... '.$link);
                    $count++;
                    $ghs .= "\ngh[$count]=\"".$link."\"";
                    $vds .= "\nvd[$count]=\"".$vendorAndName[0]."\"";
                    $mns .= "\nmn[$count]=\"".$vendorAndName[1]."\"";
                    if(! $addon->DocLink()) {
                        $count_quick++;
                        $ghs_quick .= "\ngh[$count_quick]=\"".$link."\"";
                        $vds_quick .= "\nvd[$count_quick]=\"".$vendorAndName[0]."\"";
                        $mns_quick .= "\nmn[$count_quick]=\"".$vendorAndName[1]."\"";
                    }
                }
                else {
                    $ghs .= '# ERROR GETTING: '.$addon->Name;
                }
            }
        }
        $bash = $this->getBashScript($ghs, $vds, $mns);
        if(is_writable($this->destinationFile)) {
            file_put_contents($this->destinationFile, $bash);
        } else {
            echo "<hr /><pre>";
            echo $bash;
            echo "</pre><hr />";
        }
        if($count_quick) {
            $bash_quick = $this->getBashScript($ghs_quick, $vds_quick, $mns_quick);
            if(is_writable($this->destinationFile_quick)) {
                file_put_contents($this->destinationFile_quick, $bash_quick);
            } else {
                echo "<hr /><pre>";
                echo $bash_quick;
                echo "</pre><hr />";
            }
        }
    }

    /**
     * is this an HTTP / HTTPS Link or something else?
     * @param  string  $link [description]
     * @return boolean       [description]
     */
    protected function isHTTPLink($link)
    {
        if(
            strpos($link, 'ttp://') === 0 ||
            strpos($link, 'https://') === 0
        ) {
            return true;
        }
        return false;
    }


    protected function getBashScript($ghs, $vds, $mns) 
    {
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
        return $bash;
    }

}
