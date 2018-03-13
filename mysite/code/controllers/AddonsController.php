<?php

use Elastica\Query;
use Elastica\Query\Match;
use Symbiote\Elastica\ElasticaService;
use Symbiote\Elastica\ResultList;

/**
 * Lists and searches add-ons.
 */
class AddonsController extends SiteController
{
    public static $url_handlers = array(
        'rss' => 'rss',
        '$Vendor!/$Name!' => 'addon',
        '$Vendor!' => 'vendor',
    );

    public static $allowed_actions = array(
        'index',
        'addon',
        'vendor',
        'rss',
    );

    public static $dependencies = array(
        'ElasticaService' => '%$ElasticaService'
    );

    /**
     * @var \Symbiote\Elastica\ElasticaService
     */
    private $elastica;

    public function index()
    {
        increase_time_limit_to(600);

        $html = $this->renderWith(array('Addons', 'Page'));
        $html = preg_replace("/\s+/", ' ', trim($html));
        $html = str_replace(array('<!-- -->', '//<![CDATA[', '//]]>'), '', $html);
        return $html;
    }

    public function setElasticaService(ElasticaService $elastica)
    {
        $this->elastica = $elastica;
    }

    public function addon($request)
    {
        $vendor = $request->param('Vendor');
        $name = $request->param('Name');
        $addon = Addon::get()->filter('Name', "$vendor/$name")->first();

        if (!$addon) {
            $this->httpError(404);
        }

        return new AddonController($this, $addon);
    }

    public function vendor($request)
    {
        $name = $request->param('Vendor');
        $vendor = AddonVendor::get()->filter('Name', $name)->first();

        if (!$vendor) {
            $this->httpError(404);
        }

        return new VendorController($this, $vendor);
    }

    public function Title()
    {
        return 'Find Silverstripe Modules and Themes';
    }

    public function Link($slug = null)
    {
        if ($slug) {
            return Controller::join_links(Director::baseURL(), 'add-ons', $slug);
        } else {
            return Controller::join_links(Director::baseURL(), 'add-ons');
        }
    }

    public function ListView()
    {
        $view = $this->request->getVar('view');
        if ($view) {
            return $view;
        } else {
            return 'list';
        }
    }

    public function Addons()
    {
        $list = Addon::get()
            ->exclude(['Obsolete' => 1])
            ->sort(['Released' => 'DESC']);

        $limit = 99999;
        if (Director::isDev()) {
            $limit = 7;
            $list = $list->sort('RAND()');
        }
        // ID
        // PackageName

        $list = $list->limit($limit);
        $arMain = [];
        foreach ($list as $addon) {
            $ar['ID'] = $addon->ID;
            $ar['PackageName'] = $addon->PackageName();
            $ar['Type'] = $addon->Type;
            $ar['Vendor__Name'] = $addon->Vendor()->Name;
            $ar['AddonsAuthors'] = [];
            foreach ($addon->Authors() as $author) {
                $ar['AddonsAuthors'][] = [
                    'Name' => $author->Name
                ];
            }
            if (! count($ar['AddonsAuthors'])) {
                $ar['AddonsAuthors'] = false;
            }
            $ar['Repository__URL'] = DBField::create_field('Varchar', $addon->Repository)->URL();
            $ar['DocLink'] = $addon->DocLink();
            $ar['Description'] = DBField::create_field('Varchar', $addon->Description)->LimitCharacters($limit = 450, $add = '...');
            $lastTaggedVersion = $addon->LastTaggedVersion();
            $ar['LastTaggedVersion__Released__Ago'] = DBField::create_field('Date', $lastTaggedVersion->Released)->Ago();
            $ar['Released__Format__U'] = DBField::create_field('Date', $addon->Released)->Format('U');
            $ar['LastTaggedVersion__Released__Format__U'] = DBField::create_field('Date', $lastTaggedVersion->Released)->format('U');
            // $ar['DownloadsMonthly__Formatted'] = $addon->xxx;
            // $ar['Downloads__Formatted'] = $addon->xxx;
            //
            $supports = $addon->getFrameworkSupport();
            if ($supports === null) {
                $ar['FrameworkSupport'] = null;
            } else {
                $ar['FrameworkSupport'] = [];
                foreach ($supports as $support) {
                    $ar['FrameworkSupport']['Support'] = $support->Support;
                }
            }
            $ar['Versions__Count'] = $addon->Versions()->count();
            // $ar['LastTaggedVersion'] = $addon->xxx;
            $linkArray = [
                'Requires',
                'FrameworkRequires',
                'RequiresDev',
                'Suggests',
                'Provides',
                'Conflicts',
                'Replaces'
            ];
            foreach ($linkArray as $linkName) {
                $varName = $linkName;
                $methodName = 'get'.$linkName;
                $objects = $lastTaggedVersion->$methodName();
                $ar[$varName] = [];
                if ($objects instanceof AddonLink) {
                    $objects = ArrayList::create([$objects]);
                }
                if ($objects && $objects->count()) {
                    foreach ($objects as $link) {
                        $ar[$varName][] = [
                            'Name' => $link->Name,
                            'Link' => $link->Link(),
                            'Description' => $link->Description,
                            'Constraint' => $link->ConstraintSimple()
                        ];
                    }
                }
                if (count($ar[$varName] === 0)) {
                    $ar[$varName] = false;
                }
            }
            // $ar['LastTaggedVersion.Suggests'] = $addon->xxx;
            // $ar['LastTaggedVersion.Replaces'] = $addon->xxx;
            $ar['Versions__Count'] = $addon->Versions()->count();
            $arMain['TFS'.$addon->ID] = $ar;
        }
        TableFilterSortAPI::add_settings(
            [
                'scrollToTopAtPageOpening' => false,
                'sizeOfFixedHeader' => 45,
                'maximumNumberOfFilterOptions' => 300,
                'rowRawData' => $arMain,
                'excludeFromFilter' => [
                    'ID'
                ]
            ]
        );
        TableFilterSortAPI::include_requirements(
            $tableSelector = '.tfs-holder',
            $blockArray = array(),
            $jqueryLocation = '',
            $includeInPage = true,
            $jsSettings = null
        );
        return $list;
    }

    public function rss($request, $limit = 10)
    {
        $addons = Addon::get()
            ->exclude(['Obsolete', 1])
            ->sort(['Released' => 'DESC'])
            ->limit($limit);

        $rss = new RSSFeed(
            $addons,
            $this->Link(),
            "Newest addons on ssmods.com",
            null,
            'RSSTitle'
        );

        return $rss->outputToBrowser();
    }

    public function LocalNow($format = '')
    {
        return date(DATE_RFC2822);
    }
}
