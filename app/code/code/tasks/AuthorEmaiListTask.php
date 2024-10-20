<?php
/**
 * Updates addons. Should usually be handled by a redis queue
 * which interacts directly with {@link BuildAddonJob},
 * but this task can help with debugging.
 */
class AuthorEmaiListTask extends BuildTask
{
    protected $title = 'Get List of Emails';

    protected $description = 'Get list of author emails';

    public function run($request)
    {
        $addons = AddonAuthor::get();
        $ar = $addons->column('Email');
        $arNew = [];
        foreach ($ar as $email) {
            if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
                //do nothing
            } else {
                $arNew[$email] = $email;
            }
        }
        foreach ($arNew as $email) {
            DB::alteration_message($email);
        }
    }
}
