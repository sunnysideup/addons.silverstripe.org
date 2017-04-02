<% include Header %>

    <div id="LayoutHolder" class="typography">
        <h1>Silverstripe Modules by Topic</h1>
<% loop Topics %>
    <div class="topic">
        <p class="show-all closed action-p"><a href="#Topic$ID">see all</a></p>
<h2 id="Topic$ID">$Title</h2>
<% if $SortedKeywords %><% loop $SortedKeywords %><span class="pill">$Title</span><% end_loop %><% end_if %>
<p class="desc">$Explanation</p>
<% if MyModulesQuick %>
<ul>
    <% loop MyModulesQuick %>
    <li class="module-$Pos"><a href="$Repository.URL">$Name</a>: $Description</li>
    <% end_loop %>
</ul>
<% else %>
    <p class="warning message">There are no modules for this topic.</p>
<% end_if %>
</div>
<% end_loop %>

<% if RestAddons %>
    <div class="topic">
        <p class="show-all closed action-p"><a href="#Topic9999999">see all</a></p>
<h2 id="Topic9999999">Modules without categorisation</h2>
<p>Below is a list of modules that have not been places under any topic.</p>
<ul>
    <% loop RestAddons %>
    <li class="module-$Pos">
        <a href="$Repository.URL">$Name</a>:
        $Description
        <% if $Keywords %><% loop $Keywords %><span class="pill">$Title</span><% end_loop %><% end_if %>
    </li>
    <% end_loop %>
</ul>
</div>
<p class="back-to-top action-p"><a href="#top">back to top</a>

<% end_if %>


$Layout

<script>

    var loadMyStuff = function(){
            jQuery('.topic ul').each(
                function(i, ul) {
                    jQuery(ul).children('li').each(
                        function(j, li) {
                            if(j > 2) {
                                jQuery(li).addClass('hide');
                            }
                        }
                    );
                    var div = jQuery(ul).closest('.topic');
                    div.find('.show-all').click(
                            function(e) {
                                jQuery(this)
                                    .toggleClass('opened')
                                    .toggleClass('closed');
                                var div = jQuery(this).closest('.topic')
                                div.toggleClass('')
                                    .toggleClass('opened')
                                    .toggleClass('closed')
                                    .find('li').each(
                                        function(j, li) {
                                            if(j > 2) {
                                                jQuery(li).toggleClass('hide');
                                            }
                                        }
                                );
                                return true;
                            }
                        );
                }
            )

        }
    loadMyStuff();

</script>

<% include Footer %>
