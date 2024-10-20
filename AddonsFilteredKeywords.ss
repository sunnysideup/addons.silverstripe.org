<% if $FilteredKeywords %>
<ul class="hidden">
<% loop $FilteredKeywords %>
    <li><span data-filter="Tag" class="dl">$Name</span></li>
<% end_loop %>
</ul>
<% end_if %>
