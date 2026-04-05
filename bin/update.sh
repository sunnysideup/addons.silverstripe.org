#!/bin/bash

echo "======================================================";
echo "======================================================";
echo "======================================================";

date

echo "======================================================";
echo "======================================================";
echo "======================================================";

cd /var/www/ssmods.com/

rm /var/www/topics.ssmods.com/access.log -rf
rm /var/www/ssmods.com/public_html/debug.log -rf 

startup.sh

cd /var/www/ssmods.com/public_html/

chown vegan:www-data . -R

#delete logs
rm ../access.log
rm ../error.log
rm ../../docs.ssmods.com/access.log
rm ../../docs.ssmods.com/error.log

#update code base
git fetch --all
latesttag=$(git describe --tags `git rev-list --tags --max-count=1`)
echo checking out ${latesttag}
git checkout ${latesttag}

composer install

# delete ones we do not need
rm cms -rf
rm reports -rf
rm siteconfig -rf

php framework/cli-script.php dev/build
#php framework/cli-script.php dev/resque/run queue=first_build,update

# Updates the available SilverStripe versions.
php framework/cli-script.php dev/tasks/UpdateSilverStripeVersionsTask

# Runs the add-on updater.
php framework/cli-script.php dev/tasks/UpdateAddonsTask

# Deletes addons which haven't been updated from packagist in a specified amount of time,
# which implies they're no longer available there.
php framework/cli-script.php dev/tasks/DeleteRedundantAddonsTask

# Manually build addons, downloading screenshots and a README for display through the website.
# There's no need to set up a cron job for this task if you're using the resque queue.
# php framework/cli-script.php dev/tasks/BuildAddonsTask

# Defines and refreshes the elastic search index.
# php framework/cli-script.php dev/tasks/SilverStripe-Elastica-ReindexTask

# Caches Helpful Robot scores and data, so they can be displayed on listing and detail pages, for each addon.
# This also removes modules that cannot be loaded by requests to their repository URLs.
#php framework/cli-script.php dev/tasks/CacheHelpfulRobotDataTask



# create main page ...
php framework/cli-script.php / > cache/index_temp.html
rm cache/index.html -rf
mv cache/index_temp.html cache/index.html
chmod 0777 cache/index.html


#create topics
php framework/cli-script.php topics/ > ../../topics.ssmods.com/public_html/index.html


# create api
php framework/cli-script.php dev/tasks/AddonsBuildAPIByBash

echo "======================================================";
echo "======================================================";
echo "======================================================";

date

echo "======================================================";
echo "======================================================";
echo "======================================================";
