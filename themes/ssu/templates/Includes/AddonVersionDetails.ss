
<% if $FrameworkSupport %>
<% loop $FrameworkSupport %><% if $Last %><% if First %><% else %> and <% end_if %><% else %><% if First %><% else %>, <% end_if %><% end_if %><span data-filter="Supports" class="dl">$Supports.*</span><% end_loop %>
<% else %>
<span data-filter="Supports" class="dl">tba</span>
<% end_if %>

<div class="hidden">
<% if $LastTaggedVersion %>
<% with $LastTaggedVersion %>

<% if Requires %>
<h5>Requires</h5>
<% include AddonVersionDetailsLinks Items=$Requires %>
<% end_if %>
<% if Suggests %>
<h5>Suggests</h5>
<% include AddonVersionDetailsLinks Items=$Suggests %>
<% end_if %>

<% if Provides %>
<h5>Provides</h5>
<% include AddonVersionDetailsLinks Items=$Provides %>
<% end_if %>

<% if Conflicts %>
<h5>Conflicts</h5>
<% include AddonVersionDetailsLinks Items=$Conflicts %>
<% end_if %>

<% if Replaces %>
<h5>Replaces</h5>
<% include AddonVersionDetailsLinks Items=$Replaces %>
<% end_if %>

<% end_with %>
<% end_if %>

<h5># Tags:</h5>
$Versions.Count
</div>
