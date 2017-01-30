<?php
/**
 * Runs the add-on updater.
 */
class UpdateAddonsTask extends BuildTask {

    protected $title = 'Update Add-ons';

    protected $description = 'Updates add-ons from Packagist';

    private $updater;

    public function __construct(AddonUpdater $updater) {
        $this->updater = $updater;
    }

    public function run($request) {
        $request->getVar('addons');
        $clear = (bool)$request->getVar('clear');
        $onlyFor = $request->getVar('addons') ? explode(',', $request->getVar('addons')) : null;
        $this->updater->update(
            $clear,
            $onlyFor
        );
    }

}
