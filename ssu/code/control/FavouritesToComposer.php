<?php


class FavouritesToComposer extends Controller {

    private static $allowed_actions = array('index');

    function init()
    {
        parent::init();
        $this->getResponse()->addHeader('Content-Type', 'application/json');
    }

    function index($request)
    {
        $json = $this->renderWith('FavouritesToComposer');
        return SS_HTTPRequest::send_file($json, 'composer.json', 'application/json');
    }


    function Addons()
    {
        $ids = $this->request->getVar('ids');
        $ids = explode(',', $ids);
        array_walk($ids, 'intval');

        $objects = Addon::get()->filter(array('ID' => $ids))->Sort(array('Name' => 'ASC'));
        $al = ArrayList::create();
        foreach($objects as $object) {
            $al->push(
                ArrayData::create(
                    array(
                        'Name' => $object->Name,
                        'Spacing' => str_repeat(' ', (60 - strlen($object->Name)))
                    )
                )
            );
        }
        return $al;
    }

    function GDMString ()
    {
        return 'GDM\\\\SSAutoGitIgnore\\\\UpdateScript::Go0';
    }

}
