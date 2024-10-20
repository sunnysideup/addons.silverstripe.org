<?php
/**
 * A keyword which is attached to add-ons and versions.
 */
class AddonKeyword extends DataObject
{
    public static $db = array(
        'Name' => 'Varchar(255)',
        'AddonCount' => 'Int',
        'GroupCount' => 'Int',
        'Ignore' => 'Boolean'
    );

    public static $belongs_many_many = array(
        'Addons' => 'Addon',
        'Versions' => 'AddonVersion',
        'ExtensionTagGroups' => 'ExtensionTagGroup'
    );

    private static $summary_fields = array(
        'Name' => 'Name',
        'AddonCount' => 'Addons',
        'GroupCount' => 'Groups',
        'Ignore.Nice' => 'Ignore'
    );

    private static $searchable_fields = array(
        'Name' => 'PartialMatchFilter',
        'AddonCount' => 'PartialMatchFilter',
        'GroupCount' => 'PartialMatchFilter',
        'Ignore' => 'PartialMatchFilter'
    );

    /**
     * Gets a keyword object by name, creating one if it does not exist.
     *
     * @param string $name
     * @return AddonKeyword
     */
    public static function get_by_name($name)
    {
        $name = strtolower($name);
        $kw = AddonKeyword::get()->filter('Name', $name)->first();

        if (!$kw) {
            $kw = new AddonKeyword();
            $kw->Name = $name;
            $kw->write();
        }

        return $kw;
    }

    /**
     * Event handler called before writing to the database.
     */
    public function onBeforeWrite()
    {
        parent::onBeforeWrite();
        if ($this->exists()) {
            $this->AddonCount = $this->Addons()->count();
            $this->GroupCount = $this->ExtensionTagGroups()->count();
        }
    }

    public function canCreate($member = null)
    {
        return $this->canEdit($member);
    }

    public function canView($member = null)
    {
        return $this->canEdit($member);
    }

    public function canEdit($member = null)
    {
        if (Permission::checkMember($member, "CMS_ACCESS_EDIT_KEYWORDS")) {
            return true;
        }
        return parent::canEdit($member);
    }

    public function canDelete($member = null)
    {
        return $this->Addons()->count() > 0 ? false : $this->canEdit($member);
    }
}
