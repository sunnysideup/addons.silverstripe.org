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

        // $objects = Addon::get()->filter(array('ID' => $ids))->Sort(array('Name' => 'ASC'));
        $rows = DB::query('
            SELECT "Name" FROM Addon WHERE "Addon"."ID" IN ('.implode(',', $ids).');
        ');
        $al = ArrayList::create();
        foreach($row as $row) {
            $name = $row['Name'];
            $al->push(
                ArrayData::create(
                    array(
                        'Name' => $name,
                        'Spacing' => str_repeat(' ', (60 - strlen($name)))
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
