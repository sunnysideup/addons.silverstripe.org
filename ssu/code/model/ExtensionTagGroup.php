<?php
class ExtensionTagGroup extends DataObject {


    public static $db = array(
        "Title" => "Varchar(100)",
        "Explanation" => "Varchar(255)",
        "Synonyms" => "Text"
    );

    public static $many_many = array(
        "AddonKeywords" => "AddonKeyword"
    );

    public static $searchable_fields = array(
        "Title" => "PartialMatchFilter"
    );

    public static $field_labels = array();

    public static $summary_fields = array("Title" => "Name");

    public static $singular_name = "Tag Group";

    public static $plural_name = "Tag Groups";

    //defaults
    public static $default_sort = "\"Title\" ASC";
    public function Link() {return $this->getLink();}
    public function getLink() {
    }
    public function getCMSFields() {
        $fields = parent::getCMSFields();
        $source = AddonKeyword::get()->sort("Name", "ASC")->map("ID", "Title");
        $fields->replaceField("AddonKeywords", new CheckboxSetField(
             $name = "AddonKeywords",
             $title = "Tags",
             $source
          ));
        return $fields;
    }
}
class ExtensionTagGroup_Admin extends ModelAdmin {
    public static $managed_models = array("ExtensionTagGroup", "AddonKeyword");
    public static $url_segment = 'taggroup';
    public static $menu_title = 'Tag Groups';
    public $showImportForm = false;
}
