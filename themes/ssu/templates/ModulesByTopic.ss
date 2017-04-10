<% include Header %>
<div id="LayoutHolder" class="typography">
    <h1>Silverstripe Modules by Topic<sup>beta</sup></h1>
    <p>
        Below is a list of all silverstripe modules, categorised by topic.
        More information about this site can be found in <a href="#footer">the footer.
    </p>

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
        <div class="topic closed" data-id="$ID">
            <h3 id="Topic$ID"><a href="#Topic$ID" class="int">$Title</a></h3>
            <% if $SortedKeywords %><% loop $SortedKeywords %><% if $Ignore %><% else %><span class="pill">$Title</span><% end_if %><% end_loop %><% end_if %>
            <p class="desc metatopic">$Explanation</p>
            <% if MyModulesQuick %>
            <ul>
                <% loop MyModulesQuick %>
                <li class="hide">
                    <a href="/" class="change" data-id="$ID">✎</a>
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
        <p class="back-to-top action-p"><a  class="int" href="#LayoutHolder">back to top</a></p>
    </div>
<% end_loop %>






<% if RestAddons %>
    <div class="meta-topic">
        <h2>Not yet classified</h2>
        <div class="topic closed" data-id="$ID">
            <h3 id="Topic0"><a href="#Topic0" class="int">Modules without categorisation</a></h3>
            <p>Below is a list of modules that have not been places under any topic.</p>
            <ul>
        <% loop RestAddons %>
                <li class="hide">
                    <a href="/" class="change" data-id="$ID">✎</a>
                <% if $Repository %>
                    <a href="$Repository.URL" class="ext">$Name</a>: $Description
                <% else %>
                    <a>$Name</a>: $Description
                <% end_if %>
                    <% if $Keywords %><% loop $Keywords %><% if $Ignore %><% else %><span class="pill">$Title</span><% end_if %><% end_loop %><% end_if %>
                </li>
        <% end_loop %>
            </ul>
        </div>
        <p class="back-to-top action-p"><a href="#LayoutHolder" class="int">back to top</a></p>
    </div>
<% end_if %>


</div>

<div id="change-form-holder" style="display: none;">
    <form action="http://topics.ssmods.com/change-topic.php" method="get">
        <select class="change-selector" >
        <% loop $MetaTopics %>
          <optgroup label="$Title">
              <% loop $Topics %><option value="$ID">$Title</option><% end_loop %>
          </optgroup>
        <% end_loop %>
        </select>
        <input type="submit" value="request change" />
    </form>
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

        //internal links
        jQuery('a.int').on(
            'click',
            function (e) {
                e.preventDefault();
                // window.location.hash = '';
                var target = jQuery(this).attr('href');
                var targets = target.split("#");
                target = target.split("#")[1];
                var jQtarget = jQuery('#' + target);

                jQuery('html, body').animate(
                    {'scrollTop': jQtarget.offset().top},
                    900,
                    'swing',
                    function () {
                        window.location.hash = target;
                    }
                );
            }
        );

        //external links ...
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

        //change
        var changeFormHTML = jQuery('#change-form-holder').first().html();
        jQuery('a.change').on(
            'click',
            function(e)
            {
                e.preventDefault();
                //immediate variables
                var a = jQuery(this);
                var li = a.closest('li');
                var id = a.attr('data-id');
                var oldCategory = li.closest('.topic').attr('data-id');
                //changes ...
                a.fadeOut();
                li.prepend(changeFormHTML);
                //find form and select ...
                var form = li.find('form');
                var select = form.find('select');
                select.
                    val(oldCategory).
                    attr('data-old-category', oldCategory).
                    attr('data-id', id);
                form.on(
                    'submit',
                    function(event)
                    {
                        event.preventDefault();
                        //values
                        var form = jQuery(this);
                        var select = form.find('select');
                        var newCategory = select.val();
                        //create data
                        var data = {};
                        data.id = select.attr('data-id');
                        data.from = select.attr('data-old-category');
                        data.to = newCategory;
                        //submit
                        jQuery.ajax(
                            {
                                type: form.attr('method'),
                                crossDomain: true,
                                url: form.attr('action'),
                                data: data,
                                dataType: 'html',
                                cache: false,
                                success: function() {
                                    var li = for.closest('li');
                                    li.addClass('changed');
                                    form.remove();
                                    a.fadeIn();
                                },
                                error: function(){
                                    form.remove();
                                    a.fadeIn();
                                    alert('Sorry, there was an error - please try again.');
                                }
                            }
                        );
                    }
                );
            }
        );
    }
);


</script>

<% include Footer %>
