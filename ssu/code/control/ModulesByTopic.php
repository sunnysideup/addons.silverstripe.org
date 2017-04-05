<?php


class ModulesByTopic extends Controller
{

    public static $url_handlers = array(
        '$Topic!' => 'topic',
        '$MetaTopic!' => 'metatopic'
    );

    public static $allowed_actions = array(
        'index',
        'metatopic',
        'topic'
    );

    function init()
    {
        Requirements::themedCSS('ModulesByTopic.min', 'mysite');
        Requirements::insertHeadTags('
        <script
          src="https://code.jquery.com/jquery-3.2.1.slim.min.js"
          integrity="sha256-k2WSCIexGzOj3Euiig+TlR8gA0EmPjuc79OEeY5L45g="
          crossorigin="anonymous"></script>

          <link href="http://fonts.googleapis.com/css?family=Voces" rel="stylesheet" type="text/css" />

          <link href="http://fonts.googleapis.com/css?family=Lato" rel="stylesheet" type="text/css" />
         ');
        parent::init();
    }

    function index()
    {
        $objects = ExtensionTagGroup::get();
        foreach($objects as $object) {
            $object->write();
        }
        return $this->renderWith('ModulesByTopic');
    }

    function topic($request)
    {
        return $this->renderWith('ModulesByTopic');
    }

    function metatopic($request)
    {
        return $this->renderWith('ModulesByTopic');
    }

    function MetaTopics()
    {
        return MetaExtensionTagGroup::get();
    }

    function Title()
    {
        return 'Silverstripe Modules by area of interest';
    }

    function Topics()
    {
        return ExtensionTagGroup::get();
    }


    function RestAddons()
    {
        $obj = Injector::inst()->get('ExtensionTagGroup');
        return $obj->RestAddons();
    }


    function LocalNow($format = '')
    {
        return date(DATE_RFC2822);
    }

}
