<?php


class AcceptAllTopicChanges extends BuildTask
{
    protected $title = 'Accept All Topic Changes';

    protected $description = 'Apply of All Topic Changes';

    public function run($request)
    {
        $objects = TopicChange::get()->filter(
            array('Completed' => 0)
        );
        foreach($objects as $object){
            $object->write();
        }
    }

}
