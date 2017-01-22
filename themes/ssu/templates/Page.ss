<!DOCTYPE html>
<!--[if lt IE 7]> <html class=" ie6 oldie" lang="en"> <![endif]-->
<!--[if IE 7]>    <html class=" ie7 oldie" lang="en"> <![endif]-->
<!--[if IE 8]>    <html class=" ie8 oldie" lang="en"> <![endif]-->
<!--[if gt IE 8]><!--> <html lang="$ContentLocale"> <!--<![endif]-->
<head>
    <% if ExtendedMetaTags %>
    $ExtendedMetaTags
    <% else %>
    <% base_tag %>
    <title><% if $MetaTitle %>$MetaTitle<% else %>$Title<% end_if %></title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
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
        <p>Comments and questions can be directed to ssmods [at] <a href="http://www.sunnysideup.co.nz/">sunny side up</a>.</p>

        <h3>Last Updated</h3>
        <p>$LocalNow</p>

        <h3>Last Word</h3>
        <p style="color: green;">Vote Green ;-)</p>
    </footer>
</div>
<!-- include Analytics -->
<script>
var TableFilterSortTableList = ['.tfs-holder'];
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
    }
);

</script>
</body>
</html>
