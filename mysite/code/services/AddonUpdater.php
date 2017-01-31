<?php

use Composer\Package\AliasPackage;
use Composer\Package\CompletePackage;
use Composer\Semver\Constraint\Constraint;
use Guzzle\Http\Exception\ClientErrorResponseException;
use SilverStripe\Elastica\ElasticaService;
use Packagist\Api\Result\Package;
use Composer\Package\Version\VersionParser;

/**
 * Updates all add-ons from Packagist.
 */
class AddonUpdater {

    /**
     * @var PackagistService
     */
    private $packagist;

    /**
     * @var SilverStripe\Elastica\ElasticaService
     */
    private $elastica;

    /**
     * @var ResqueService
     */
    private $resque;

    /**
     * @var Composer\Package\Version\VersionParser
     */
    private $versionParser;

    /**
     * @var SilverStripeVersion[]
     */
    private $silverstripes = array();

    public function __construct(
        PackagistService $packagist,
        ElasticaService $elastica,
        ResqueService $resque,
        VersionParser $versionParser
    ) {
        $this->packagist = $packagist;
        $this->elastica = $elastica;
        $this->resque = $resque;
        $this->versionParser = $versionParser;
    }

    /**
     * Updates all add-ons.
     *
     * @param Boolean Clear existing addons before updating them.
     * Will also clear their search index, and cascade the delete for associated data.
     * @param Array Limit to specific addons, using their name incl. vendor prefix.
     */
    public function update($clear = false, $limitAddons = null) {
        if($clear && !$limitAddons) {
            Addon::get()->removeAll();
            AddonAuthor::get()->removeAll();
            AddonKeyword::get()->removeAll();
            AddonLink::get()->removeAll();
            AddonVendor::get()->removeAll();
            AddonVersion::get()->removeAll();
        }

        foreach (SilverStripeVersion::get() as $version) {
            $this->silverstripes[$version->ID] = $version->getConstraint();
        }

        // This call to packagist can be expensive. Requests are served from a cache if usePackagistCache() returns true
        $cache = SS_Cache::factory('addons');
        if($this->usePackagistCache() && $packages = $cache->load('packagist')) {
            $packages = unserialize($packages);
        } else {
            $packages = $this->packagist->getPackages($limitAddons);
            if(!$limitAddons) {
                $cache->save(serialize($packages), 'packagist');
            }
        }
        $this->elastica->startBulkIndex();

        foreach ($packages as $package) {
            $name = $package->getName();
            $versions = $package->getVersions();

            if($limitAddons && !in_array($name, $limitAddons)) continue;

            $addon = Addon::get()->filter('Name', $name)->first();
            if (!$addon) {
                $addon = new Addon();
                $addon->Name = $name;
                $addon->write();
            }
            DB::alteration_message("... PACKAGE: ".$addon->Name);
            usort($versions, function ($a, $b) {
                return version_compare($a->getVersionNormalized(), $b->getVersionNormalized());
            });

            $this->updateAddon($addon, $package, $versions);
        }

        $this->elastica->endBulkIndex();
    }



    /**
     * Check whether or not we should contact packagist or use a cached version. This allows to speed up the task
     * during development.
     *
     * @return bool
     */
    protected function usePackagistCache() {
        return Director::isDev();
    }

    private $frameworkSupportArray = array();

    private function updateAddon(Addon $addon, Package $package, array $versions) {
        unset($this->frameworkSupportArray);
        $this->frameworkSupportArray = array();
        if (!$addon->VendorID) {
            $vendor = AddonVendor::get()->filter('Name', $addon->VendorName())->first();

            if (!$vendor) {
                $vendor = new AddonVendor();
                $vendor->Name = $addon->VendorName();
                $vendor->write();
            }
            $addon->VendorID = $vendor->ID;
        }

        $addon->Type = str_replace('silverstripe-', '', $package->getType());
        $addon->Description = $package->getDescription();
        $addon->Released = strtotime($package->getTime());
        $addon->Repository = $package->getRepository();
        $addon->Downloads = $package->getDownloads()->getTotal();
        $addon->DownloadsMonthly = $package->getDownloads()->getMonthly();
        $addon->Favers = $package->getFavers();

        $frameworkSupportArray = array();
        foreach ($versions as $version) {
            $this->updateVersion($addon, $version);
        }

        $addon->FrameworkSupportList = implode(',', $this->frameworkSupportArray);

        $addon->LastUpdated = time();
        $addon->write();
    }

