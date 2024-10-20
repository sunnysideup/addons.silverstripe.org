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

    public function init()
    {
        Requirements::themedCSS('ModulesByTopic.min', 'mysite');
        Requirements::javascript('https://code.jquery.com/jquery-3.2.1.min.js');
        Requirements::insertHeadTags('
          <link href="http://fonts.googleapis.com/css?family=Voces" rel="stylesheet" type="text/css" />

          <link href="http://fonts.googleapis.com/css?family=Lato" rel="stylesheet" type="text/css" />
         ');
        parent::init();
    }

    public function index()
    {
        $objects = ExtensionTagGroup::get();
        foreach ($objects as $object) {
            $object->write();
        }
        return $this->renderWith('ModulesByTopic');
    }

    public function topic($request)
    {
        return $this->renderWith('ModulesByTopic');
    }

    public function metatopic($request)
    {
        return $this->renderWith('ModulesByTopic');
    }

    public function MetaTopics()
    {
        return MetaExtensionTagGroup::get();
    }

    public function Title()
    {
        return 'Silverstripe Modules by area of interest';
    }

    public function Topics()
    {
        return ExtensionTagGroup::get();
    }


    public function RestAddons()
    {
        $obj = Injector::inst()->get('ExtensionTagGroup');
        return $obj->RestAddons();
    }


    public function LocalNow($format = '')
    {
        return date(DATE_RFC2822);
    }


    public function ChangeTopicFormAction()
    {
        if (Director::isDev()) {
            return '/change-topic.php';
        } else {
            return 'http://topics.ssmods.com/change-topic.php';
        }
    }
}
