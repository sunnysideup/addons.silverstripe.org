<?php


class TopicChange extends DataObject
{
    private static $db = array(
        'Completed' => 'Boolean',
        'AddonName' => 'Varchar'
    );

    private static $has_one = array(
        'Addon' => 'Addon',
        'OldGroup' => 'ExtensionTagGroup',
        'NewGroup' => 'ExtensionTagGroup',
        'TopicChangeIPAddress' => 'TopicChangeIPAddress'
    );

    private static $summary_fields = array(
        'Completed.Nice' => 'Completed',
        'Created.Ago' => 'Created',
        'AddonName' => 'Name',
        'OldGroup.Title' => 'Old Group',
        'NewGroup.Title' => 'New Group',
        'IsSafeIP' => 'Is Safe'
    );

    private static $casting = array(
        'IsSafeIP' => 'Boolean'
    );

    private static $default_sort = array(
        'Created' => 'DESC'
    );

    public function canCreate($member = null)
    {
        return false;
    }

    public function canEdit($member = null)
    {
        return false;
    }


    public function canView($member = null)
    {
        if (Permission::checkMember($member, "CMS_ACCESS_EDIT_KEYWORDS")) {
            return true;
        }
        return parent::canEdit($member);
    }


    public function canDelete($member = null)
    {
        if ($this->Completed) {
            return false;
        }

        return $this->canView($member);
    }


    public function getCMSFields()
    {
        $fields = parent::getCMSFields();
        $fields->removeByName('AddonID');
        $fields->addFieldsToTab(
            'Root.Main',
            array(
                ReadonlyField::create(
                    'Created',
                    'Created'
                ),
                ReadonlyField::create(
                    'IsSafeIP',
                    'IsSafeIP',
                    $this->getIsSafeIP()->Nice()
                ),
                LiteralField::create(
                    'RunAll',
                    '<h2><a href="/dev/tasks/AcceptAllTopicChanges">Update All</a></h2>'
                )
            )
        );
        return $fields;
    }

    /**
     * Event handler called before writing to the database.
     */
    public function onBeforeWrite()
    {
        parent::onBeforeWrite();
        if (! $this->AddonName) {
            $addon = Addon::get()->byID($this->AddonID);
            if ($addon) {
                $this->AddonName = $addon->Name;
            }
        }
    }

    /**
     * Event handler called after writing to the database.
     */
    public function onAfterWrite()
    {
        parent::onAfterWrite();

        if ($this->Completed) {
            //do nothing...
        } else {
            if ($this->getIsSafeIP()->raw()) {
                $addon = Addon::get()->byID($this->AddonID);
                if ($addon) {
                    $oldCategory = ExtensionTagGroup::get()->byID($this->OldGroupID);
                    $newCategory = ExtensionTagGroup::get()->byID($this->NewGroupID);
                    if ($oldCategory) {
                        $oldCategory->ExcludedOnes()->remove($addon);
                    }
                    if ($newCategory) {
                        $newCategory->AdditionalOnes()->add($addon);
                    }
                    $this->Completed = true;
                    $this->write();
                }
            }
        }
    }

    public function RegisterChange($id, $oldOne, $newOne)
    {
        $id = intval($id);
        if ($id) {
            $addon = Addon::get()->byID($id);
            if ($addon) {
                $oldCategory = ExtensionTagGroup::get()->byID(intval($oldOne));
                $newCategory = ExtensionTagGroup::get()->byID(intval($newOne));
                if ($oldCategory) {
                    $this->OldGroupID = $oldCategory->ID;
                }
                if ($newCategory) {
                    $this->NewGroupID = $newCategory->ID;
                } else {
                    return false;
                }
                $this->AddonID = $id;
                $this->AddonName = $addon->Name;
                $topicChangeIPAddress = TopicChangeIPAddress::find_or_make();
                $this->TopicChangeIPAddressID = $topicChangeIPAddress->ID;
                $this->write();
                return $this;
            }
        }
        return false;
    }

    public function IsSafeIP()
    {
        return $this->getIsSafeIP();
    }

    public function getIsSafeIP()
    {
        $obj = $this->TopicChangeIPAddress();
        if ($obj && $obj->exists()) {
            $outcome = $obj->SafeIP;
        } else {
            $outcome = false;
        }

        return DBField::create_field('Boolean', $outcome);
    }
}
