<% if $LastTaggedVersion %>
<% with $LastTaggedVersion %>
<% if FrameworkRequires %>
    <% with FrameworkRequires %>
        <span data-filter="Framework Version" class="dl">$ConstraintSimple</span>
    <% end_with %>
<% end_if %>

<div style="display: none;" class="hidden">
<h5>Latest Release</h5>
$PrettyVersion
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

<h5>Total Releases:</h5>
$Versions.Count
</div>
