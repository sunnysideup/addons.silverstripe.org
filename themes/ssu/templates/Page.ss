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
        <h3>Credits and Important Notes</h3>
        <p>
            This site is based on the <a href="http://addons.silverstripe.org">the original Silverstripe addons site</a>.
            It does not replace it, but it provides a simpler theme.
            Searches here are less inclusive and less reliable than the original site, but they also more finegrained.
        </p>
        <span class="backToTop"><a href="#Wrapper">back to top</a></span>
        Last Updated: $Date('Y m d h:n e')
    </footer>
</div>
<!-- include Analytics -->
<script>

</script>
</body>
</html>
