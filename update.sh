 class="dl"#!/bin/bash

sake dev/build
#sake dev/resque/run queue=first_build,update

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

# save page
sake add-ons > cache/index.html


