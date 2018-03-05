<?php
/**
 * The base site controller.
 */
class SiteController extends Controller
{
    public function init()
    {
        RSSFeed::linkToFeed("add-ons/rss", "New modules on addons.silverstripe.org");

        Requirements::block(THIRDPARTY_DIR . '/jquery/jquery.js');
        Requirements::javascript('https://code.jquery.com/jquery-git.min.js');
        // Requirements::javascript("themes/".SSViewer::current_theme()."/javascript/menus.js");

        // Requirements::javascript("themes/".SSViewer::current_theme()."/javascript/addons.js");
        // Requirements::javascript("//www.google.com/jsapi");

        Requirements::themedCSS('layout');

        parent::init();
    }
}
