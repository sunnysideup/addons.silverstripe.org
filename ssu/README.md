Install DEV copy
==================


```sh

# fork project
# https://help.github.com/articles/fork-a-repo/

# clone
git clone git@github.com:sunnysideup/addons.silverstripe.org.git


# get changes from original
git remote -v
git remote add upstream git@github.com:silverstripe/addons.silverstripe.org.git
git remote -v
git fetch upstream
git checkout master
git merge upstream/master

```

Install on Ubuntu
==================

```sh

# fork project
# https://help.github.com/articles/fork-a-repo/

# clone
git clone git@github.com:sunnysideup/addons.silverstripe.org.git

# cd
cd addons.silverstripe.org

# composer
composer install --dev

# elastic search
# https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-elasticsearch-on-ubuntu-14-04
#  https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-elasticsearch-on-ubuntu-16-04
# https://www.elastic.co/guide/en/elasticsearch/reference/current/index.html
sudo dpkg -i elasticsearch-1.7.2.deb

# redis
# https://hostpresto.com/community/tutorials/how-to-install-and-configure-redis-on-ubuntu-14-04/
# https://www.digitalocean.com/community/tutorials/how-to-install-and-use-redis
# https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-redis-on-ubuntu-16-04
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install build-essential
sudo apt-get -y install redis-server

# check redis status
sudo service redis-server status
sudo netstat -naptu | grep LISTEN
sudo service redis-server restart

########## START CRON ###########

# update DB
sake dev/build

# sake dev/resque/run queue=first_build,update

# Updates the available SilverStripe versions.
sake dev/tasks/UpdateSilverStripeVersionsTask

# Runs the add-on updater.
sake dev/tasks/UpdateAddonsTask

# Deletes addons which haven't been updated from packagist in a specified amount of time,
# which implies they're no longer available there.
sake dev/tasks/DeleteRedundantAddonsTask

# Manually build addons, downloading screenshots and a README for display through the website.
# There's no need to set up a cron job for this task if you're using the resque queue.
sake dev/tasks/BuildAddonsTask

# Defines and refreshes the elastic search index.
sake dev/tasks/SilverStripe-Elastica-ReindexTask

# Caches Helpful Robot scores and data, so they can be displayed on listing and detail pages, for each addon.
# This also removes modules that cannot be loaded by requests to their repository URLs.
sake dev/tasks/CacheHelpfulRobotDataTask


########## END CRON ###########
# set up cronjob with the steps above

# install GOD? http://godrb.com/

```

THINGS TO ADD
=============

1. change search form to have the following fields:

 * current search
 * + must have all of these tags
 * + may have any of these tags
 * + may not have any of these tags
 * + Silverstripe minimum version number

2. new css

3. remove all non-essentials

4. ability to save searches

5. ability to put together a collection and share it (and create a list of favourites)
