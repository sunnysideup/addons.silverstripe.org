<?php


class FavouritesToComposerRecord extends DataObject
{
    public static $db = array(
        "Title" => "Varchar(100)"
    );

    public static $many_many = array(
        "Favourites" => "Addon"
    );

    public static $many_many_extrafields = array(
        'Name' => 'Varchar'
    );

    public static $searchable_fields = array(
        "Title" => "PartialMatchFilter"
    );

    public static $field_labels = array(
        'Title' => 'Request'
    );

    public static $summary_fields = array("Title" => "Name");

    public static $singular_name = "Favourites";

    public static $plural_name = "Favourite";

    //defaults
    public static $default_sort = "\"Created\" DESC";

    public function getCMSFields()
    {
        $fields = parent::getCMSFields();
        return $fields;
    }
}
