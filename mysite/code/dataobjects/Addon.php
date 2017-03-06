<?php

use Elastica\Document;
use Elastica\Type\Mapping;

/**
 * An add-on with one or more versions.
 */
class Addon extends DataObject {

    public static $db = array(
        'Name' => 'Varchar(255)',
        'Description' => 'Text',
        'Type' => 'Varchar(100)',
        'Readme' => 'HTMLText',
        'Released' => 'SS_Datetime',
        'Repository' => 'Varchar(255)',
        'Downloads' => 'Int',
        'DownloadsMonthly' => 'Int',
        'Favers' => 'Int',
        'LastUpdated' => 'SS_Datetime',
        'LastBuilt' => 'SS_Datetime',
        'BuildQueued' => 'Boolean',
        'HelpfulRobotData' => 'Text',
        'HelpfulRobotScore' => 'Int',
        'FrameworkSupportList' => 'Varchar(50)',
    );

    public static $has_one = array(
        'Vendor' => 'AddonVendor'
    );

    public static $has_many = array(
        'Versions' => 'AddonVersion'
    );

    public static $many_many = array(
        'Keywords' => 'AddonKeyword',
        'Screenshots' => 'Image',
        'CompatibleVersions' => 'SilverStripeVersion'
    );

    public static $default_sort = 'Name';

    public static $extensions = array(
        'SilverStripe\\Elastica\\Searchable'
    );

    private $_lastTaggedVersion = null;

    function LastTaggedVersion()
    {
        if(! $this->_lastTaggedVersion) {
            $excludeArray = array(
                'Version' => array('dev-master', 'trunk'),
                'PrettyVersion' => array('dev-master', 'trunk')
            );
            $keys = $this->Versions()->exclude($excludeArray)->column('ID');
            if(count($keys)) {
                $values = $this->Versions()->exclude($excludeArray)->column('PrettyVersion');
            } else {
                $keys = $this->Versions()->column('ID');
                $values = $this->Versions()->column('PrettyVersion');
            }
            $versions = array_combine($keys, $values);
            uasort($versions, function($a, $b) {
                return version_compare($b, $a);
            });
            reset($versions);
            $id = key($versions);
            $this->_lastTaggedVersion = AddonVersion::get()->byID($id);
        }
        return $this->_lastTaggedVersion;
    }

    function DownloadsMonthlyIfEditedThisMonth()
    {
        $lastTaggedVersion = $this->LastTaggedVersion();
        $ageInSeconds = time() - strtotime($lastTaggedVersion->Released);
        if($ageInSeconds < (86400 * 30)) {
            return $this->DownloadsMonthly;
        }
        return 0;
    }

    /**
     * Gets the addon's versions sorted from newest to oldest.
     *
     * @return ArrayList
     */
    public function SortedVersions() {
        $versions = $this->Versions()->toArray();

        usort($versions, function($a, $b) {
            return version_compare($b->Version, $a->Version);
        });

        return new ArrayList($versions);
    }

    public function getFrameworkSupport()
    {
        $array = explode(',',$this->FrameworkSupportList);
        if(is_array($array) && count($array)) {
            sort($array);
            $al = ArrayList::create();
            $hasConstraints = false;
            if(count($array)) {
                foreach($array as $constraint) {
                    if(intval($constraint) > 0) {
                        $hasConstraints = true;
                        $al->push(ArrayData::create(array('Supports' => $constraint)));
                    }
                }
            }
        }
        if($hasConstraints === false) {
            return null;
        }
        return $al;
    }


    public function MasterVersion() {
        return $this->Versions()->filter('PrettyVersion', array('dev-master', 'trunk'))->First();
    }

    public function Authors() {
        return $this->Versions()->relation('Authors');
    }

    public function VendorName() {
        return substr($this->Name, 0, strpos($this->Name, '/'));
    }

    public function VendorLink() {
        return Controller::join_links(
            Director::baseURL(), 'add-ons', $this->VendorName()
        );
    }

    public function PackageName() {
        return substr($this->Name, strpos($this->Name, '/') + 1);
    }

    public function Link() {
        return Controller::join_links(
            Director::baseURL(), 'add-ons', $this->Name
        );
    }

    public function DocLink()
    {
        if(file_exists('/var/www/docs.ssmods.com/public_html/'.$this->Name.'/index.xhtml')) {
            $url = '//docs.ssmods.com/'.$this->Name;
            return $url;
        }
    }

    public function DescriptionText() {
        return $this->Description;
    }

    public function RSSTitle() {
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

    public function getElasticaMapping() {
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

    public function getElasticaDocument() {
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

    public function onBeforeDelete() {
        parent::onBeforeDelete();

        // Partially cascade delete. Leave author and keywords in place,
        // since they might be related to other addons.
        foreach($this->Screenshots() as $image) {
            $image->delete();
        }
        $this->Screenshots()->removeAll();

        foreach($this->Versions() as $version) {
            $version->delete();
        }

        $this->Keywords()->removeAll();
        $this->CompatibleVersions()->removeAll();
    }

    public function getDateCreated() {
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

    function FilteredKeywords() {
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

}
