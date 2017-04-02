<?php


class ModulesByTopic extends Controller
{

    public static $url_handlers = array(
        '$Vendor!/$Name!' => 'topic'
    );

    public static $allowed_actions = array(
        'index',
        'topic'
    );

    function init()
    {
        Requirements::customCSS('
body {
    max-width: 900px;
    margin: 20px auto 200px auto;
    color: #808383;
    font-family: lato;
}

h1, h2, h3, h4, h5, h6 {
    font-family: Voces;
}

h1 {
    font-size: 5vh;
    color: #ffcc1a;
    text-align: center;
}

h2 {
    padding-top: 4vh;
    font-size: 3vh;
    color: #838080;
}
.topic.opened h2 {
    color: #FF336D;
}

li {
    padding: 0.5em 0 0.5em 0;
}
li.hide {display: none;}

a {
    color: #808383;
    border-bottom: 1px solid #ffcc1a;
    text-decoration: none;
}

ul, div, main, footer {
    clear: both;
}
.action-p {
    float: right;
}
.action-p a{
    display: block;
    height: 48px;
    width: 48px;
}
.show-all a,
.back-to-top a  {
    background-size: contain;
    text-indent: -9999px;
    border-bottom: 0;
}
.show-all.closed a {
    background-image: url(\'data:image/svg+xml;charset=UTF-8,<svg xmlns="http://www.w3.org/2000/svg" fill="%233498db" height="48" viewBox="0 0 24 24" width="48"><path d="M16.59 8.59L12 13.17 7.41 8.59 6 10l6 6 6-6z"/><path d="M0 0h24v24H0z" fill="none"/></svg>\');
}
.show-all.opened a {
    background-image: url(\'data:image/svg+xml;charset=UTF-8,<svg xmlns="http://www.w3.org/2000/svg" fill="%23FF336D" height="48" viewBox="0 0 24 24" width="48"><path d="M12 8l-6 6 1.41 1.41L12 10.83l4.59 4.58L18 14z"/><path d="M0 0h24v24H0z" fill="none"/></svg>\');
}
.back-to-top a {
    background-image: url(\'data:image/svg+xml;charset=UTF-8,<svg xmlns="http://www.w3.org/2000/svg" fill="%23838080" height="48" viewBox="0 0 24 24" width="48"><path d="M8 11h3v10h2V11h3l-4-4-4 4zM4 3v2h16V3H4z"/><path d="M0 0h24v24H0z" fill="none"/></svg>\');
}

        ');
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
        return $this->renderWith('ModulesByTopic');
    }

    function topic($request)
    {
        return $this->renderWith('ModulesByTopic');
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

}
