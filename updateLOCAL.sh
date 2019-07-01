#!/bin/bash

composer install --no-dev

mkdir cache

php framework/cli-script.php dev/build flush=all
#php framework/cli-script.php dev/resque/run queue=first_build,update

# Updates the available SilverStripe versions.
php framework/cli-script.php dev/tasks/UpdateSilverStripeVersionsTask

# Runs the add-on updater.
php framework/cli-script.php dev/tasks/UpdateAddonsTask

# Deletes addons which haven't been updated from packagist in a specified amount of time,
# which implies they're no longer available there.
php framework/cli-script.php dev/tasks/DeleteRedundantAddonsTask



# create main page ...
php framework/cli-script.php / > cache/index_temp.html
rm cache/index.html -rf
mv cache/index_temp.html cache/index.html
chmod 0777 cache/index.html


#create topics
#php framework/cli-script.php topics/ > ../../topics.ssmods.com/public_html/index.html


# create api
#php framework/cli-script.php dev/tasks/AddonsBuildAPIByBash

echo "======================================================";
echo "======================================================";
echo "======================================================";

date

echo "======================================================";
echo "======================================================";
echo "======================================================";








