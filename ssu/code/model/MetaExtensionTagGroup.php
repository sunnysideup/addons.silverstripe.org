<?php


class MetaExtensionTagGroup extends DataObject {


    private static $db = array(
        "Title" => "Varchar(100)",
        "Explanation" => "Varchar(255)",
        "SortOrder" => "Int"
    );

    private static $has_many = array(
        "Topics" => "ExtensionTagGroup"
    );

    private static $searchable_fields = array(
        "Title" => "PartialMatchFilter"
    );

    private static $field_labels = array();

    private static $summary_fields = array("Title" => "Name");

    private static $singular_name = "Meta Topic";

    private static $plural_name = "Meta Topics";

    private static $default_sort = array(
        'SortOrder' => 'ASC'
    );


    private static $indexes = array(
        'SortOrder' => true
    );

    //defaults
    public function Link() {return $this->getLink();}
    public function getLink() {
    }
    public function getCMSFields() {
        $fields = parent::getCMSFields();
        $fields->removeFieldsFromTab(
            'Root.Main',
            array(
                'SortOrder'
            )
        );
        return $fields;
    }
}
