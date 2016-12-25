<!DOCTYPE html>
<!--[if lt IE 7]> <html class=" ie6 oldie" lang="en"> <![endif]-->
<!--[if IE 7]>    <html class=" ie7 oldie" lang="en"> <![endif]-->
<!--[if IE 8]>    <html class=" ie8 oldie" lang="en"> <![endif]-->
<!--[if gt IE 8]><!--> <html lang="$ContentLocale"> <!--<![endif]-->
<head>
<% if HasItsOwnExtendedMetatags %>
    <!-- has its own ExtendedMetaTags in Page.php -->
<% else %>
    <% if ExtendedMetaTags %>
    $ExtendedMetaTags
    <% else %>
    <% base_tag %>
    <title><% if $MetaTitle %>$MetaTitle<% else %>$Title<% end_if %> &raquo; $SiteConfig.Title</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    $MetaTags(false)
    <link rel="shortcut icon" href="$ThemeDir/images/favicon.ico" />
    <% end_if %>
<% end_if %>
</head>
<body id="Body$ClassName" class="mobileBrowsing">
<div id="Wrapper">
    <div id="Container">
        <% include Navigation %>
         <div id="Layout" class="typography">
            <a href="#" class="menuButton">menu</a>
            <% include Breadcrumbs %>
            <div id="LayoutHolder">$Layout</div>
            <footer>
                <span class="backToTop"><a href="#Wrapper">back to top</a></span>
                <div id="CopyrightMessage">$SiteConfig.CopyrightNotice</div>
            </footer>
        </div>
    </div>
</div>
<!-- include Analytics -->
</body>
</html>
