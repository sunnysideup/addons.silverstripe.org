<% include Header %>
<div id="LayoutHolder" class="typography">
    <h1>Silverstripe Modules by Topic</h1>

<div id="toc-topics">
    <ul>
    <% loop $MetaTopics %>
        <li><a href="#Metatopic$ID">$Title</a>: <% loop Topics %><a href="#Topic$ID" class="light">$Title</a><% if $Last %>.<% else %>, <% end_if %><% end_loop %></li>
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
            <h3 id="Topic$ID"><a href="#Topic$ID">$Title</a></h3>
            <% if $SortedKeywords %><% loop $SortedKeywords %><span class="pill">$Title</span><% end_loop %><% end_if %>
            <p class="desc metatopic">$Explanation</p>
            <% if MyModulesQuick %>
            <ul>
                <% loop MyModulesQuick %>
                <li class="hide">
                    <% if $LinkNew %>
                    <a href="$LinkNew">$Name</a>: $Description
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
    <p class="back-to-top action-p"><a href="#top">back to top</a>
    </div>
<% end_loop %>






<% if RestAddons %>
    <div class="meta-topic">
        <h2>Not yet classified</h2>
        <div class="topic closed">
            <h3 id="Topic9999999"><a href="#Topic9999999">Modules without categorisation</a></h3>
            <p>Below is a list of modules that have not been places under any topic.</p>
            <ul>
        <% loop RestAddons %>
                <li class="hide">
                <% if $Repository %>
                    <a href="$Repository.URL">$Name</a>: $Description
                <% else %>
                    <a>$Name</a>: $Description
                <% end_if %>
                    <% if $Keywords %><% loop $Keywords %><span class="pill">$Title</span><% end_loop %><% end_if %>
                </li>
        <% end_loop %>
            </ul>
        </div>
    </div>
<% end_if %>


</div>
<p class="back-to-top action-p"><a href="#top">back to top</a>


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

</script>

<% include Footer %>
