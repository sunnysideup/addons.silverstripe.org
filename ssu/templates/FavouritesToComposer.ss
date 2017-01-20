{
    "name": "my project",
    "description": "Project created on ssmods.com",
    "require": {
        "silverstripe/framework":                                      "3.*",
        "silverstripe/cms":                                            "3.*",
        <% if $Addons %><% loop $Addons %>
        "$Name":$Spacing"*"<% if Last %><% else %>,<% end_if %>
        <% end_loop %><% else %>
        "silverstripe-themes/simple":                                  "*",
        <% end_if %>
    },
    "require-dev": {
        "gdmedia/ss-auto-git-ignore": "*"
    },
    "scripts": {
        "post-install-cmd" : [
            "php framework/cli-script.php dev/build flush=1"
        ],
        "post-update-cmd" : [
            "php framework/cli-script.php dev/build flush=1",
            "$GDMString"
        ]
    },
    "minimum-stability": "dev",
    "prefer-stable": true
}
