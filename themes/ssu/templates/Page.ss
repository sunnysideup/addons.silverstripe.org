<!DOCTYPE html>
<html>
    <head>
        <% base_tag %>
        <title>$Title &middot; SilverStripe Add-ons</title>
        $MetaTags(false)
        <% require themedCSS("ssu") %>
        <link rel="stylesheet" href="$ThemeDir/css/ionicons.min.css" />
        <script type="text/javascript" src="//use.typekit.net/emt4dhq.js"></script>
        <script type="text/javascript">try{Typekit.load();}catch(e){}</script>
    </head>

    <body class="theme-theme1">
        <header>
        </header>

        <div id="layout" class="container">
            $Layout
        </div>

        <% include Footer %>

    </body>
</html>
