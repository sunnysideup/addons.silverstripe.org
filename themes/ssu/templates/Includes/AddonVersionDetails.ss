
<% if $FrameworkSupport %>
<% loop $FrameworkSupport %>
<span data-filter="Supports" class="dl">$Supports</span>.x<% if $Last %><% else %>, <% end_if %>
<% end_loop %>
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
