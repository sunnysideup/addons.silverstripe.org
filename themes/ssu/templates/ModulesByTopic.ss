<% include Header %>
<div id="LayoutHolder" class="typography">
    <h1>Silverstripe Modules by Topic</h1>

<div id="toc-topics">
    <ul>
    <% loop $MetaTopics %>
        <li><a href="#Metatopic$ID" class="int">$Title</a>: <% loop Topics %><a href="#Topic$ID" class="light int">$Title</a><% if $Last %>.<% else %>, <% end_if %><% end_loop %></li>
    <% end_loop %>
    </ul>

</div>

<% loop $MetaTopics %>
    <div id="Metatopic$ID" class="meta-topic">
        <h2>$Title</h2>
        <% if $Explanation %><p class="desc metatopic">$Explanation</p><% end_if %>

    <% if $Topics %>
        <% loop $Topics %>
        <div class="topic closed">
            <h3 id="Topic$ID"><a href="#Topic$ID" class="int">$Title</a></h3>
            <% if $SortedKeywords %><% loop $SortedKeywords %><span class="pill">$Title</span><% end_loop %><% end_if %>
            <p class="desc metatopic">$Explanation</p>
            <% if MyModulesQuick %>
            <ul>
                <% loop MyModulesQuick %>
                <li class="hide">
                    <% if $LinkNew %>
                    <a href="$LinkNew" class="ext">$Name</a>: $Description
                    <% else %>
                    <a>$Name</a>: $Description
                    <% end_if %>
                </li>
                <% end_loop %>
            </ul>
            <% else %>
            <p class="warning message">There are no modules for this topic.</p>
            <% end_if %>
        </div>
        <% end_loop %>
    <% end_if %>
        <p class="back-to-top action-p"><a  class="int" href="#LayoutHolder">back to top</a>
    </div>
<% end_loop %>






<% if RestAddons %>
    <div class="meta-topic">
        <h2>Not yet classified</h2>
        <div class="topic closed">
            <h3 id="Topic9999999"><a href="#Topic9999999" class="int">Modules without categorisation</a></h3>
            <p>Below is a list of modules that have not been places under any topic.</p>
            <ul>
        <% loop RestAddons %>
                <li class="hide">
                <% if $Repository %>
                    <a href="$Repository.URL" class="ext">$Name</a>: $Description
                <% else %>
                    <a>$Name</a>: $Description
                <% end_if %>
                    <% if $Keywords %><% loop $Keywords %><span class="pill">$Title</span><% end_loop %><% end_if %>
                </li>
        <% end_loop %>
            </ul>
        </div>
        <p class="back-to-top action-p"><a href="#LayoutHolder" class="int">back to top</a>
    </div>
<% end_if %>


</div>


<script>


var loadMyStuff = function(){
    jQuery('.topic ul').each(
        function(i, ul) {
            /* show first three */
            jQuery(ul).children('li').each(
                function(j, li) {
                    if(j < 3) {
                        jQuery(li).removeClass('hide');
                    }
                }
            );
            jQuery(ul).closest('.topic').find('h3 > a').click(
                function(e) {
                    jQuery(this)
                        .toggleClass('opened')
                        .toggleClass('closed');
                    jQuery(this).closest('.topic')
                        .toggleClass('opened')
                        .toggleClass('closed');
                    return false;
                }
            );
        }
    );
}
loadMyStuff();
jQuery(document).ready(
    function()
    {
        jQuery('a.int').on(
            'click',
            function (e) {
                e.preventDefault();
                window.location.hash = '';
                var target = jQuery(this).attr('href');
                var targets = target.split("#");
                target = target.split("#")[1];
                // var jQtarget = jQuery('#' + target);
                //
                // jQuery('html, body').animate(
                //     {'scrollTop': jQtarget.offset().top},
                //     900,
                //     'swing',
                //     function () {
                window.location.hash = target;
                //     }
                // );
            }
        );
        jQuery('a.ext').on(
            'click',
            function (e) {
                jQuery(this).attr({
                    target: "_blank",
                    title: "Opens in a new window"
                });
                return true;
            }
        );
    }
);

</script>

<% include Footer %>
