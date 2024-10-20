<?php

use Elastica\Document;
use Elastica\Type\Mapping;
use Heyday\Elastica\Searchable;
use SilverStripe\ORM\FieldType\DBDatetime;
use SilverStripe\ORM\FieldType\DBBoolean;
use SilverStripe\Assets\Image;
use SilverStripe\ORM\ArrayList;
use SilverStripe\Control\Director;
use SilverStripe\Control\Controller;
use SilverStripe\View\ArrayData;
use SilverStripe\ORM\DataObject;

/**
 * An add-on with one or more versions.
 */
class Addon extends DataObject
{

    private static $db = array(
        'Name'              => 'Varchar(255)',
        'Description'       => 'Text',
        'Type'              => 'Varchar(100)',
        'Readme'            => 'HTMLText',
        'Released'          => 'Datetime',
        'Repository'        => 'Varchar(255)',
        'Downloads'         => 'Int',
        'DownloadsMonthly'  => 'Int',
        'Favers'            => 'Int',
        'LastUpdated'       => 'Datetime',
        'LastBuilt'         => 'Datetime',
        'BuildQueued'       => 'Boolean',
        'Abandoned'         => 'Text',
        // Module rating information
        'Rating'            => 'Int',
        'RatingDetails'     => 'Text',
        // Commercially supported by SilverStripe Ltd.
        'Supported'         => 'Boolean',
        'Obsolete' => 'Boolean'
    );

    private static $has_one = array(
        'Vendor' => AddonVendor::class,
    );

    public static $has_many = array(
        'Versions' => AddonVersion::class,
    );

    private static $many_many = array(
        'Keywords'           => AddonKeyword::class,
        'Screenshots'        => Image::class,
        'CompatibleVersions' => SilverStripeVersion::class,
    );

    public static $indexes = array(
        'Name' => true,
        'Obsolete' => true
    );

    public static $default_sort = 'Name';

    public static $extensions = array(
        'Symbiote\\Elastica\\Searchable'
    );

    private $_lastTaggedVersion = null;

    public function LastTaggedVersion()
    {
        if (! $this->_lastTaggedVersion) {
            $excludeArray = array(
                'Version' => array('dev-master', 'trunk'),
                'PrettyVersion' => array('dev-master', 'trunk')
            );
            $keys = $this->Versions()->exclude($excludeArray)->column('ID');
            if (count($keys)) {
                $values = $this->Versions()->exclude($excludeArray)->column('PrettyVersion');
            } else {
                $keys = $this->Versions()->column('ID');
                $values = $this->Versions()->column('PrettyVersion');
            }
            $versions = array_combine($keys, $values);
            uasort($versions, function ($a, $b) {
                return version_compare($b, $a);
            });
            reset($versions);
            $id = key($versions);
            $this->_lastTaggedVersion = AddonVersion::get()->byID($id);
        }
        return $this->_lastTaggedVersion;
    }

    public function DownloadsMonthlyIfEditedThisMonth()
    {
        $lastTaggedVersion = $this->LastTaggedVersion();
        $ageInSeconds = time() - strtotime($lastTaggedVersion->Released);
        if ($ageInSeconds < (86400 * 30)) {
            return $this->DownloadsMonthly;
        }
        return 0;
    }

    public function IsCurrent()
    {
        $currentFrameworkLevel = Config::inst()->get('SilverStripeVersion', 'current_framework_level');
        $array = explode(',', $this->FrameworkSupportList);
        foreach($array as $val) {
            $val = intval($val);
            if($val >= $currentFrameworkLevel) {
                return true;
            }
        }
        return false;
    }
    private static $extensions = [
        Searchable::class,
    ];
    /**
     * Gets the addon's versions sorted from newest to oldest.
     *
     * @return ArrayList
     */
    public function SortedVersions()
    {
        $versions = $this->Versions()->toArray();

        usort($versions, function ($a, $b) {
            return version_compare($b->Version, $a->Version);
        });

        return new ArrayList($versions);
    }

    public function getFrameworkSupport()
    {
        $al = ArrayList::create();
        $array = explode(',', $this->FrameworkSupportList);
        if (is_array($array) && count($array)) {
            sort($array);
            $hasConstraints = false;
            if (count($array)) {
                foreach ($array as $constraint) {
                    if (intval($constraint) > 0) {
                        $hasConstraints = true;
                        $al->push(ArrayData::create(array('Supports' => $constraint)));
                    }
                }
            }
        }

        return $al;
    }

