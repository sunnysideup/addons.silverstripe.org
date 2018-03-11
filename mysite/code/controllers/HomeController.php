<?php
/**
 * The home page controller.
 */
class HomeController extends SiteController
{
    private static $popular_blacklist = array(
        'silverstripe/framework',
        'silverstripe/cms',
        'silverstripe/reports',
        'silverstripe/siteconfig',
        'silverstripe/sqlite3',
        'silverstripe/postgresql',
        'silverstripe-themes/simple'
    );

    public static $allowed_actions = array(
        'index'
    );

    public function index()
    {
        return $this->renderWith(array('Home', 'Page'));
    }

    public function Title()
    {
        return 'Home';
    }

    public function Link()
    {
        return Director::baseURL();
    }

    public function NewestVersions($limit = 10)
    {
        return AddonVersion::get()
            ->filter('Development', false)
            ->sort('Released', 'DESC')
            ->limit($limit);
    }
}