    private function updateVersion(Addon $addon, Packagist\Api\Result\Package\Version $versionFromPackagist) {
        $version = null;

        if ($addon->isInDB()) {
            $version = $addon->Versions()->filter('Version', $versionFromPackagist->getVersionNormalized())->first();
        }

        if (!$version) {
            $version = new AddonVersion();
        }

        $version->Name = $versionFromPackagist->getName();
        $version->Type = str_replace('silverstripe-', '', $versionFromPackagist->getType());
        $version->Description = $versionFromPackagist->getDescription();
        $version->Released = strtotime($versionFromPackagist->getTime());
        $keywords = $versionFromPackagist->getKeywords();

        if ($keywords) {
            foreach ($keywords as $keyword) {
                $keyword = AddonKeyword::get_by_name($keyword);

                $addon->Keywords()->add($keyword);
                $version->Keywords()->add($keyword);
            }
        }

        $version->Version = $versionFromPackagist->getVersionNormalized();
        $version->PrettyVersion = $versionFromPackagist->getVersion();

        $stability = VersionParser::parseStability($versionFromPackagist->getVersion());
        $isDev = $stability === 'dev';
        $version->Development = $isDev;

        $version->SourceType = $versionFromPackagist->getSource()->getType();
        $version->SourceUrl = $versionFromPackagist->getSource()->getUrl();
        $version->SourceReference = $versionFromPackagist->getSource()->getReference();

        if($versionFromPackagist->getDist()) {
            $version->DistType = $versionFromPackagist->getDist()->getType();
            $version->DistUrl = $versionFromPackagist->getDist()->getUrl();
            $version->DistReference = $versionFromPackagist->getDist()->getReference();
            $version->DistChecksum = $versionFromPackagist->getDist()->getShasum();
        }

        $version->Extra = $versionFromPackagist->getExtra();
        $version->Homepage = $versionFromPackagist->getHomepage();
        $version->License = $versionFromPackagist->getLicense();
        // $version->Support = $package->getSupport();

        $addon->Versions()->add($version);

        $this->updateLinks($version, $versionFromPackagist);
        $this->updateCompatibility($addon, $version, $versionFromPackagist);
        $this->updateAuthors($version, $versionFromPackagist);
        $framework = $version->getFrameworkRequires();
        if($framework) {
            $constraint = trim($framework->ConstraintSimple());
            if(intval($constraint)) {
                $this->frameworkSupportArray[$constraint] = $constraint;
            } else {
                $this->frameworkSupportArray['unknown'] = 'unknown';
            }
        }
        DB::alteration_message("... ... VERSION: ".$version->PrettyVersion);
    }

    private function updateLinks(AddonVersion $version, Packagist\Api\Result\Package\Version $versionFromPackagist) {
        $getLink = function ($name, $type) use ($version) {
            $link = null;

            if ($version->isInDB()) {
                $link = $version->Links()->filter('Name', $name)->filter('Type', $type)->first();
            }

            if (!$link) {
                $link = new AddonLink();
                $link->Name = $name;
                $link->Type = $type;
            }

            return $link;
        };

        $types = array(
            'require' => 'getRequire',
            'require-dev' => 'getRequireDev',
            'provide' => 'getProvide',
            'conflict' => 'getConflict',
            'replace' => 'getReplace'
        );

        foreach ($types as $type => $method) {
            if ($linked = $versionFromPackagist->$method())
                foreach ($linked as $link => $constraint) {
                    $name = $link;
                    $addon = Addon::get()->filter('Name', $name)->first();

                    $local = $getLink($name, $type);
                    $local->Constraint = $constraint;

                    if ($addon) {
                        $local->TargetID = $addon->ID;
                    }

                    $version->Links()->add($local);
            }
        }

        //to-do api have no method to get this.
        /*$suggested = $versionFromPackagist->getSuggests();

        if ($suggested) foreach ($suggested as $versionFromPackagist => $description) {
            $link = $getLink($versionFromPackagist, 'suggest');
            $link->Description = $description;

            $version->Links()->add($link);
        }*/
    }

    private function updateCompatibility(Addon $addon, AddonVersion $version, Packagist\Api\Result\Package\Version $versionFromPackagist) {
        $require = null;

        if($versionFromPackagist->getRequire()) foreach ($versionFromPackagist->getRequire() as $name => $link) {
            if((string)$link == 'self.version') continue;

            if ($name == 'silverstripe/framework') {
                $require = $link;
                break;
            }

            if ($name == 'silverstripe/cms') {
                $require = $link;
            }
        }

        if (!$require) {
            return;
        }

        $addon->CompatibleVersions()->removeAll();
        $version->CompatibleVersions()->removeAll();

        foreach ($this->silverstripes as $id => $link) {
            try {
                $constraint = $this->versionParser->parseConstraints($require);
                if ($link->matches($constraint)) {
                    $addon->CompatibleVersions()->add($id);
                    $version->CompatibleVersions()->add($id);
                }
            } catch(Exception $e) {
                // An exception here shouldn't prevent further updates.
                Debug::log($addon->Name . "\t" . $addon->ID . "\t" . $e->getMessage());
            }
        }
    }

    private function updateAuthors(AddonVersion $version, Packagist\Api\Result\Package\Version $versionFromPackagist) {
        if ($versionFromPackagist->getAuthors()) foreach ($versionFromPackagist->getAuthors() as $details) {
            $author = null;

            if (!$details->getName() && !$details->getEmail()) {
                continue;
            }

            if ($details->getEmail()) {
                $author = AddonAuthor::get()->filter('Email', $details->getEmail())->first();
            }

            if (!$author && $details->getHomepage()) {
                $author = AddonAuthor::get()
                    ->filter('Name', $details->getName())
                    ->filter('Homepage', $details->getHomepage())
                    ->first();
            }

            if (!$author && $details->getName()) {
                $author = AddonAuthor::get()
                    ->filter('Name', $details->getName())
                    ->filter('Versions.Addon.Name', $versionFromPackagist->getName())
                    ->first();
            }

            if (!$author) {
                $author = new AddonAuthor();
            }

            if($details->getName()) $author->Name = $details->getName();
            if($details->getEmail()) $author->Email = $details->getEmail();
            if($details->getHomepage()) $author->Homepage = $details->getHomepage();

            //to-do not supported by API
            //if(isset($details['role'])) $author->Role = $details['role'];

            $version->Authors()->add($author->write());
        }
    }

}
