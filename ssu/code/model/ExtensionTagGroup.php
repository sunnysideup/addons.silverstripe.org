<?php


class ExtensionTagGroup extends DataObject {


    private static $db = array(
        "Title" => "Varchar(100)",
        "Explanation" => "Varchar(255)",
        "AddonsAsText" => "Text",
        "AddonsAsIDs" => "Text",
        "SortOrder" => "Int"
    );

    private static $has_one = array(
        "MetaTopic" => "MetaExtensionTagGroup"
    );

    private static $many_many = array(
        "AddonKeywords" => "AddonKeyword",
        "AdditionalOnes" => "Addon",
        "ExcludedOnes" => "Addon"
    );

    private static $searchable_fields = array(
        "Title" => "PartialMatchFilter",
        "Explanation" => "PartialMatchFilter"
    );

    private static $field_labels = array();

    private static $summary_fields = array("Title" => "Name");

    private static $singular_name = "Topic";

    private static $plural_name = "Topics";

    private static $indexes = array(
        'SortOrder' => true
    );

    private static $default_sort = array(
        'SortOrder' => 'ASC'
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
                'AddonsAsText',
                'AddonsAsIDs',
                'SortOrder'
            )
        );
        if($this->AddonsAsText) {
            $fields->addFieldToTab(
                'Root.Summary',
                GridField::create(
                    'AddonsAsTextSummary',
                    'Included are ...',
                    $this->MyModulesQuick(),
                    GridFieldConfig_RecordEditor::create()
                        ->removeComponentsByType('GridFieldAddNewButton')
                        ->removeComponentsByType('GridFieldDeleteAction')
                )
            );
        }
        return $fields;
    }

    public function onBeforeWrite()
    {
        parent::onBeforeWrite();
        if($this->exists()) {
            $modules = $this->MyModules();
            $this->AddonsAsText = implode(',', $modules->column('Name'));
            $this->AddonsAsIDs = implode(',', $modules->column('ID'));
        }
    }

    /**
    * @return Array
    */
    private static $_covered = array();

    public function MyModulesQuick()
    {
        $array = explode(',', $this->AddonsAsIDs);
        foreach($array as $id) {
            self::$_covered[$id] = $id;
        }

        return Addon::get()->filter(array('ID' => $array))->Sort('RAND()');
    }


    /**
     * @return ArrayList
     */
    public function MyModules()
    {
        $addons = array();
        $excludedOnes = $this->ExcludedOnes()->column('ID');
        $addedOnes = $this->AdditionalOnes()->column('ID');
        $rows = DB::query('
            SELECT ExtensionTagGroup_AddonKeywords.AddonKeywordID AS KWID
            FROM ExtensionTagGroup
                INNER JOIN ExtensionTagGroup_AddonKeywords
                    ON ExtensionTagGroup_AddonKeywords.ExtensionTagGroupID = ExtensionTagGroup.ID
            WHERE ExtensionTagGroup.ID = '.$this->ID.';
        ');
        $keywordIDs = array();
        foreach($rows as $row) {
            $keywordIDs[$row['KWID']] = $row['KWID'];
        }
        if(count($keywordIDs)) {
            $rows = DB::query('
                SELECT AddonID
                FROM Addon_Keywords
                WHERE Addon_Keywords.AddonKeywordID IN ('.implode(',', $keywordIDs).')
            ');
            foreach($rows as $row) {
                $id = $row['AddonID'];
                if(! in_array($id, $excludedOnes))  {
                    $addons[$id] = $id;
                }
            }
        }
        foreach($addedOnes as $addedOne) {
            if(! in_array($id, $excludedOnes))  {
                $addons[$addedOne] = $addedOne;
            }
        }
        if(! count($addons)) {
            $addons[0] = 0;
        }
        foreach($addons as $addon) {
            self::$_covered[$addon] = $addon;
        }
        return Addon::get()->filter(array('ID' => $addons))->sort('RAND()');
    }

    /**
     * @return ArrayList
     */
    function RestAddons()
    {
        $allIDs = Addon::get()->column('ID');
        $toShow = array_diff($allIDs, self::$_covered);
        return Addon::get()->filter(array('ID' => $toShow))->sort('RAND()');
    }

    function SortedKeywords()
    {
        $objects = $this->AddonKeywords();
        $objects = $objects->Sort(array('Name' => 'ASC'));

        return $objects;
    }
}
