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
        if (Director::isLive()) {
            $html = preg_replace("/\s+/", ' ', trim($html));
            $html = str_replace(array('<!-- -->', '//<![CDATA[', '//]]>'), '', $html);
        }
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
        if (Director::isDev() && 1 === 2) {
            $list = $list->where('MOD(ID,10)=0');
        }
        // ID
        // PackageName

        $list = $list->limit($limit);
        $arMain = [];
        foreach ($list as $addon) {
            $lastTaggedVersion = $addon->LastTaggedVersion();

            $ar['ID'] = 'tfs'.$addon->ID;
            $ar['FullName'] = $addon->getPackageName();
            $ar['Name'] = $addon->getPackageNameNice();
            $ar['Type'] = $addon->getSimpleType();
            $ar['Team'] = $addon->Vendor()->Name;

            $ar['Authors'] = $addon->Authors()->column('Name');
            if (! count($ar['Authors'])) {
                $ar['Authors'] = false;
            }

            $ar['Tags'] = $addon->FilteredKeywords()->column('Name');
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
            $ageInMonth = ((time() - $ar['Created_U']) / (86400 * 30.5));
            $averageDownloadsPerMonth = 'n/a';
            $trendingScore = '0';
            $trendingSimple = '';
            if ($ageInMonth < 1.5 || $addon->Downloads < 30) {
                //do nothing ...
            } else {
                $averageDownloadsPerMonth = ($addon->Downloads / $ageInMonth);
                if ($averageDownloadsPerMonth > 3) {
                    $trendingScore = ceil($addon->DownloadsMonthly / $averageDownloadsPerMonth);
                    if ($trendingScore > 12) {
                        $trendingScore = 12;
                    }
                    $trendingSimple = str_repeat("☆", $trendingScore);
                }
            }
            $ar['AvgDownloads'] = round($averageDownloadsPerMonth);
            $ar['Trending'] = $trendingScore;
            $ar['TrendingSimple'] = $trendingSimple;

            $ar['Supports'] = $addon->getFrameworkSupport()->column('Supports');
            if (! count($ar['Supports'])) {
                $ar['Supports'] = ['n/a'];
            } else {
                foreach ($ar['Supports'] as $key => $value) {
                    $ar['Supports'][$key] = $value.'.*';
                }
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
                $ar[$varName.'Full'] = [];
                if ($objects instanceof AddonLink) {
                    $objects = ArrayList::create([$objects]);
                }
                if ($objects) {
                    foreach ($objects as $link) {
                        if ($link->IsMeaningfull()) {
                            $ar[$varName.'Full'][] = [
                                'Name' => $link->getPackageNameNice(),
                                'Link' => $link->Link(),
                                'Constraint' => $link->ConstraintSimple()
                            ];
                            $ar[$varName][] = $link->getPackageNameNice();
                        }
                    }
                }
                if (count($ar[$varName]) === 0) {
                    $ar[$varName] = false;
                    $ar[$varName.'Full'] = false;
                }
            }
            $arMain[$ar['ID']] = $ar;
        }

        TableFilterSortAPI::add_settings(
            [
                'scrollToTopAtPageOpening' => true,
                'sizeOfFixedHeader' => 45,
                'maximumNumberOfFilterOptions' => 10,
                'filtersParentPageID' => "Filter",
                'favouritesParentPageID' => "Favourites",
                'rowRawData' => $arMain,
                'includeInFilter' => [
                    'Type',
                    'Tags',
                    'Name',
                    'Team',
                    'Supports',
                    'Authors',
                    'Requires',
                    'Suggests'
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
