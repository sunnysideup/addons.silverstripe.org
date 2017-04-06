<?php


class ChangeTopic extends Controller
{

    /**
     * Defines methods that can be called directly
     * @var array
     */
    private static $allowed_actions = array(
        'index' => true
    );

    function index($request)
    {
        $id = intval($request->getVar('id'));
        $from = intval($request->getVar('from'));
        $to = intval($request->getVar('to'));
        if($id && $to && ($from || $from === 0)) {
            $obj = TopicChange::create();
            $obj->RegisterChange($id, $from, $to);
            if($obj->exists()) {
                return 'success';
            }
            else {
                $message = 'could not write to database';
            }
        } else {
            $message = 'missing variables.';
        }
        return $this->httpError(405, $message);
    }
}
