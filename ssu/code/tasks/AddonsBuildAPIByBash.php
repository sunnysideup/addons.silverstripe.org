<?php


class AddonsBuildAPIByBash extends BuildTask
{
    protected $title = 'Build Add-ons APIs using a bash script';

    protected $description = 'Create Bash Script for building API documentation for all packages';

    protected $numberOfSteps = 999;

    protected $reposPerStep = 100;

    protected $badApples = array(
        'studiothick/silverstripe-srcset',
        'studiothick/silverstripe-vagrant',
        'wilr/silverstripe-googlemapselectionfield',
        'unclecheese/zero',
        'navidonskis/silverstripe-blocks-accessories',
        'studiobonito/silverstripe-spamprotection-honeypot'
    );

    protected $destinationFile = '/var/www/docs.ssmods.com/process/run.sh';

    protected $destinationFile_quick = '/var/www/docs.ssmods.com/process/run_quick.sh';

    public function run($request)
    {
        $count = 0;
        $ghs = '';
        $vds = '';
        $mns = '';
        $errors = '';
        $count_quick = 0;
        $ghs_quick = '';
        $vds_quick = '';
        $mns_quick = '';
        $errors_quick = '';
        for ($i = 0; $i < $this->numberOfSteps; $i++) {
            $start = $i * $this->reposPerStep;
            $addons = Addon::get()->limit($this->reposPerStep, $start);
            if ($addons->count() == 0) {
                $i = 999999;
            }
            foreach ($addons as $addon) {
                $link = '';
                if ($this->isHTTPLink($addon->Repository)) {
                    $link = $addon->Repository;
                } else {
                    $version = $addon->MasterVersion();
                    if (!$version) {
                        $version = $addon->Versions()->first();
                    }
                    if ($version) {
                        $link = $version->SourceUrl;
                    }
                }
                $error = false;
                $vendorAndName = explode('/', $addon->Name);
                if (
                    isset($vendorAndName[0]) &&
                    isset($vendorAndName[1]) &&
                    $link &&
                    (
                        $addon->Type === 'module' ||
                        $addon->Type === 'vendormodule'||
                        $addon->Type === 'theme' ||
                        $addon->Type === 'recipe'
                    )
                ) {
                    DB::alteration_message('--------------------------------');
                    DB::alteration_message('--------------------------------');
                    DB::alteration_message($vendorAndName[0]);
                    DB::alteration_message(' ... '.$vendorAndName[0]);
                    DB::alteration_message(' ... '.$link);
                    if (strpos($link, 'simon.geek.')) {
                        $errors .= "\n".'# BYPASSING SIMON MODULE: '.$vendorAndName[0].', '.$vendorAndName[1].', '.$link;
                        $error = true;
                    } elseif (in_array($addon->Name, $this->badApples)) {
                        $errors .= "\n".'# BYPASSING BAD APPLE MODULE: '.$vendorAndName[0].', '.$vendorAndName[1].', '.$link;
                        $error = true;
                    } elseif (! $this->urlExists($link)) {
                        $errors .= "\n".'# URL DOES NOT EXIST: '.$vendorAndName[0].', '.$vendorAndName[1].', '.$link;
                        $error = true;
                    } else {
                        $count++;
                        $ghs .= "\ngh[$count]=\"".$link."\"";
                        $vds .= "\nvd[$count]=\"".$vendorAndName[0]."\"";
                        $mns .= "\nmn[$count]=\"".$vendorAndName[1]."\"";
                        if (! $addon->DocLink()) {
                            $count_quick++;
                            $ghs_quick .= "\ngh[$count_quick]=\"".$link."\"";
                            $vds_quick .= "\nvd[$count_quick]=\"".$vendorAndName[0]."\"";
                            $mns_quick .= "\nmn[$count_quick]=\"".$vendorAndName[1]."\"";
                        }
                    }
                } else {
                    $errors .= "\n".'# ERROR GETTING: '.$addon->Name;
                    $error = true;
                }
                if ($error) {
                    $addon->Obsolete = true;
                    $addon->write();
                    DB::alteration_message(' ... OBSOLETE');
                } else {
                    $addon->Obsolete = false;
                    $addon->write();
                    DB::alteration_message(' ... LIVE');
                }
            }
        }
        $bash = $this->getBashScript($ghs, $vds, $mns, $errors);
        if (is_writable($this->destinationFile) || ! file_exists($this->destinationFile)) {
            file_put_contents($this->destinationFile, $bash);
        } else {
            echo "<hr /><pre>";
            echo $bash;
            echo "</pre><hr />";
        }
        if ($count_quick) {
            $bash_quick = $this->getBashScript($ghs_quick, $vds_quick, $mns_quick, $errors_quick);
            if (is_writable($this->destinationFile_quick) || ! file_exists($this->destinationFile_quick)) {
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
        if (
            strpos($link, 'ttp://') === 0 ||
            strpos($link, 'https://') === 0
        ) {
            return true;
        }
        return false;
    }


    protected function getBashScript($ghs, $vds, $mns, $errors)
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

        '.$errors.'

        echo "======================================================";
        echo "======================================================";
        echo "======================================================";

        cd /var/www/docs.ssmods.com/process
        echo "====================================================== setting variables";

        '.$ghs.'

        '.$mns.'

        '.$vds.'
		
		nowsecs=$(date +%s)
		
        for index in ${!gh[*]}
		do
			echo "====================================================== starting loop";
	        printf "%4d: %s\n" $index ${mn[$index]}
			echo "====================================================== ";
	        rm ./src -rf
			rm ./build -rf
			rm ./docs -rf
			echo "====================================================== checking date";
			dira="../public_html"
			dirb="${vd[$index]}"
			dirc="${mn[$index]}"
			dir=$dira/$dirb/$dirc
			modsecs=$(date --utc --reference=$dir +%s)
			delta=$(($nowsecs-$modsecs))
			echo "Dir $dir was modified $delta secs ago"
			# fourteen days!
			min=1209600
			if [ $delta -gt $min ]; then
			   rm $dir -rf
				echo "====================================================== cloning git repo";
				set GIT_TERMINAL_PROMPT=0 git clone ${gh[$index]} ./src || continue; 
				echo "====================================================== running phpdox";
				/usr/local/bin/phpdox
				echo "====================================================== moving";
				rm ./docs/html/index.xhtml
				mkdir $dir -p
				mv ./docs/html/* $dir
			else
				echo "====================================================== no need to redo - too recent";
			fi
        done

        rm ./src -rf
        rm ./build -rf
        rm ./docs -rf
        ';
        return $bash;
    }

    /**
     * Check that given URL is valid and exists.
     * @param string $url URL to check
     * @return bool TRUE when valid | FALSE anyway
     */
    protected function urlExists($url)
    {
        // Remove all illegal characters from a url
        $url = filter_var($url, FILTER_SANITIZE_URL);

        // Validate URI
        if (filter_var($url, FILTER_VALIDATE_URL) === false
            // check only for http/https schemes.
            || !in_array(strtolower(parse_url($url, PHP_URL_SCHEME)), ['http','https'], true)
        ) {
            return false;
        }

        // Check that URL exists
        $file_headers = @get_headers($url);

        return !(!$file_headers || $file_headers[0] === 'HTTP/1.1 404 Not Found');
    }
}