    /**
     * @return AddonVersion|null
     */
    public function DefaultVersion()
    {
        $versions = $this->Versions()->column('Version');
        if (!$versions) {
            return null;
        }

        usort($versions, function ($a, $b) {
            return version_compare($b, $a);
        });

        return $this->Versions()->filter('Version', $versions[0])->First();
    }

    public function MasterVersion()
    {
        return $this->Versions()->filter('PrettyVersion', array('dev-master', 'trunk'))->First();
    }

    public function Authors()
    {
        return $this->Versions()->relation('Authors');
    }

    public function VendorName()
    {
        return substr($this->Name, 0, strpos($this->Name, '/'));
    }

    public function VendorLink()
    {
        return Controller::join_links(
            Director::baseURL(),
            'add-ons',
            $this->VendorName()
        );
    }

    public function PackageName()
    {
        return $this->getPackageName();
    }
    public function getPackageName()
    {
        return substr($this->Name, strpos($this->Name, '/') + 1);
    }
    public function getPackageNameNice()
    {
        $name = preg_replace('/^'.preg_quote('silverstripe-', '/').'\s*/i', '', $this->getPackageName());
        $name = str_replace(['-', '_'], [' ', ' '], $name);

        return $name;
    }

    public function SimpleType()
    {
        return $this->getSimpleType();
    }
    public function getSimpleType()
    {
        switch ($this->Type) {
            case 'theme':
                return 'theme';
            case 'recipe':
                return 'recipe';
            default:
                return 'module';
        }
    }

    public function Link()
    {
        return Controller::join_links(
            Director::baseURL(),
            'add-ons',
            $this->Name
        );
    }

    public function LinkNew()
    {
        $nameArray = explode('/', $this->Name);
        if (isset($nameArray[0]) && $nameArray[0]) {
            if (isset($nameArray[1]) && $nameArray[1]) {
                $team = strtolower($nameArray[0]);
                $title = strtolower($nameArray[1]);
                return '//ssmods.com/#~(cfi~(Title~(~(vtm~\''.$title.'~ivl~\''.$title.'))~Team~(~(vtm~\''.$team.'~ivl~\''.$team.')))~csr~(sdi~\'desc~sct~\'RD))';
                return
                    '/'.
                    '#~(cfi('.
                    '~Title~(~(vtm~\''.$title.'~ivl~\''.$title.'))'.
                    '~Team~(~(vtm~\''.$team.'~ivl~\''.$team.'))'.
                    '))';
            }
        }
    }

    /**
     * @return string | null
     */
    public function DocLink()
    {
        if (
            file_exists('/var/www/docs.ssmods.com/public_html/'.$this->Name.'/classes.xhtml') ||
            Director::isdev()
        ) {
            $url = '//docs.ssmods.com/'.$this->Name.'/classes.xhtml';
            return $url;
        }
    }

    public function DescriptionText()
    {
        return $this->Description;
    }

    public function RSSTitle()
    {
        return sprintf('New module release: %s', $this->Name);
    }

    public function PackagistUrl()
    {
        return "https://packagist.org/packages/$this->Name";
    }

    /**
     * Remove the effect of code of conduct Helpful Robot measure that we currently don't include in the Supported module definition
     *
     * @return integer Adjusted Helpful Robot score
     */
    public function getAdjustedHelpfulRobotScore()
    {
        return round(min(100, $this->HelpfulRobotScore / 92.9 * 100));
    }

    public function getElasticaMapping()
    {
        return new Mapping(null, array(
            'name' => array('type' => 'string'),
            'description' => array('type' => 'string'),
            'type' => array('type' => 'string'),
            'compatibility' => array('type' => 'string'),
            'vendor' => array('type' => 'string'),
            'tags' => array('type' => 'string'),
            'released' => array('type' => 'date'),
            'downloads' => array('type' => 'string'),
            'readme' => array('type' => 'string')
        ));
    }

    public function getElasticaDocument()
    {
        return new Document($this->ID, array(
            'name' => $this->Name,
            'description' => $this->Description,
            'type' => $this->Type,
            'compatibility' => $this->CompatibleVersions()->column('Name'),
            'vendor' => $this->VendorName(),
            'tags' => $this->Keywords()->column('Name'),
            'released' => $this->obj('Released')->Format('c'),
            'downloads' => (int) $this->Downloads,
            'readme' => strip_tags($this->Readme)
            // '_boost' => sqrt($this->Downloads)
        ));
    }

    public function onBeforeDelete()
    {
        parent::onBeforeDelete();

        // Partially cascade delete. Leave author and keywords in place,
        // since they might be related to other addons.
        foreach ($this->Screenshots() as $image) {
            $image->delete();
        }
        $this->Screenshots()->removeAll();

        foreach ($this->Versions() as $version) {
            $version->delete();
        }

        $this->Keywords()->removeAll();
        $this->CompatibleVersions()->removeAll();
    }

