#!/bin/bash

echo "======================================================";
echo "======================================================";
echo "======================================================";

date

echo "======================================================";
echo "======================================================";
echo "======================================================";

#  update code base
cd /var/www/ssmods.com/public_html/

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

cd /var/www/ssmods.com/public_html 
php framework/cli-script.php / > cache/index_temp.html
rm cache/index.html -rf
mv cache/index_temp.html cache/index.html
chmod 0777 cache/index.html

gzip < cache/index.html > cache/index.html.gz

# create topics
cd /var/www/ssmods.com/public_html
php framework/cli-script.php dev/tasks/AcceptAllTopicChanges
php framework/cli-script.php topics/ > ../../topics.ssmods.com/public_html/index.html


#create docs script
cd /var/www/ssmods.com/public_html

echo "======================================================";
echo "======================================================";
echo "======================================================";

date

echo "======================================================";
echo "======================================================";
echo "======================================================";
