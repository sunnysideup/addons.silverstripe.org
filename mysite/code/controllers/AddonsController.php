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
            $lastTaggedVersion = $addon->LastTaggedVersion();

            $ar['ID'] = $addon->ID;
            $ar['Name'] = $addon->getPackageName();
            $ar['Type'] = $addon->getSimpleType();
            $ar['Team'] = $addon->Vendor()->Name;

            $ar['Authors'] = $addon->Authors()->column('Name');
            if (! count($ar['Authors'])) {
                $ar['Authors'] = false;
            }

            $ar['Tags'] = $addon->Keywords()->column('Name');
            if (! count($ar['Tags'])) {
                $ar['Tags'] = false;
            }
            $ar['URL'] = DBField::create_field('Varchar', $addon->Repository)->URL();
            $ar['API'] = $addon->DocLink();
            $ar['Notes'] = DBField::create_field('Varchar', $addon->Description)->LimitCharacters($limit = 450, $add = '...');

            $created = DBField::create_field('Date', $addon->Released);
            $ar['Created'] = $created->Ago();
            $ar['Created_U'] = $created->format('U');

            $lastEdited = DBField::create_field('Date', $lastTaggedVersion->Released);
            $ar['LastEdited'] = $lastEdited->Ago();
            $ar['LastEdited_U'] = $lastEdited->format('U');

            $ar['Installs'] = $addon->Downloads;

            $ar['MInstalls'] = $addon->DownloadsMonthly;

            $ar['Supports'] = $addon->getFrameworkSupport()->column('Support');
            if (! count($ar['Supports'])) {
                $ar['Supports'] = ['n/a'];
            }

            $ar['TagCount'] = $addon->Versions()->count();
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
            $arMain['TFS'.$addon->ID] = $ar;
        }

        TableFilterSortAPI::add_settings(
            [
                'scrollToTopAtPageOpening' => false,
                'sizeOfFixedHeader' => 45,
                'maximumNumberOfFilterOptions' => 300,
                'rowRawData' => $arMain,
                'includeInFilter' => [
                    'Tags',
                    'Name',
                    'Team',
                    'Supports',
                    'Authors'
                ],
                'dataDictionary' => [
                    'Supports' => ['Label' => 'Framework Support']
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
