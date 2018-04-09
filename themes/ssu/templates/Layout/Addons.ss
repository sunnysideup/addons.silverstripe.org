
<header>
    <h1 id="header">Find Silverstripe Themes and Modules <sup>BETA</sup></h1>
    <p>
        Provided by <a href="http://www.sunnysideup.co.nz/">Sunny Side Up</a>.
        Silverstripe specialists since 2007.
    </p>
 </header>
<% if $Addons %>
<main class="tfs-holder loading">

    <% include TableFilterSortHeader %>

    <table class="tfs-table">
        <thead>
            <tr>
                <th scope="col" class="icon-col" title="add to recipe">FAV</th>
                <th scope="col" class="icon-col">API</th>
                <th scope="col" class="icon-col">GIT</th>

                <th scope="col" class="title-col">
                    <a href="#"
                        class="sortable"
                        data-sort-field="Name"
                        data-sort-direction="asc"
                        data-sort-type="string"
                    >Title</a>
                    ¶
                    <a href="#"
                        class="sortable"
                        data-sort-field="Tea"
                        data-sort-direction="asc"
                        data-sort-type="string"
                    >Vendor</a>

                </th>



                <th scope="col" class="description-col">Description + Tags</th>

                <th scope="col" class="number">
                    Edited:
                    <a href="#"
                        class="sortable"
                        data-sort-field="Created_U"
                        data-sort-direction="desc"
                        data-sort-type="number"
                        data-sort-default="true"
                        data-sort-only="true"
                    >first</a> &gt;
                    <a href="#"
                        class="sortable"
                        data-sort-field="LastEdited_U"
                        data-sort-direction="desc"
                        data-sort-type="number"
                        data-sort-only="true"
                    >last</a>
                </th>
                <th scope="col" class="number">
                    <a href="#"
                        class="sortable"
                        data-sort-field="Installs"
                        data-sort-direction="desc"
                        data-sort-type="number"
                        data-sort-only="true"
                    >Installs</a>
                    ¶
                    <a href="#"
                        class="sortable"
                        data-sort-field="Trending"
                        data-sort-direction="desc"
                        data-sort-type="number"
                        data-sort-only="true"
                        >Trending</a>
                </th>
                <th scope="col" class="works-with">
                    For
                </th>

            </tr>
        </thead>
        <tbody>
        <% include AddonsBody %>
        </tbody>

    </table>

    <% include TableFilterSortFooter %>


</main>
<% else %>
    <p>There are no add-ons to display.</p>
<% end_if %>



<script>
jQuery(document).ready(
    function() {

        jQuery('.tfs-current-favourites ul').prepend('<li class="download favouritestocomposer"><a href="#" class="button" data-rel="/favouritestocomposer">❤❤❤ Download your selection as a <u>composer.json file</u> ❤❤❤</a></li>');

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
                    var packageName = tr.find('span.exact-name').first().text().trim();
                    if(packageName.indexOf('silverstripe-') === -1) {
                        var packageNameLong = 'silverstripe-' + packageName;
                    } else {
                        var packageNameLong = packageName;
                    }
                    var vendorName = tr.find('span[data-filter="Team"]').text().trim();
                    var id = tr.attr('id').replace(/tfs/, '');
                    var html = '<ul class="hidden opened badges">';
                       html += '<li class="text composer-link">composer require <a href="/favouritestocomposer?ids='+id+'"><strong>'+vendorName+'/'+packageName+'</strong></a></li>';
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
                    html += '<li class="text"><a href="https://packagist.org/packages/'+vendorName+'/'+packageName+'" target="_addons">\&raquo; packagist.org</a></li>';
                    html += '</ul>';
                    tr.find('td:hidden').each(
                        function(i, el) {
                            html += '<div class="inner-cell">';
                            html += jQuery(el).html();
                            html += '</div>';
                        }
                    );
                    tr.find('th').append(html);
                    tr.addClass('more-added');
                    return false;
                }
            }
        );


        jQuery('tbody').on(
            'click',
            '.doc',
            function(event) {
                event.preventDefault();
                var width = Math.round(jQuery(window).width() * 0.95) - 40;
                var height = Math.round(jQuery(window).height() * 0.95) - 40;
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
