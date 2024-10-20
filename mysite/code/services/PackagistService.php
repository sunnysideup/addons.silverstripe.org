<?php

use Composer\Factory;
use Composer\IO\NullIO;
use Composer\Package\Loader\ArrayLoader;
use Composer\Repository\ComposerRepository;
use Guzzle\Http\Client;

/**
 * Interacts with Packagist to retrieve package listings and details.
 */
class PackagistService
{

    /**
     * @var Composer\Composer
     */
    private $composer;

    /**
     * @var Composer\Repository\RepositoryInterface
     */
    private $repository;

    public function __construct()
    {
        $this->composer = Factory::create(new NullIO());
        $this->client = new Packagist\Api\Client();
    }

    /**
     * @return Composer\Composer
     */
    public function getComposer()
    {
        return $this->composer;
    }

    /**
     * Gets all SilverStripe packages.
     * you can limit it to one Vendor
     * with the limitAddons variable

     * @param string (optional) $limitAddons
     * @return Packagist\Api\Package[]
     */
    public function getPackages($limitAddons = null)
    {
        $packages = array();
        $loader = new ArrayLoader();
        if (is_array($limitAddons)) {
            foreach ($limitAddons as $limitAddon) {
                $packages[] = $this->client->get($limitAddon);
                echo $limitAddon . PHP_EOL; //output to give feedback when running
            }
        } else {
            $addonTypes = array(
                'silverstripe-module',
                'silverstripe-theme',
                'silverstripe-vendormodule',
                'silverstripe-recipe'
            );
            foreach ($addonTypes as $type) {
                if ($limitAddons) {
                    $repositoriesNames = $this->client->all(array('vendor' => $limitAddons));
                } else {
                    $repositoriesNames = $this->client->all(array('type' => $type));
                }
                foreach ($repositoriesNames as $name) {
                    $packages[] = $this->client->get($name);
                    echo $name . PHP_EOL; //output to give feedback when running
                }
            }
        }
        return $packages;
    }

    /**
     * Gets all SilverStripe packages, grouped by package name.
     *
     * @return array
     */
    public function getGroupedPackages()
    {
        $grouped = array();

        foreach ($this->getPackages() as $package) {
            $name = $package->getName();

            if (array_key_exists($name, $grouped)) {
                $grouped[$name][] = $package;
            } else {
                $grouped[$name] = array($package);
            }
        }

        return $grouped;
    }

    /**
     * Gets detailed information for a package.
     *
     * @param string $name
     * @return array
     */
    public function getPackageDetails($name)
    {
        return $this->client->get($name);
    }

    /**
     * Gets all versions of a package by name.
     *
     * @param $name
     * @return \Composer\Package\PackageInterface[]
     */
    public function getPackageVersions($name)
    {
        $packages = array();
        $loader = new ArrayLoader();

        $package = $this->client->get($name);

        foreach ($package->getVersions() as $repo) {
            $packages[] = $repo;
        }

        return $packages;
    }
}