    public function getDateCreated()
    {
        return date('Y-m-d', strtotime($this->Created));
    }

    /**
     * @return array
     */
    public function HelpfulRobotData()
    {
        $data = json_decode($this->HelpfulRobotData, true);

        return new ArrayData($data["inspections"][0]);
    }

    public function FilteredKeywords()
    {
        $list = $this->Keywords()->exclude(
            array(
                'Name' => array(
                    'Silverstripe',
                    'CMS',
                    'cms',
                    'silverstripe',
                    'silver stripe',
                    'silvertripe CMS'
                )
            )
        );
        return $list;
    }


    public function canEdit($member = null)
    {
        return parent::canEdit($member);
    }

    public function canView($member = null)
    {
        if (Permission::checkMember($member, "CMS_ACCESS_EDIT_KEYWORDS")) {
            return true;
        }
        return $this->canEdit($member);
    }

    /**
     * Returns unserialised result data from the ratings check suite
     *
     * {@see \SilverStripe\ModuleRatings\CheckSuite}
     *
     * @return ArrayData
     */
    public function RatingData()
    {
        if ($this->RatingDetails) {
            $data = (array)json_decode($this->RatingDetails, true);
            return ArrayData::create($data);
        }
    }

    /**
     * Returns a list of whether rating metrics have passed for this addon, and a description of the metric
     *
     * @return ArrayList
     */
    public function RatingDescriptions()
    {
        $metrics = $this->RatingData();

        return ArrayList::create([
            [
                'Metric' => $metrics->has_readme,
                'Description' => 'Readme',
                'Title' => 'Module has a readme file',
            ],
            [
                'Metric' => $metrics->has_license,
                'Description' => 'FOSS License',
                'Title' => 'Module has a "free open source software" license',
            ],
            [
                'Metric' => $metrics->has_code_or_src_folder,
                'Description' => 'Structured correctly',
                'Title' => 'PHP code is in a folder called "code" or "src"',
            ],
            [
                'Metric' => $metrics->has_contributing_file,
                'Description' => 'Contributing file',
                'Title' => 'A guide for open source contributors exists',
            ],
            [
                'Metric' => $metrics->has_gitattributes_file,
                'Description' => 'Git attributes file',
                'Title' => 'A .gitattributes file exists to ignore files from distributable packages',
            ],
            [
                'Metric' => $metrics->has_editorconfig_file,
                'Description' => 'Editor config file',
                'Title' => 'An EditorConfig ruleset file exists for IDE formatting',
            ],
            [
                'Metric' => $metrics->good_code_coverage,
                'Description' => 'Good code coverage (>40%)',
                'Title' => '40% or more of code is covered by automated tests (in codecov.io or ScrutinizerCI)',
            ],
            [
                'Metric' => $metrics->great_code_coverage,
                'Description' => 'Great code coverage (>75%)',
                'Title' => '75% or more of code is covered by automated tests (in codecov.io or ScrutinizerCI)',
            ],
            [
                'Metric' => $metrics->has_documentation,
                'Description' => 'Documentation',
                'Title' => 'A "docs" folder exists containing documentation',
            ],
            [
                'Metric' => $metrics->ci_passing,
                'Description' => 'CI builds passing',
                'Title' => 'Automated tests via TravisCI or CircleCI are passing',
            ],
            [
                'Metric' => $metrics->good_scrutinizer_score,
                'Description' => 'Scrutinizer >6.5',
                'Title' => 'ScrutinizerCI score for this module is at least 6.5/10',
            ],
            [
                'Metric' => $metrics->coding_standards,
                'Description' => 'PSR-2 standards',
                'Title' => 'PHP code conforms to SilverStripe\'s implementation of PSR-2 formatting rules'
            ],
        ]);
    }



    /**
     *
     * @return bool|DateInterval
     */
    public function addonAge()
    {
        $date = new DateTime();
        $released = new DateTime($this->Released);

        return $date->diff($released);
    }

    /**
     * Calculate the total amount of downloads per day
     * Based on the total amount of downloads divided by the age of the addon
     *
     * @return float
     */
    public function getRelativePopularity()
    {
        return (int)$this->Downloads / max((int)$this->addonAge()->days, 1);
    }

    /**
     * Format the relative popularity to a nicely readable number
     *
     * @return string
     */
    public function relativePopularityFormatted()
    {
        return number_format($this->getRelativePopularity(), 2);
    }
}
