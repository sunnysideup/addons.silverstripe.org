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
        'AddonName' => 'Name',
        'OldGroup.Title' => 'Old Group',
        'NewGroup.Title' => 'New Group',
        'IP1' => 'IP1',
        'IP2' => 'IP2'
    );

    /**
     * Event handler called before writing to the database.
     */
    public function onBeforeWrite()
    {
        parent::onBeforeWrite();
        if($this->IP1) {
            $this->IP1 = $this->get_client_ip_1();
        }
        if($this->IP2) {
            $this->IP2 = $this->get_client_ip_2();
        }
    }

    /**
     * Event handler called after writing to the database.
     */
    public function onAfterWrite()
    {
        parent::onAfterWrite();

        if($this->IsSafeIP() && ! $this->Completed) {
            $addon = Addon::get()->byID($this->AddOnID);
            if($addon) {
                $oldCategory = ExtensionTagGroup::get()->byID(intval($oldOne));
                $newCategory = ExtensionTagGroup::get()->byID(intval($newOne));
                if($oldCategory) {
                    $oldCategory->ExcludedOnes()->remove($addon);
                }
                if($newCategory) {
                    $newCategory->AdditionalOnes()->add($addon);
                }
                $this->Completed = true;
                $this->write();
            }
        }
    }

    function RegisterChange($id, $oldOne, $newOne)
    {
        $id = intval($id);
        if($id) {
            $addon = Addon::get()->byID($id);
            if($addon) {
                $oldCategory = ExtensionTagGroup::get()->byID(intval($oldOne));
                $newCategory = ExtensionTagGroup::get()->byID(intval($newOne));
                if($oldCategory) {
                    //$oldCategory->ExcludedOnes()->remove($addon);
                    $this->OldGroupID = $oldCategory->ID;
                }
                if($newCategory) {
                    //$newCategory->AdditionalOnes()->add($addon);
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

    function IsSafeIP()
    {
        $obj = $this->TopicChangeIPAddress();
        if($obj && $obj->exists()) {
            $obj->SafeIP;
        }
        return false;
    }

}
