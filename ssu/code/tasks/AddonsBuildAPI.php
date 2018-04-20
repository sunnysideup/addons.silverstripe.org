<?php


class AddonsBuildAPI extends BuildTask
{
    protected $title = 'Build Add-ons APIs';

    protected $description = 'Create API documentation for all packages';

    protected $numberOfSteps = 1;

    protected $reposPerStep = 1;

    protected $tmpDirName = 'temp_git_build';

    protected $destinationDir = 'api';

    public function run($request)
    {
        ini_set('output_buffering', 'off');
        // Turn off PHP output compression
        ini_set('zlib.output_compression', false);

        //Flush (send) the output buffer and turn off output buffering
        //ob_end_flush();
        while (@ob_end_flush());

        // Implicitly flush the buffer(s)
        ini_set('implicit_flush', true);
        ob_implicit_flush(true);

        //prevent apache from buffering it for deflate/gzip



        $baseDir = Director::baseFolder();
        //make temp dir
        $tempDir = $baseDir.'/'.$this->tmpDirName.'/';

        $phpDocConfigFile = $baseDir.'/ssu/_config_templates/phpdox.xml';
        if (! file_exists($phpDocConfigFile)) {
            DB::alteration_message('ERROR, could not find: '.$phpDocConfigFile, 'created');
        }
        for ($i = 0; $i < $this->numberOfSteps; $i++) {
            $start = $i * $this->reposPerStep;
            $addons = Addon::get()->limit($this->reposPerStep, $start);
            foreach ($addons as $addon) {
                if (file_exists($tempDir)) {
                    $this->removeAllFilesAndFolders($tempDir);
                } else {
                    mkdir($tempDir);
                }
                $this->chmod($tempDir);

                DB::alteration_message($addon->Name);
                $version = $addon->MasterVersion();
                if (!$version) {
                    $version = $addon->Versions()->first();
                }
                //build git clone statement
                $cloneStatement = 'git clone '.$version->SourceUrl.' '.$tempDir;
                DB::alteration_message('.... '.$cloneStatement, 'created');

                chdir($tempDir);
                // Git init
                $gitInit = shell_exec('git init');
                DB::alteration_message('.... '.$gitInit);
                // Git clone
                $gitClone = shell_exec('git clone '. $version->SourceUrl);
                DB::alteration_message('.... '.$gitClone);
                // Git pull
                $gitPull = shell_exec('git pull');
                DB::alteration_message('.... '.$gitPull);

                $phpDox = shell_exec('/usr/local/bin/phpdox -f '.$phpDocConfigFile);
                DB::alteration_message('.... '.$phpDox);

                chdir($baseDir);

                //move api tool data to api/
                $destinationFinalDirs = explode('/', $addon->Name);
                $folder0 = $baseDir . '/'.$this->destinationDir.'/';
                $folder1 = $folder0.$destinationFinalDirs[0];
                $folder2 = $folder1.'/'.$destinationFinalDirs[1];
                for ($i = 0; $i < 3; $i++) {
                    $varName = 'folder'.$i;
                    if ($i < 2) {
                        if (!file_exists($varName)) {
                            mkdir($varName);
                        }
                    } else {
                        if (file_exists($varName)) {
                            unlink($varName);
                        }
                        mkdir($varName);
                    }
                    $this->chmod($varName);
                }
                $fromFolder = $tempDir.'docs/html';
                $toFolder = $folder2;
                $this->moveAll($fromFolder, $toFolder);
                $this->removeAllFilesAndFolders($tempDir);
                DB::alteration_message("--------------------------------------------");
                DB::alteration_message("--------------------------------------------");
                ob_flush();
                flush();
            }
        }
    }

    protected function removeAllFilesAndFolders($dir)
    {
        $di = new RecursiveDirectoryIterator($dir, FilesystemIterator::SKIP_DOTS);
        $ri = new RecursiveIteratorIterator($di, RecursiveIteratorIterator::CHILD_FIRST);
        foreach ($ri as $file) {
            $file->isDir() ?  rmdir($file) : unlink($file);
        }
        return true;
    }

    public function moveAll($src, $dst)
    {
        $dir = opendir($src);
        @mkdir($dst);
        while (false !== ($file = readdir($dir))) {
            if (($file != '.') && ($file != '..')) {
                rename(
                    $src . '/' . $file,
                    $dst . '/' . $file
                );
            }
        }
        closedir($dir);
    }

    public function chmod($pathname)
    {
        $iterator = new RecursiveIteratorIterator(new RecursiveDirectoryIterator($pathname));

        foreach ($iterator as $item) {
            $error = false;
            try {
                chmod($item, 0777);
            } catch (Exception $e) {
                echo 'Could not change chmod for '.$pathname.': ',  $e->getMessage(), "\n";
                $error = true;
            }
            if ($error) {
                die('----end----');
            }
        }
    }
}
