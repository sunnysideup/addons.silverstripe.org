<?php

global $project;
$project = 'mysite';

SSViewer::set_theme('ssu');

global $database;
if (!defined('SS_DATABASE_NAME')) {
    $database = 'addons';
}

require_once 'conf/ConfigureFromEnv.php';
