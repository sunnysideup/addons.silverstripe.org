<?php

class ExtensionTagGroup_Admin extends ModelAdmin {

    public static $managed_models = array('ExtensionTagGroup', 'AddonKeyword', 'FavouritesToComposerRecord');

    public static $url_segment = 'taggroup';

    public static $menu_title = 'Tag Groups';

    public $showImportForm = false;

    function getEditForm($id = null, $fields = null){
        $form = parent::getEditForm();
        //This check is simply to ensure you are on the managed model you want adjust accordingly
        if($this->modelClass === 'ExtensionTagGroup') {
            if($gridField = $form->Fields()->dataFieldByName($this->sanitiseClassName($this->modelClass))) {
                $gridField->getConfig()->addComponent(new GridFieldSortableRows('SortOrder'));
            }
        }
        return $form;
    }

}
