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
    <script>
        (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
        (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
        m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
        })(window,document,'script','https://www.google-analytics.com/analytics.js','ga');

        ga('create', 'UA-25091781-1', 'auto');
        ga('send', 'pageview');

    </script>
</head>
<body>
<div id="Wrapper">

    <div id="LayoutHolder">$Layout</div>

    <footer>

        <h3>Credits</h3>
        <p>
            This site is based on the <a href="http://addons.silverstripe.org">the original Silverstripe addons site</a>.
            It aims to provide an alternative way to find <a href="http://www.silverstripe.org">Silverstripe</a> Modules and Themes.
            A big thank you to Ralph and Aaron for their feedback.
        </p>

        <h3>Disclaimer</h3>
        <p>
            Do not rely on search results provided here.
            They can be misleading and out-of-date.
        </p>

        <h3>Feedback</h3>
        <p>
            We love your feedback.  <span class="email-us"></span>
        </p>

        <h3>Silverstripe Module Documentation / API</h3>
        <p>
            Looking for a myriad of code examples, API syntax, or additional documentation. Please visit our <a href="http://docs.ssmods.com/">api search</a>.
        </p>

        <h3>Need help building Silverstripe applications?</h3>
        <p>
            We can make your Silverstripe projects shine.
            For more information, please visit our <a href="http://sunnysideup.co.nz/info-for-digital-agencies">information for digital agencies</a>.
        </p>

        <h3>Last Updated</h3>
        <p>$LocalNow</p>
    </footer>
</div>

<script>
jQuery(document).ready(
    function() {

        jQuery('.tfs-current-favourites ul').prepend('<li class="download favouritestocomposer"><a href="#" class="button" data-rel="/favouritestocomposer">Download ❤ ❤ ❤ as composer.json</a></li>');

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
                            jQuery(this).hide();
                        }
                    );
                    var linksAndImages = [
                        ['Build Status', 'https://api.travis-ci.org/#VENDOR#/#PACKAGE-LONG#.svg?branch=master', 'https://travis-ci.org/#VENDOR#/#PACKAGE-LONG#'],
                        ['Scrutinzer', 'https://scrutinizer-ci.com/g/#VENDOR#/#PACKAGE-LONG#/badges/quality-score.png?b=master', 'https://scrutinizer-ci.com/g/#VENDOR#/#PACKAGE-LONG#/?branch=master'],
                        ['codecov', 'https://codecov.io/gh/#VENDOR#/#PACKAGE-LONG#/branch/master/graph/badge.svg', 'https://codecov.io/gh/#VENDOR#/#PACKAGE-LONG#'],
                        ['Latest Stable Version', 'https://poser.pugx.org/#VENDOR#/#PACKAGE#/version.svg', 'https://github.com/#VENDOR#/#PACKAGE-LONG#/tags'],
                        ['Latest Unstable Version', 'https://poser.pugx.org/#VENDOR#/#PACKAGE#/v/unstable.svg', 'https://github.com/#VENDOR#/#PACKAGE-LONG#'],
                        ['Dependency Status', 'https://www.versioneye.com/php/#VENDOR#:#PACKAGE#/badge.svg', 'https://www.versioneye.com/php/#VENDOR#:#PACKAGE#'],
                        ['Reference Status', 'https://www.versioneye.com/php/#VENDOR#:#PACKAGE#/reference_badge.svg', 'https://www.versioneye.com/php/#VENDOR#:#PACKAGE#/references'],
                        ['License', 'https://poser.pugx.org/#VENDOR#/#PACKAGE#/license.svg', 'https://github.com/#VENDOR#/#PACKAGE-LONG#/'],
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
                    html += '<li class="text"><a href="https://addons.silverstripe.org/add-ons/'+vendorName+'/'+packageName+'" target="_addons">\&raquo; addons.silverstripe.org</a></li>';
                    html += '</ul>';
                    tr.find('th').append(html);
                    tr.addClass('more-added');
                    return false;
                }
            }
        );

        var coded = "AA3EWA@AKqqvAdWmK5.FE.qO";
        var key = "y6Ms9uqhBOJXmGRZ2F10SgdPvIYAVKpa7LoN3rUT4ktlnjWzfbexHD5cC8EwiQ";
        var shift = coded.length;
        var link = "";
        for (i = 0; i < coded.length; i++) {
            if (key.indexOf(coded.charAt(i))==-1) {
                ltr = coded.charAt(i);
                link += (ltr);
            } else {
                ltr = (key.indexOf(coded.charAt(i))-shift+key.length) % key.length;
                link += (key.charAt(ltr));
            }
        }
        jQuery('.email-us').html("<a href='mailto:"+link+"'>Please e-mail us.</a>");

        jQuery('tbody').on(
            'click',
            '.doc',
            function(event) {
                event.preventDefault();
                var width = Math.round(jQuery(window).width() * 0.91);
                var height = Math.round(jQuery(window).height() * 0.91);
                var href = jQuery(this).attr('href');
                jQuery.modal(
                    '<iframe src="'+href+'" width="'+width+'"height="'+height+'" style="border:0" id="tfs-pop-up-i-frame" name="tfs-pop-up-i-frame">',
                    {
                        closeHTML:"close",
                        containerCss:{
                            backgroundColor:"#fff",
                            borderColor:"#fff",
                            padding:0,
                            width: width,
                            height: height

                        },
                        opacity: 75,
                        overlayClose:true,
                        onClose: function() {
                            jQuery.modal.close();
                        }
                    }
                );
                return false;
            }
        );

    }
);

</script>

</body>
</html>
