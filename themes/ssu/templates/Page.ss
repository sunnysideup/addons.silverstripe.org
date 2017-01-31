<!DOCTYPE html>
<html lang="en">
<head>
    <% if ExtendedMetaTags %>
    $ExtendedMetaTags
    <% else %>
    <% base_tag %>
    <title><% if $MetaTitle %>$MetaTitle<% else %>$Title<% end_if %></title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0">
    $MetaTags(false)
    <% end_if %>
</head>
<body>
<div id="Wrapper">

    <div id="LayoutHolder">$Layout</div>

    <footer>
        <h3>Credits</h3>
        <p>
            This site is based on the <a href="http://addons.silverstripe.org">the original Silverstripe addons site</a>.
            It does not replace it, but it provides simply a different way to find <a href="http://www.silverstripe.org">Silverstripe Modules</a> and Themes.
        </p>

        <h3>Disclaimer</h3>
        <p>
            Do not rely on search results provided here.
            They can be misleading and out-of-date.
        </p>

        <h3>Feedback</h3>
        <p>
            Comments and questions can be directed to ssmods [at] <a href="http://www.sunnysideup.co.nz/">sunny side up</a>.
            If you need help building Silverstripe websites then read our <a href="http://sunnysideup.co.nz/info-for-digital-agencies">info for digital agencies</a>.
        </p>

        <h3>Last Updated</h3>
        <p>$LocalNow</p>
    </footer>
</div>
<!-- include Analytics -->
<script>
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','https://www.google-analytics.com/analytics.js','ga');

  ga('create', 'UA-25091781-1', 'auto');
  ga('send', 'pageview');

</script>
<script>
jQuery(document).ready(
    function() {

        jQuery('.tfs-current-favourites ul').prepend('<li class="download favouritestocomposer"><a href="#" class="button" data-rel="/favouritestocomposer">Download Favourites (❤) as composer.json</a></li>');

        jQuery('.favouritestocomposer').on(
            'click',
            'a',
            function(event){
                var myEl = jQuery(this);
                var arrayOfFavs = [];
                jQuery('tr.fav').each(
                    function(i, row) {
                        row = jQuery(row);
                        var id = row.attr('id');
                        id = id.replace(/\\D/g,'');
                        arrayOfFavs.push(id);
                    }
                );
                if(arrayOfFavs.length > 0) {
                    var url = myEl.attr('data-rel') + '?ids=' + arrayOfFavs.join(',');
                    myEl.attr('href', url);
                    return true;
                }
                alert("Please select some favourites (click on the hearts) first.");
                return false;
            }
        );

        jQuery('.tfs-holder').on(
            'click',
            '.more',
            function(e) {
                e.preventDefault();
                var tr = jQuery(this).closest('tr');
                if( tr.hasClass('more-added') === false) {
                    tr.on(
                        'error',
                        'img',
                        function() {
                            alert('eerr');
                            jQuery(this).hide();
                        }
                    );
                    var linksAndImages = [
                        ['Build Status', 'https://api.travis-ci.org/#VENDOR#/#PACKAGE-LONG#.svg?branch=master', 'https://travis-ci.org/#VENDOR#/#PACKAGE-LONG#'],
                        ['Scrutinzer', 'https://scrutinizer-ci.com/g/#VENDOR#/#PACKAGE-LONG#/badges/quality-score.png?b=master', 'https://scrutinizer-ci.com/g/sunnysideup/#VENDOR#-ecommerce/?branch=master'],
                        ['Latest Stable Version', 'https://poser.pugx.org/#VENDOR#/#PACKAGE#/version.svg', 'http://www.#VENDOR#.org/stable-download/'],
                        ['Latest Unstable Version', 'https://poser.pugx.org/#VENDOR#/#PACKAGE#/v/unstable.svg', 'https://packagist.org/packages/#VENDOR#/#PACKAGE#'],
                        ['codecov', 'https://codecov.io/gh/#VENDOR#/#PACKAGE-LONG#/branch/master/graph/badge.svg', 'https://codecov.io/gh/#VENDOR#/#PACKAGE-LONG#'],
                        ['Total Downloads', 'https://poser.pugx.org/#VENDOR#/#PACKAGE#/downloads.svg', 'https://packagist.org/packages/#VENDOR#/#PACKAGE#'],
                        ['License', 'https://poser.pugx.org/#VENDOR#/#PACKAGE#/license.svg', 'https://github.com/#VENDOR#/#PACKAGE-LONG#license'],
                        ['Dependency Status', 'https://www.versioneye.com/php/#VENDOR#:#PACKAGE#/badge.svg', 'https://www.versioneye.com/php/#VENDOR#:#PACKAGE#'],
                        ['Reference Status', 'https://www.versioneye.com/php/#VENDOR#:#PACKAGE#/reference_badge.svg?style=flat', 'https://www.versioneye.com/php/#VENDOR#:#PACKAGE#/references'],
                        ['helpfulrobot', 'https://helpfulrobot.io/#VENDOR#/#PACKAGE#/badge', 'https://helpfulrobot.io/#VENDOR#/#PACKAGE#/badge'],
                    ];
                    var packageName = tr.find('span[data-filter="Title"]').text().trim();
                    if(packageName.indexOf('silverstripe-') === -1) {
                        var packageNameLong = 'silverstripe-' + packageName;
                    } else {
                        var packageNameLong = packageName;
                    }
                    var vendorName = tr.find('span[data-filter="Team"]').text().trim();
                    var id = tr.attr('id').replace(/tfs/, '');
                    var html = '<ul class="hidden opened badges">';
                       html += '<li class="text">composer require <a href="/favouritestocomposer?ids='+id+'"><strong>'+vendorName+'/'+packageName+'</strong></a></li>';
                       html += '<li class="text">For more information visit: <a href="https://addons.silverstripe.org/add-ons/'+vendorName+'/'+packageName+'">addons.silverstripe.org</a></li>';
                    for(var i = 0; i < linksAndImages.length; i++) {
                        if(linksAndImages[i].length === 3) {
                            var title = linksAndImages[i][0];
                            var src = linksAndImages[i][1];
                            src = src.replace(/#PACKAGE-LONG#/, packageNameLong);
                            src = src.replace(/#VENDOR#/, vendorName);
                            src = src.replace(/#PACKAGE#/, packageName);
                            var href = linksAndImages[i][2];
                            href = href.replace(/#PACKAGE-LONG#/, packageNameLong);
                            href = href.replace(/#VENDOR#/, vendorName);
                            href = href.replace(/#PACKAGE#/, packageName);
                            html += "<li>";
                            html += '<a href="'+href+'" target="_blank">';
                            html += '<img src="'+src+'" alt="'+title+'" onerror="javascript:jQuery(this).closest(\\'li\\').remove();"/>';
                            html += "</a></li>";
                        }
                    }
                    html += '</ul>';
                    tr.find('th').append(html);
                    tr.addClass('more-added');
                    return false;
                }
            }

        );

    }
);

</script>

</body>
</html>
