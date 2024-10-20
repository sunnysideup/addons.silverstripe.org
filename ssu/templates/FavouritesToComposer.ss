{
    "name": "name of your project",

    "description": "Project created on ssmods.com - we have added Framework / CMS / Theme for convenience.  This may not be required.",

    "require": {
        "silverstripe/recipe-cms":                                     "*",
        <% if $Addons %><% loop $Addons %>
        "$Name":$Spacing"*"<% if Last %><% else %>,<% end_if %>
        <% end_loop %><% else %>
        "silverstripe-themes/simple":                                  "*",
        <% end_if %>
    },

    "scripts": {
        "post-install-cmd" : [
            "php framework/cli-script.php dev/build flush=1"
        ],
        "post-update-cmd" : [
            "php framework/cli-script.php dev/build flush=1"
        ]
    },

    "minimum-stability": "dev",

    "prefer-stable": true
}
