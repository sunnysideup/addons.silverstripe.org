<?php


class FavouritesToComposer extends Controller
{
    private static $allowed_actions = array('index');

    public function init()
    {
        parent::init();
        $this->getResponse()->addHeader('Content-Type', 'application/json');
    }

    public function index($request)
    {
        $json = $this->renderWith('FavouritesToComposer');
        return SS_HTTPRequest::send_file($json, 'composer.json', 'application/json');
    }


    public function Addons()
    {
        $ids = $this->request->getVar('ids');
        $ids = explode(',', $ids);
        array_walk($ids, 'intval');

        // $objects = Addon::get()->filter(array('ID' => $ids))->Sort(array('Name' => 'ASC'));
        $rows = DB::query('
            SELECT "Addon"."ID", "Name" FROM "Addon" WHERE "Addon"."ID" IN ('.implode(',', $ids).');
        ');
        $myObj = FavouritesToComposerRecord::create();
        $myObj->Title = implode(',', $ids);
        $myObj->write();

        $al = ArrayList::create();
        foreach ($rows as $row) {
            $name = $row['Name'];
            $myObj->Favourites()->add(
                $row["ID"],
                array(
                   'Name' => $name
                )
            );
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

}
