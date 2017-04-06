<?php


class TopicChange extends DataObject
{
    private static $db = array(
        'AddonName' => 'Varchar'
    );

    private static $has_one = array(
        'Addon' => 'Addon',
        'OldGroup' => 'ExtensionTagGroup',
        'NewGroup' => 'ExtensionTagGroup'
    );

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
                $this->AddonName = $addon->Name;
                $this->write();
                return $this;
            }
        }
        return false;
    }


}
