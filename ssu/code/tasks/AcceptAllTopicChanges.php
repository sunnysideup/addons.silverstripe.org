<?php


class AcceptAllTopicChanges extends BuildTask
{
    protected $title = 'Accept All Topic Changes';

    protected $description = 'Apply of All Topic Changes';

    public function run($request)
    {
        set_time_limit(600);
	
	echo '------------------------------';
        //AddonKeyword
        $objects = AddonKeyword::get()
            ->exclude(array('Ignore' => 1));
        foreach($objects as $object){
            DB::alteration_message($object->Name);
            $object->write();
        }

        echo '------------------------------';
        //TopicChange
        $objects = TopicChange::get()->filter(
            array('Completed' => 0)
        );
        foreach($objects as $object){
            DB::alteration_message($object->AddonID . ' - '. $object->AddonName);
            $object->write();
        }
	
	echo '------------------------------';
        echo 'DONE';
    }

}
