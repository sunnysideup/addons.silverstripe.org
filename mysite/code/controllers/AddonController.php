<?php
/**
 * Displays information about an add-on and its versions.
 */
class AddonController extends SiteController
{
    public static $allowed_actions = array(
        'index'
    );


    /**
     * Default URL handlers - (Action)/(ID)/(OtherID)
     */
    private static $url_handlers = array(
        '$Vendor//$Module/' => 'handleAction',
    );

    public function handleAction($request, $action)
    {
        // print_r($aa);
        $request = $this->request->param('Vendor') . '/' . $this->request->param('Module');
        $this->addon = Addon::get()
            ->filter(array('Name' => Convert::raw2sql($request)))->first();
        if (! $this->addon) {
            return $this->httpError(404, 'Not found');
        }
        return $this->renderWith(array('Addon', 'Page'));
    }

    public function Title()
    {
        return $this->addon->Name;
    }

    public function Link()
    {
        return $this->addon->Link();
    }

    public function Addon()
    {
        return $this->addon;
    }
}
