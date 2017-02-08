<?php


class AddonsBuildAPI extends BuildTask
{
    protected $title = 'Build Add-ons APIs';

    protected $description = 'Create API documentation for all packages';

    protected $numberOfSteps = 1;

    protected $reposPerStep = 1;

    public function run($request) {
        $baseDir = Director::baseFolder();
        //make temp dir
        $tempDir = $baseDir.'/temp_git_build/';
        if(file_exists($tempDir)) {
            $this->removeAllFilesAndFolders($tempDir);
        }
        //check destination dir
        $apiDir = $baseDir.'/api/';
        if(!file_exists($apiDir)) {
            mkdir($apiDir);
        }
        for($i = 0; $i < $this->numberOfSteps; $i++) {
            $start = $i * $this->reposPerStep;
            $addons = Addon::get()->limit($this->reposPerStep, $start);
            foreach($addons as $addon) {
                DB::alteration_message($addon->Name);
                $version = $addon->MasterVersion();
                if(!$version) {
                    $version = $addon->Versions()->first();
                }
                //build git clone statement
                $cloneStatement = 'git clone '.$version->SourceUrl.' '.$tempDir;
                DB::alteration_message('.... '.$cloneStatement, 'created');
                chdir($tempDir);
                // Git init
                $gitInit = shell_exec('git init');
                echo $gitInit;
                // Git clone
                $gitClone = shell_exec('git clone '. $version->SourceUrl);
                echo $gitClone;
                // Git pull
                $gitPull = shell_exec('git pull');
                echo $gitPull;
                chdir($baseDir);
                //clone
                //run api tool
                //delete code
                //move api tool data to api/
                //add link to api/index.html
            }
        }
    }

    protected function removeAllFilesAndFolders($dir)
    {
        $di = new RecursiveDirectoryIterator($dir, FilesystemIterator::SKIP_DOTS);
        $ri = new RecursiveIteratorIterator($di, RecursiveIteratorIterator::CHILD_FIRST);
        foreach ( $ri as $file ) {
            $file->isDir() ?  rmdir($file) : unlink($file);
        }
        return true;
    }
}
