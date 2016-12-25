<?php

class ExtensionTagGroup_Admin extends ModelAdmin {

    public static $managed_models = array("ExtensionTagGroup", "AddonKeyword");

    public static $url_segment = 'taggroup';

    public static $menu_title = 'Tag Groups';

    public $showImportForm = false;

}
