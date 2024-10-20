<?php
/**
 * Deletes packages removed from Packagist.
 */
class DeleteRedundantAddonsTask extends BuildTask
{
    protected $title = 'Delete Redundant Add-ons ';

    protected $description = 'Deletes packages removed from Packagist';

    public function run($request)
    {
        $dateOneWeekAgo  = date('Y-m-d', strtotime('-1 week'));

        $addons = Addon::get()->filter('LastUpdated:LessThan', $dateOneWeekAgo);

        foreach ($addons as $addon) {
            try {
                $addon->Keywords()->removeAll();
                $addon->Screenshots()->removeAll();
                $addon->CompatibleVersions()->removeAll();

                foreach ($addon->Versions() as $version) {
                    $version->Authors()->removeAll();
                    $version->Keywords()->removeAll();
                    $version->CompatibleVersions()->removeAll();
                    $version->delete();
                }

                $addon->delete();
            } catch (Elastica\Exception\NotFoundException $e) {
                // no-op
            }
        }
    }
}
