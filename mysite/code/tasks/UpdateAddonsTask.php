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
        $this->updater->update(
            (bool)$request->getVar('clear'),
            $request->getVar('addons') ? explode(',', $request->getVar('addons')) : null
        );
    }

}
